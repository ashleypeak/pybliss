cdef extern from "bliss-0.73.1/graph.hh" namespace "bliss":
    ctypedef void (*hook)(void* user_param,
                          unsigned int n,
                          const unsigned int* aut)
    cdef cppclass Stats:
        pass
    cdef cppclass Graph:
        Graph(unsigned int) except +
        const unsigned int get_nof_vertices()
        unsigned int add_vertex(unsigned int color)
        void add_edge(unsigned int v1, unsigned int v2)
        void find_automorphisms(Stats& stats, hook hk, void* hook_user_param)
        const unsigned int* canonical_form(
            Stats& stats, hook hk, void* hook_user_param)
