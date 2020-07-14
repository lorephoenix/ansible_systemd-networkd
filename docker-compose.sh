#!/usr/bin/bash

# -----------------------------------------------------------------------------
# Specify an compose file
# -----------------------------------------------------------------------------
DCONFIG="tests/docker/docker-compose.yml"

# -----------------------------------------------------------------------------
# Validate configuration file
# -----------------------------------------------------------------------------
DVALID=$(docker-compose -f $DCONFIG config | wc -l)

if [[ $DVALID -eq 0 ]]; then
    # The variable DVALID has an integer equal to 0, which means not valid OR
    # empty.  
    echo "[Error] Compose file '$DCONFIG' not found"
    exit 1  
fi

# -----------------------------------------------------------------------------
# Validate and view config file
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG config

# -----------------------------------------------------------------------------
# Build or rebuild services
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG build

# -----------------------------------------------------------------------------
# Run container in detached state
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG up -d

# -----------------------------------------------------------------------------
# Install one or more role or one or more collections.
#   -f : force overwriting an existing role or collection.
#   -r : a file containing a list of roles to be imported.
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG exec systemd-networkd_archlinux ansible-galaxy \
    install -f -r /etc/ansible/requirements.yml
docker-compose -f $DCONFIG exec systemd-networkd_centos8 ansible-galaxy \
    install -f -r /etc/ansible/requirements.yml
docker-compose -f $DCONFIG exec systemd-networkd_fedora32 ansible-galaxy \
    install -f -r /etc/ansible/requirements.yml
docker-compose -f $DCONFIG exec systemd-networkd_manjaro ansible-galaxy \
    install -f -r /etc/ansible/requirements.yml

# -----------------------------------------------------------------------------
# Check syntax of Ansible playbook
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG exec systemd-networkd_archlinux \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts --syntax-check
docker-compose -f $DCONFIG exec systemd-networkd_centos8 \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts --syntax-check
docker-compose -f $DCONFIG exec systemd-networkd_fedora32 \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts --syntax-check
docker-compose -f $DCONFIG exec systemd-networkd_manjaro \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts --syntax-check

# -----------------------------------------------------------------------------
# Run the Ansible role/playbook
# -----------------------------------------------------------------------------
docker-compose -f $DCONFIG exec systemd-networkd_archlinux \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts
docker-compose -f $DCONFIG exec systemd-networkd_centos8 \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts
docker-compose -f $DCONFIG exec systemd-networkd_fedora32 \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts
docker-compose -f $DCONFIG exec systemd-networkd_manjaro \
    ansible-playbook /etc/ansible/test.yml -i /etc/ansible/hosts

# -----------------------------------------------------------------------------
# List containers
# -----------------------------------------------------------------------------
DMAX=$(docker-compose -f $DCONFIG ps | awk 'NR>2' | wc -l)
if [[ $DMAX > 2 ]]; then    
    DCUR=$(docker-compose -f $DCONFIG ps | awk 'NR>2' | grep Up | wc -l)
    docker-compose -f $DCONFIG ps | awk 'NR>2'
    
    if [[ $DMAX != $DCUR ]]; then
        echo "The amount of running containers (that has the state 'Up') isn't \
equal with the total list of containers."
        exit 1
    fi
fi

