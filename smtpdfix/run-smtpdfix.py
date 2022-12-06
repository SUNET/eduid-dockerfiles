# -*- coding: utf-8 -*-
import logging
import signal
import socket
import sys
from datetime import datetime, timedelta
from ipaddress import ip_address
from pathlib import Path
from time import sleep
from typing import Optional, Union

from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.x509 import (
    BasicConstraints,
    CertificateBuilder,
    DNSName,
    IPAddress,
    Name,
    NameAttribute,
    SubjectAlternativeName,
    random_serial_number,
)
from cryptography.x509.oid import NameOID
from smtpdfix import Config, SMTPDFix, AuthController

__author__ = "lundberg"

logging.basicConfig(
    stream=sys.stdout, format="[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s", level=logging.DEBUG
)
logger = logging.getLogger("SMTPDFixServer")


class SMTPDFixServer:
    def __init__(self):
        datadir = Path(__file__).with_name("data")
        self.config = Config()
        if Path("/.env").exists():
            self.config = Config(filename=".env", override=True)
        self.config.ssl_certs_path = datadir
        self.smtpdfix: Optional[AuthController] = None
        self._stop: bool = False

        for signame in {"SIGINT", "SIGTERM"}:
            signal.signal(getattr(signal, signame), self.stop)

        self.gen_cert(path=datadir)

    def gen_cert(
        self, path: Union[Path, str], days: int = 3652, key_size: int = 2048, separate_key: bool = False
    ) -> None:
        # DO NOT USE THIS FOR ANYTHING PRODUCTION RELATED, EVER!
        # Generate private key
        # 2048 is the minimum that works as of 3.9
        logger.info(f"Generating certificate in {path}")
        key = rsa.generate_private_key(public_exponent=65537, key_size=key_size)
        key_file = "key.pem" if separate_key else "cert.pem"
        key_path = Path(path).joinpath(key_file)
        with open(key_path, "ab") as f:
            f.write(
                key.private_bytes(
                    encoding=serialization.Encoding.PEM,
                    encryption_algorithm=serialization.NoEncryption(),
                    format=serialization.PrivateFormat.TraditionalOpenSSL,
                )
            )
        logger.info(f"Private key generated: {key_path}")

        # Generate public certificate
        hostname = socket.gethostname()
        subject = Name([NameAttribute(NameOID.COMMON_NAME, "smtpdfix_cert")])
        alt_names = [
            DNSName("localhost"),
            DNSName("localhost.localdomain"),
            DNSName(hostname),
            IPAddress(ip_address("127.0.0.1")),
            IPAddress(ip_address("0.0.0.1")),
            IPAddress(ip_address("::1")),
        ]
        if self.config.host and self.config.host != "localhost":
            alt_names.append(DNSName(self.config.host))

        # Because on misconfigured systems it's possible to have a hostname that
        # doesn't resolve to an IP we catch the error and skip adding it to the
        # list of altnames. (issue #195)
        try:
            ip = socket.gethostbyname(hostname)
            alt_names.append(IPAddress(ip_address(ip)))
        except socket.gaierror as err:
            logger.error(f"{hostname} failed to resolve to ip")
            logger.error(err.strerror)

        logger.info(f"Using hostname: {hostname}")
        logger.info(f"Using alt_names: {alt_names}")

        # Set it so the certificate can be a root certificate with
        # ca=true, path_length=0 means it can only sign itself.
        constraints = BasicConstraints(ca=True, path_length=0)

        cert = (
            CertificateBuilder()
            .issuer_name(subject)
            .subject_name(subject)
            .serial_number(random_serial_number())
            .not_valid_before(datetime.utcnow())
            .not_valid_after(datetime.utcnow() + timedelta(days=days))
            .add_extension(SubjectAlternativeName(alt_names), critical=False)
            .public_key(key.public_key())
            .add_extension(constraints, critical=False)
            .sign(private_key=key, algorithm=hashes.SHA256())
        )

        cert_path = Path(path).joinpath("cert.pem")
        with open(cert_path, "ab") as f:
            f.write(cert.public_bytes(serialization.Encoding.PEM))
        logger.info(f"Certificate generated: {cert_path}")

    def stop(self, *args, **kwargs) -> None:
        if self.smtpdfix:
            self._stop = True

    def run(self) -> None:
        with SMTPDFix(config=self.config) as smtpdfix:
            self.smtpdfix = smtpdfix
            print()
            print(f"SMTPDFix server listening on port {self.config.port}")
            print()
            print(f"ssl_certs_path: {self.config.ssl_certs_path}")
            print(f"use_ssl: {self.config.use_ssl}")
            print(f"auth_require_tls: {self.config.auth_require_tls}")
            print(f"use_starttls: {self.config.use_starttls}")
            print()
            print(f"username: {self.config.login_username}")
            print(f"password: {self.config.login_password}")
            print(f"enforce_auth: {self.config.enforce_auth}")
            print(f"ready_timeout: {self.config.ready_timeout}")
            print()
            while not self._stop:
                sleep(1)
            logger.info("SMTPDFix server stopped")


if __name__ == "__main__":
    SMTPDFixServer().run()
    sys.exit(0)
