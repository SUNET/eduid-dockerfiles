function get_docker_sudo_command {
    if [ $(id -u) -ne 0 ]; then
    # check if non-root user is member of the group 'docker', in which case
    # sudo is assumed to not be necessary
	if ! id | grep -q docker; then
	    echo 'sudo'
	fi
    fi
}

function get_repository_image_base {
    echo 'docker.sunet.se/eduid'
}

function get_local_image_base {
    echo 'local'
}

function check_is_subdirs {
    for this in $*; do
	dir=$(echo ${this} | awk -F : '{print $1}')
	test -d ${dir} || echo "Error: subdirectory $dir not found"
	test -d ${dir} || exit 1
    done
}
