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
    cdef void fatal_error(const char* fmt)
    cdef void fatal_error(const char* fmt, const char*, const int)

# cdef extern from "bliss-0.73/graph.cc":
#     pass

# cdef extern from "bliss-0.73/graph.hh" namespace "bliss":
#     cdef cppclass Graph:
#         Graph(unsigned int) except +
#         unsigned int add_vertex(unsigned int color)
#         void add_edge(unsigned int v1, unsigned int v2)
#         void change_color(unsigned int vertex, unsigned int color)

cdef extern from "bliss-0.73/heap.cc":
    pass

cdef extern from "bliss-0.73/heap.hh" namespace "bliss":
    cdef cppclass Heap:
        Heap() except +
        void init(const unsigned int size)
        const bint is_empty()
        void clear()
        void insert(const unsigned int e)
        unsigned int remove()
        const unsigned int size()

cdef extern from "bliss-0.73/kqueue.hh" namespace "bliss":
    cdef cppclass KQueue[T]:
        KQueue()
        void init(const unsigned int N)
        const bint is_empty()
        const unsigned int size()
        void clear()
        const T front()
        T pop_front()
        void push_front(T e)
        # T pop_back()  # Doesn't seem to be defined, bug?
        void push_back(T e)

cdef extern from "bliss-0.73/orbit.cc":
    pass

cdef extern from "bliss-0.73/orbit.hh" namespace "bliss":
    cdef cppclass Orbit:
        Orbit() except +
        void init(const unsigned int N)
        void reset()
        void merge_orbits(unsigned int e1, unsigned int e2)
        const bint is_minimal_representative(unsigned int e)
        const unsigned int get_minimal_representative(unsigned int e)
        const unsigned int orbit_size(unsigned int e)
        const unsigned int nof_orbits()

# cdef extern from "bliss-0.73/partition.cc":
#     pass

# cdef extern from "bliss-0.73/partition.hh" namespace "bliss":
#     cdef cppclass Partition:
#         cppclass Cell:
#             pass
#         void init(unsigned int N)

cdef extern from "bliss-0.73/timer.cc":
    pass

cdef extern from "bliss-0.73/timer.hh" namespace "bliss":
    cdef cppclass Timer:
        Timer() except +
        void reset()
        double get_duration()

cdef extern from "bliss-0.73/uintseqhash.cc":
    pass

cdef extern from "bliss-0.73/uintseqhash.hh" namespace "bliss":
    cdef cppclass UintSeqHash:
        UintSeqHash() except +
        UintSeqHash(const UintSeqHash& other) except +
        # UintSeqHash& operator=(const UintSeqHash& other)
        void update(unsigned int n)
        const unsigned int get_value()
        int cmp(const UintSeqHash& other)

cdef extern from "bliss-0.73/utils.cc":
    pass

cdef extern from "bliss-0.73/utils.hh" namespace "bliss":
    cdef bint is_permutation(const unsigned int N, const unsigned int* perm)
    cdef bint is_permutation(const vector[unsigned int]& perm)
