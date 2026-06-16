#!/bin/bash
export HOME=/home/abc
cd /home/abc || exit 1
exec bash --rcfile /home/abc/.bashrc