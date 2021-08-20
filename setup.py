from setuptools import setup, Extension
from os import path

wd = path.abspath(path.dirname(__file__))
with open(path.join(wd, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

USE_CYTHON = False

ext = 'pyx' if USE_CYTHON else 'cpp'

source_dir = 'src'

bliss_dir = f'{source_dir}/bliss-0.73.1'
bliss_sources = ['defs.cc', 'graph.cc', 'heap.cc', 'orbit.cc', 'partition.cc',
                 'timer.cc', 'uintseqhash.cc', 'utils.cc']
bliss_sources = [f'{bliss_dir}/{src}' for src in bliss_sources]

graph_source = f'{source_dir}/_graph.{ext}'

extensions = [Extension('_graph',
                        [graph_source] + bliss_sources,
                        include_dirs=[bliss_dir],
                        language='c++')]

if USE_CYTHON:
    from Cython.Build import cythonize
    extensions = cythonize(extensions,
                           compiler_directives={'language_level': 3})

setup(
    name='pybliss-wyattpeak',
    version='0.1',
    author='Wyatt Peak',
    description="A Python3 implementation PyBliss",
    long_description=long_description,
    long_description_content_type='text/markdown',
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GNU General Public License v2 (GPLv2)",
        "Operating System :: POSIX :: Linux",
        "Operating System :: Microsoft :: Windows",
    ],
    package_dir={'': source_dir},
    py_modules=['PyBliss'],
    ext_modules=extensions,
    zip_safe=False,
)
