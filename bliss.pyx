#distutils: language = c++

from Graph cimport Graph

cdef class PyGraph:
    cdef Graph* c_graph

    def __cinit__(self, int N=0):
        self.c_graph = new Graph(N)

    def __dealloc__(self):
        del self.c_graph

    def add_vertex(self, int color=0):
        self.c_graph.add_vertex(color)

    def add_edge(self, int v1, int v2):
        self.c_graph.add_edge(v1, v2)

    def change_color(self, int vertex, int color):
        self.c_graph.change_color(vertex, color)
