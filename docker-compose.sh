#!/usr/bin/bash

# -----------------------------------------------------------------------------
# Customize containers
# -----------------------------------------------------------------------------
docker-compose -f tests/docker/docker-compose.yml build 

# -----------------------------------------------------------------------------
# Run container in detached state
# -----------------------------------------------------------------------------
docker-compose -f tests/docker/docker-compose.yml up -d

# -----------------------------------------------------------------------------
# Install one or more role or one or more collections.
#   -f : force overwriting an existing role or collection.
#   -r : a file containing a list of roles to be imported.
# -----------------------------------------------------------------------------
docker-compose -f tests/docker/docker-compose.yml exec \
    systemd-networkd_archlinux ansible-galaxy install -f -r \
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


