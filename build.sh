#!/usr/bin/env bash

# Terminate script if any comand exits with non-zero value
set -euo pipefail

# ENV_PYTHON2_DIR=./venv/linux/python2

# echo "Building python2 wheel"
# source "$ENV_PYTHON2_DIR/bin/activate"
# python2 -m build
# deactivate
# echo "Python 2 wheel built"

docker run --rm -v$(pwd):/io quay.io/pypa/manylinux2010_x86_64 "/io/build_manylinux.sh"
