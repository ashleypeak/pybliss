# PyBliss-wyattpeak

A reimplementation of Tommi Junttila's [PyBliss](http://www.tcs.hut.fi/Software/bliss/) package. Modified to support both Python 2 and Python 3, and run on both Linux and Windows.

## Building from source

### Building for your local machine (Linux)

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:
   `$ python3 -m venv bliss-venv`
3. Activate the virtual environment:
   `$ source bliss-venv\bin\activate`
4. Install build:
   `$ pip install build`
5. Run build:
   `$ python3 -m build`
6. Your wheel should now be in `./dist/`.

### Building for your local machine (Windows)

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:
   `$ python -m venv bliss-venv`
3. Activate the virtual environment:
   `$ bliss-venv\Scripts\activate.bat`
4. Install build:
   `$ pip install build`
5. Run build:
   `$ python3 -m build`
6. Your wheel should now be in `./dist/`.

### Building a manylinux wheel

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Start the manylinux Docker image, mounting the source directory to `/io`:
   `$ docker run -tiv $(pwd):/io quay.io/pypa/manylinux2010_x86_64 /bin/bash`
3. Navigate to `/io`:
   `$ cd /io`
4. Run build (You'll need to specify which version of python to use, we'll use 3.8.):
   `$ /opt/python/cp38-cp38/bin/python -m build`
5. You'll now have a single-linux version in `./dist/`.
6. Use `auditwheel repair` to turn it into a manylinux version. You'll need to specify which manylinux version, you can see the options with `auditwheel repair -h`.
   `$ auditwheel repair --plat manylinux1_x86_64 dist/pybliss_wyattpeak-0.73-cp38-cp38-linux_x86_64.whl`
7. Your manylinux version is now in `./wheelhouse/`

### Recompiling Cython scripts

If you want to recompile `_graph.pyx` for any reason, you'll need to build with Cython:

1. In `pyproject.toml`, add the entry `"cython"` to `requires`.
2. In `setup.py`, change `USE_CYTHON = False` to `USE_CYTHON = True`.
