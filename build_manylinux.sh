#!/usr/bin/env bash

# Check that the script is being run from within a Docker container
if ! grep -sq 'docker' /proc/1/cgroup; then
	echo "Use build.sh to build wheels, this script should not be manually invoked."
	exit 0
fi

PYTHON3_WHEEL=dist/pybliss_wyattpeak-*-cp38-cp38-linux_x86_64.whl

cd /io

echo "Building python3 single linux wheel"
/opt/python/cp38-cp38/bin/python -m build

echo "Building python3 manylinux wheel"
auditwheel repair --plat manylinux1_x86_64 $PYTHON3_WHEEL
rm $PYTHON3_WHEEL
mv wheelhouse/* dist/
