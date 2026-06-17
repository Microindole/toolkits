#!/bin/bash

export HOME=/home/abc

if [ -f /home/abc/.env ]; then
    source /home/abc/.env
fi

cd /home/abc || return 1 2>/dev/null || exit 1

echo "[abc env] activated"