# PyBliss - a Python wrapper for bliss

**Note**: This is a reimplementation of Tommi Junttila's [PyBliss](http://www.tcs.hut.fi/Software/bliss/) package, modified to support both Python 2 and Python 3, and run on both Linux and Windows. The original is available at the page linked above.

---

PyBliss is a Python (http://www.python.org/) wrapper for the bliss graph canonical labeling tool (http://www.tcs.hut.fi/Software/bliss/). The source code of bliss is included in this directory.

For performance critical software, please use the C++ interface of bliss instead of this Python wrapper.

## Building from source

### Building for your local machine (Linux)

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:
   `$ python3 -m venv bliss-venv`
   or
   `$ virtualenv -p /PATH/TO/PYTHON2 bliss-venv`
3. Activate the virtual environment:
   `$ source bliss-venv\bin\activate`
4. Install build:
   `$ pip install build`
5. Run build:
   `$ python3 -m build`
   or
   `$ python2 -m build`
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

**Note**: The manylinux Docker image doesn't seem to support Python 2 wheels anymore. I don't use Python 2 so I'm not pursuing it, but if you have a solution let me know.

### Recompiling Cython scripts

If you want to recompile `_graph.pyx` for any reason, you'll need to build with Cython:

1. In `pyproject.toml`, add the entry `"cython"` to `requires`.
2. In `setup.py`, change `USE_CYTHON = False` to `USE_CYTHON = True`.

## Testing

Run all tests using:

```bash
$ python3 -m unittest discover
```

In order to run the tests, Python will need to be able to find the PyBliss package, so you'll need to install it first.
