# PyBliss - a Python wrapper for bliss

**Note**: This is a reimplementation of Tommi Junttila's [PyBliss](http://www.tcs.hut.fi/Software/bliss/) package, modified to support both Python 2 and Python 3, and run on both Linux and Windows. The original is available at the page linked above.

---

PyBliss is a Python (http://www.python.org/) wrapper for the bliss graph canonical labeling tool (http://www.tcs.hut.fi/Software/bliss/). The source code of bliss is included in this directory.

For performance critical software, please use the C++ interface of bliss instead of this Python wrapper.

## Installation

PyBliss can be installed through pip:

```bash
$ pip install pybliss-wyattpeak
```

## Building from source

### Building for your local machine (Linux)

#### Python 3

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:\
   `$ python3 -m venv bliss-venv`
3. Activate the virtual environment:\
   `$ source bliss-venv\bin\activate`
4. Install build:\
   `$ pip install build`
5. Run build:\
   `$ python3 -m build`
6. Your wheel should now be in `./dist/`.

#### Python 2

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:\
   `$ virtualenv -p /PATH/TO/PYTHON2 bliss-venv`
3. Activate the virtual environment:\
   `$ source bliss-venv\bin\activate`
4. Install build:\
   `$ pip install build`
5. Run build:\
   `$ python2 -m build`
6. Your wheel should now be in `./dist/`.

### Building for your local machine (Windows)

### Python 3

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:\
   `> python -m venv bliss-venv`
3. Activate the virtual environment:\
   `> bliss-venv\Scripts\activate.bat`
4. Install build:\
   `> pip install build`
5. Run build:\
   `> python -m build`
6. Your wheel should now be in `.\dist\`.

### Python 2

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Create a virtual environment:\
   `> \PATH\TO\VIRTUALENV.EXE bliss-venv`
3. Activate the virtual environment:\
   `> bliss-venv\Scripts\activate.bat`
4. Install build:\
   `> pip install build`
5. Run build:\
   `> python -m build`
6. Your wheel should now be in `.\dist\`.

### Building a manylinux wheel

1. Navigate into the main project directory, there should be a file `setup.py`.
2. Start the manylinux Docker image, mounting the source directory to `/io`:\
   `$ docker run -tiv $(pwd):/io quay.io/pypa/manylinux2010_x86_64 /bin/bash`
3. Navigate to `/io`:\
   `$ cd /io`
4. Run build (You'll need to specify which version of python to use, we'll use 3.8.):\
   `$ /opt/python/cp38-cp38/bin/python -m build`
5. You'll now have a single-linux version in `./dist/`.
6. Use `auditwheel repair` to turn it into a manylinux version. You'll need to specify which manylinux version, you can see the options with `auditwheel repair -h`.\
   `$ auditwheel repair --plat manylinux1_x86_64 dist/pybliss_wyattpeak-0.1.3-cp38-cp38-linux_x86_64.whl`
7. Your manylinux version is now in `./wheelhouse/`

**Note**: The manylinux Docker image doesn't seem to support Python 2 wheels anymore. I don't use Python 2 so I'm not pursuing it, but if you have a solution let me know.

### Building for PyPI

All wheels necessary for a PyPI update can be built by running `build.sh` in an Ubuntu shell and `build.bat` in a Windows command prompt.

You will need Docker installed on your Ubuntu system, and will need to update the variables `ENV_PYTHON2_DIR` and `ENV_PYTHON3_DIR` in `build.bat` to point to the root directories of the relevant virtual environment folders.

### Recompiling Cython scripts

If you want to recompile `_graph.pyx` for any reason, you'll need to build with Cython:

1. In `pyproject.toml`, add the entry `"cython"` to `requires`.
2. In `setup.py`, change `USE_CYTHON = False` to `USE_CYTHON = True`.

After that, you can follow one of the sets of build instructions above.

## Testing

In order to run the tests, Python will need to be able to find the PyBliss package, so you'll need to install it first.

Run all tests using:

```bash
$ python -m unittest discover
```

This will work for both Python 2 and Python 3.
