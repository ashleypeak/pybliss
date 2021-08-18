from setuptools import setup, Extension
from Cython.Build import cythonize

blissdir = 'bliss-0.73'
blisssrcs = ['defs.cc', 'graph.cc', 'heap.cc', 'orbit.cc', 'partition.cc',
             'timer.cc', 'uintseqhash.cc', 'utils.cc']
blisssrcs = [f'{blissdir}/{src}' for src in blisssrcs]

extension = Extension('PyGraph',
                      ['PyGraph.pyx'] + blisssrcs,
                      include_dirs=['bliss-0.73'],
                      language='c++')

setup(ext_modules=cythonize(extension))
