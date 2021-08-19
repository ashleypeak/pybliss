from graph cimport Stats, Graph

cdef struct ReporterCallback:
    void* function
    void* argument


cdef void _automorphism_reporter(void* reporter_callback,
                                 const unsigned int N,
                                 const unsigned int* automorphism):
    rc = <ReporterCallback*>reporter_callback
    func = <object>rc.function
    argument = <object>rc.argument

    automorphism_list = [automorphism[i] for i in range(N)]

    func(automorphism_list, argument)


cdef class _Graph:
    cdef Graph* c_graph
    cdef Stats c_stats

    def __cinit__(self, int N=0):
        self.c_graph = new Graph(N)

    def __dealloc__(self):
        del self.c_graph

    def add_vertex(self, int color=0):
        return self.c_graph.add_vertex(color)

    def add_edge(self, int v1, int v2):
        self.c_graph.add_edge(v1, v2)

    def find_automorphisms(self, object reporter, object reporter_arg):
        # The C++ function bliss::AbstractGraph::find_automorphisms needs a
        # C++ callback function to send its results to. This is
        # `_automorphism_reporter`, defined at the top of this file.
        # The results then need to be passed to a callback function in the
        # Python script that originally called this function. That callback is
        # the argument `reporter`.
        # `reporter_arg` is any Python object that should be passed along with
        # the results to `reporter`.
        cdef ReporterCallback rc
        rc.function = <void*>reporter
        rc.argument = <void*>reporter_arg

        self.c_graph.find_automorphisms(
            self.c_stats, &_automorphism_reporter, <void*>&rc)

    def canonical_form(self, object reporter, object reporter_arg):
        cdef ReporterCallback rc
        rc.function = <void*>reporter
        rc.argument = <void*>reporter_arg

        cdef const unsigned int* labeling = self.c_graph.canonical_form(
            self.c_stats, &_automorphism_reporter, <void*>&rc)

        N = self.c_graph.get_nof_vertices()

        labeling_list = [labeling[i] for i in range(N)]
        return labeling_list
