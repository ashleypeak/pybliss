cdef extern from "<vector>" namespace "std":
    cdef cppclass vector[T]:
        cppclass iterator:
            T operator*()
            iterator operator++()
            bint operator==(iterator)
            bint operator!=(iterator)
        vector()
        void push_back(T&)
        T& operator[](int)
        T& at(int)
        iterator begin()
        iterator end()

cdef extern from "bliss-0.73/defs.cc":
    pass

cdef extern from "bliss-0.73/defs.hh" namespace "bliss":
    cdef void fatal_error(char* fmt)
    cdef void fatal_error(char* fmt, char*, int)

cdef extern from "bliss-0.73/graph.cc":
    pass

cdef extern from "bliss-0.73/graph.hh" namespace "bliss":
    cdef cppclass Graph:
        Graph(unsigned int) except +
        unsigned int add_vertex(unsigned int color)
        void add_edge(unsigned int v1, unsigned int v2)
        void change_color(unsigned int vertex, unsigned int color)

cdef extern from "bliss-0.73/heap.cc":
    pass

cdef extern from "bliss-0.73/heap.hh" namespace "bliss":
    cdef cppclass Heap:
        unsigned int remove()

cdef extern from "bliss-0.73/orbit.cc":
    pass

cdef extern from "bliss-0.73/orbit.hh" namespace "bliss":
    cdef cppclass Orbit:
        void reset()

cdef extern from "bliss-0.73/partition.cc":
    pass

cdef extern from "bliss-0.73/partition.hh" namespace "bliss":
    cdef cppclass Partition:
        void init(unsigned int N)

cdef extern from "bliss-0.73/timer.cc":
    pass

cdef extern from "bliss-0.73/timer.hh" namespace "bliss":
    cdef cppclass Timer:
        Timer() except +

cdef extern from "bliss-0.73/uintseqhash.cc":
    pass

cdef extern from "bliss-0.73/uintseqhash.hh" namespace "bliss":
    cdef cppclass UintSeqHash:
        void update(unsigned int n)

cdef extern from "bliss-0.73/utils.cc":
    pass

cdef extern from "bliss-0.73/utils.hh" namespace "bliss":
    cdef bint is_permutation(unsigned int N, unsigned int* perm)
    cdef bint is_permutation(vector[unsigned int]& perm)
