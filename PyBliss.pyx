# distutils: language = c++

from libc.stdio cimport FILE, stdout
from cython.operator import dereference
from Graph cimport Graph


cdef class PyGraph:
    cdef Graph* c_graph

    def __cinit__(self, int N=0):
        self.c_graph = new Graph(N)

    def __dealloc__(self):
        del self.c_graph

    def write_dot_to_stdout(self):
        cdef FILE* c_file = stdout
        self.c_graph.write_dot(c_file)

    def write_dot(self, const char* file_name):
        self.c_graph.write_dot(file_name)

    # def get_nof_vertices(self):
    #     return self.c_graph.get_nof_vertices()

    def add_vertex(self, int color=0):
        self.c_graph.add_vertex(color)

    def add_edge(self, int v1, int v2):
        self.c_graph.add_edge(v1, v2)

    # def change_color(self, int vertex, int color):
    #     self.c_graph.change_color(vertex, color)

    # def compare(self, PyGraph other):
    #     return self.c_graph._cmp(dereference(other.c_graph))
