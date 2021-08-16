# distutils: language = c++

from libc.stdio cimport FILE, stdout
from cython.operator import dereference
from Graph cimport Graph, Stats


cdef struct ReporterCallback:
    void* function
    void* argument


cdef void _reporter(void* reporter_callback,
                    const unsigned int N,
                    const unsigned int* automorphisms):
    rc = <ReporterCallback*>reporter_callback
    func = <object>rc.function
    argument = <object>rc.argument

    automorphisms_list = [automorphisms[i] for i in range(N)]

    func(automorphisms_list, argument)


cdef class PyGraph:
    cdef Graph* c_graph
    cdef Stats c_stats

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

    def find_automorphisms(self, reporter, reporter_arg):
        # The C++ function bliss::AbstractGraph::find_automorphisms needs a
        # C++ callback function to send its results to. This is `_reporter`,
        # defined at the top of this file.
        # The results then need to be passed to a callback function in the
        # Python script that originally called this function. That callback is
        # the argument `reporter`.
        # `reporter_arg` is any Python object that should be passed along with
        # the results to `reporter`.
        cdef ReporterCallback rc
        rc.function = <void*>reporter
        rc.argument = <void*>reporter_arg

        self.c_graph.find_automorphisms(self.c_stats, _reporter, <void*>&rc)
