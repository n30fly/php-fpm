#!/usr/bin/env bash

if [ -f /run/secrets/host_ssh_key ]; then
    if [ ! -f /root/.ssh/config ]; then
        mkdir /root/.ssh
        echo "IdentityFile /run/secrets/host_ssh_key" > /root/.ssh/config
    fi
fi

