#!/bin/sh

set -e
set -x

log_dir=${log_dir-'/var/log/munin'}
run_dir=${run_dir-'/var/run/munin'}
datadir=${datadir-'/var/lib/munin'}
htmldir=${htmldir-'/var/cache/munin/www'}
cgitmpdir=${cgitmpdir-'/var/lib/munin/cgi-tmp'}
extra_args=${extra_args-''}

mkdir -p "${run_dir}"

for dir in "${log_dir}" "${run_dir}" "${datadir}" "${htmldir}"; do
    test -d "${dir}" && chown -R munin: "${dir}"
done

for dir in "${htmldir}" "${cgitmpdir}"; do
    test -d "${dir}" && chown -R www-data "${dir}"
done

# make sure log files exists before chowning
touch "${log_dir}"/{munin-cgi-graph.log,munin-cgi-html.log,munin-html.log}
chown www-data: "${log_dir}"/*graph* || true
chown www-data: "${log_dir}"/*html* || true

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
