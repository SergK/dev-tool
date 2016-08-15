#!/bin/bash

export ANSIBLE_CONFIG="$PLAYBOOK_PATH/ansible.cfg"
PLAYBOOK_PATH=${PLAYBOOK_PATH:-"$(pwd)"}
source ${PLAYBOOK_PATH}/config.sh

LOOP_LIST="${CONTAINER_LIST[@]}"
if [[ -n "${1}" ]]; then
    LOOP_LIST="${1}"
fi

set -e
for PLAYBOOK in ${LOOP_LIST}; do

    PLAYBOOK_FILE="${PLAYBOOK_PATH}/build-container-${PLAYBOOK}.yml"
    if [[ ! -f "${PLAYBOOK_FILE}" ]]; then
        echo "[ERROR] File ${PLAYBOOK_FILE} does not exits."
        exit 1
    fi

    ansible-playbook ${VERBOSE} \
        -e 'ansible_python_interpreter="/usr/bin/env python"' \
        -i $PLAYBOOK_PATH/inventory \
        --extra-vars="$EXTRA_VARS" \
        "${PLAYBOOK_FILE}"
    docker images
done
