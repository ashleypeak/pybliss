# distutils: language = c++

from cython.operator import dereference

# from Graph cimport vector

# cdef class PyVector:
#     cdef vector[int] c_vector

#     def push_back(self, int i):
#         self.c_vector.push_back(i)

#     def at(self, int index):
#         return self.c_vector[index]

# from Graph cimport is_permutation

# cpdef bint is_perm(lst):
#     # cdef vector[unsigned int] c_vector
#     # for el in lst:
#     #     c_vector.push_back(el)

#     # return is_permutation(c_vector)
#     cdef unsigned int c_int_list[5]

#     for (i, el) in enumerate(lst):
#         c_int_list[i] = el

#     return is_permutation(len(lst), c_int_list)

# from Graph cimport fatal_error

# cpdef void ferror():
#     cdef char* fmt = "FATAL ERRAR %s:%d"
#     cdef char* fl = "test.c"
#     cdef int ln = 3
#     fatal_error(fmt, fl, ln)

# from Graph cimport UintSeqHash

# cdef class PyUintSeqHash:
#     cdef UintSeqHash* c_uintseqhash

#     def __cinit__(self, PyUintSeqHash base=None):
#         if base is None:
#             self.c_uintseqhash = new UintSeqHash()
#         else:
#             self.c_uintseqhash = new UintSeqHash(dereference(base.c_uintseqhash))

#     def __dealloc__(self):
#         del self.c_uintseqhash

#     def update(self, unsigned int n):
#         self.c_uintseqhash.update(n)

#     def get_value(self):
#         return self.c_uintseqhash.get_value()

#     def compare(self, PyUintSeqHash other):
#         return self.c_uintseqhash._cmp(dereference(other.c_uintseqhash))

# from Graph cimport Timer

# cdef class PyTimer:
#     cdef Timer c_timer

#     def reset(self):
#         self.c_timer.reset()

#     def get_duration(self):
#         return self.c_timer.get_duration()

# from Graph cimport Orbit

# cdef class PyOrbit:
#     cdef Orbit c_orbit

#     def init(self, const unsigned int n):
#         self.c_orbit.init(n)

#     def reset(self):
#         self.c_orbit.reset()

#     def merge_orbits(self, unsigned int e1, unsigned int e2):
#         self.c_orbit.merge_orbits(e1, e2)

#     def is_minimal_representative(self, unsigned int e):
#         return self.c_orbit.is_minimal_representative(e)

#     def get_minimal_representative(self, unsigned int e):
#         return self.c_orbit.get_minimal_representative(e)

#     def orbit_size(self, unsigned int e):
#         return self.c_orbit.orbit_size(e)

#     def nof_orbits(self):
#         return self.c_orbit.nof_orbits()

# from Graph cimport Heap

# cdef class PyHeap:
#     cdef Heap c_heap

#     def init(self, const unsigned int size):
#         self.c_heap.init(size)

#     def is_empty(self):
#         return self.c_heap.is_empty()

#     def clear(self):
#         self.c_heap.clear()

#     def insert(self, const unsigned int e):
#         self.c_heap.insert(e)

#     def remove(self):
#         return self.c_heap.remove()

#     def size(self):
#         return self.c_heap.size()

# from Graph cimport KQueue

# cdef class PyKQueue:
#     cdef KQueue[int] c_kqueue

#     def init(self, const unsigned int N):
#         self.c_kqueue.init(N)

#     def is_empty(self):
#         return self.c_kqueue.is_empty()

#     def size(self):
#         return self.c_kqueue.size()

#     def clear(self):
#         self.c_kqueue.clear()

#     def front(self):
#         return self.c_kqueue.front()

#     def pop_front(self):
#         return self.c_kqueue.pop_front()

#     def push_front(self, int e):
#         self.c_kqueue.push_front(e)

#     def push_back(self, int e):
#         self.c_kqueue.push_back(e)

# from Graph cimport Partition

# cdef class PyCell:
#     cdef Partition.Cell c_cell

#     def is_unit(self):
#         return self.c_cell.is_unit()

#     @property
#     def length(self):
#         return self.c_cell.length

#     @length.setter
#     def length(self, length):
#         self.c_cell.length = length

# cdef class PyPartition:
#     cdef Partition c_partition

#     def splitting_queue_add(self, PyCell cell):
#         self.c_partition.splitting_queue_add(&cell.c_cell)

#     def splitting_queue_pop(self):
#         # Obviously an incorrect implementation, but can't be bothered doing it
#         # properly just for the sake of testing.
#         return self.c_partition.splitting_queue_pop().length

#     def splitting_queue_is_empty(self):
#         return self.c_partition.splitting_queue_is_empty()

#     def splitting_queue_clear(self):
#         return self.c_partition.splitting_queue_clear()

#     def init(self, unsigned int N):
#         self.c_partition.init(N)

from Graph cimport Graph

cdef class PyGraph:
    cdef Graph* c_graph

    def __cinit__(self, int N=0):
        self.c_graph = new Graph(N)

    def __dealloc__(self):
        del self.c_graph

    def get_nof_vertices(self):
        return self.c_graph.get_nof_vertices()

    def add_vertex(self, int color=0):
        self.c_graph.add_vertex(color)

    def add_edge(self, int v1, int v2):
        self.c_graph.add_edge(v1, v2)

    def change_color(self, int vertex, int color):
        self.c_graph.change_color(vertex, color)

    def compare(self, PyGraph other):
        return self.c_graph._cmp(dereference(other.c_graph))
