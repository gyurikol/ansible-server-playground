#! /usr/bin/env bash
set -xeuo pipefail

ANSIBLE_IMAGE_NAME="ansible"
ANSIBLE_PORT="16443"
ANSIBLE_PLAYBOOK_NAME="playbook"
ANSIBLE_INVENTORY_FILE_NAME="host_inventory.yml"
ANSIBLE_VERBOSITY=1

function build_ansible_container() {
    docker build \
    --quiet \
    --tag ${ANSIBLE_IMAGE_NAME} \
        ./
}

function run_ansible_container() {
    docker run --rm -it \
        -p ${ANSIBLE_PORT}:${ANSIBLE_PORT} \
        -v ${PWD}/${ANSIBLE_PLAYBOOK_NAME}:/home/ansibleuser/${ANSIBLE_PLAYBOOK_NAME}:ro \
        -v ${PWD}/${ANSIBLE_INVENTORY_FILE_NAME}:/home/ansibleuser/${ANSIBLE_INVENTORY_FILE_NAME}:ro \
        -e ANSIBLE_VERBOSITY=${ANSIBLE_VERBOSITY} \
        -e ANSIBLE_HOST_KEY_CHECKING=false \
        --hostname="${ANSIBLE_IMAGE_NAME}" \
            ${ANSIBLE_IMAGE_NAME} \
                ${1}
}

# build ansible image
build_ansible_container

# bootstrap k8s node
run_ansible_container "ansible-playbook -i ${ANSIBLE_INVENTORY_FILE_NAME} ./playbook/kubernetes/main.yml -D --ask-become-pass"
