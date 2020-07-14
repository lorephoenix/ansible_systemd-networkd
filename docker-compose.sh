#!/usr/bin/bash

DCONFIG="tests/docker/docker-compose.ym1l"
DVALID=$(docker-compose -f $DCONFIG config | wc -l)

whereis travis_terminate
if [[ $DVALID > 0 ]]; then
    # -----------------------------------------------------------------------------
    # Validate configuration file
    # -----------------------------------------------------------------------------
    

    echo $DVALID

else
    echo "[Error] File not found"
    travis_terminate 1;
fi
exit 1

# -----------------------------------------------------------------------------
# Build or rebuild services
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG build 

# -----------------------------------------------------------------------------
# Validate and view config file
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG config

# -----------------------------------------------------------------------------
# Run container in detached state
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG up -d

# -----------------------------------------------------------------------------
# Install one or more role or one or more collections.
#   -f : force overwriting an existing role or collection.
#   -r : a file containing a list of roles to be imported.
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG exec systemd-networkd_archlinux ansible-galaxy install -f -r \
    /etc/ansible/requirements.yml
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_centos8 ansible-galaxy install -f -r \
    /etc/ansible/requirements.yml
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_fedora32 ansible-galaxy install -f -r \
    /etc/ansible/requirements.yml
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_manjaro ansible-galaxy install -f -r \
    /etc/ansible/requirements.yml

# -----------------------------------------------------------------------------
# Check syntax of ansible playbook
# -----------------------------------------------------------------------------
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_archlinux ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --syntax-check
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_centos8 ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --syntax-check
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_fedora32 ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --syntax-check
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_manjaro ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --syntax-check

# -----------------------------------------------------------------------------
# Run the role/playbook with ansible-playbook
# -----------------------------------------------------------------------------
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_archlinux ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --connection=local --become
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_centos8 ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --connection=local --become
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_fedora32 ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --connection=local --become
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_manjaro ansible-playbook /etc/ansible/test.yml -i \
    /etc/ansible/hosts --connection=local --become

# -----------------------------------------------------------------------------
# Run the role/playbook with ansible-playbook
# -----------------------------------------------------------------------------
docker-compose -f tests/docker/docker-compose.yml ps 


#dmax=$(docker-compose -f tests/docker/docker-compose.yml ps -a  | awk 'NR>2' | wc -l)

