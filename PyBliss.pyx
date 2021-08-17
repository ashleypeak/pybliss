# distutils: language = c++

from libc.stdio cimport FILE, stdout
from cython.operator import dereference
from Graph cimport vector, Stats, Graph


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


cdef class PyGraph:
    cdef Graph* c_graph
    cdef Stats c_stats

    def __cinit__(self, int N=0):
        self.c_graph = new Graph(N)

    def __dealloc__(self):
        del self.c_graph

    # def write_dot_to_stdout(self):
    #     cdef FILE* c_file = stdout
    #     self.c_graph.write_dot(c_file)

    # def write_dot(self, const char* file_name):
    #     self.c_graph.write_dot(file_name)

    # def get_nof_vertices(self):
    #     return self.c_graph.get_nof_vertices()

    def add_vertex(self, int color=0):
        return self.c_graph.add_vertex(color)

    def add_edge(self, int v1, int v2):
        self.c_graph.add_edge(v1, v2)

    # def change_color(self, int vertex, int color):
    #     self.c_graph.change_color(vertex, color)

    # def compare(self, PyGraph other):
    #     return self.c_graph._cmp(dereference(other.c_graph))

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


class PyBlissGraph:
    class _Vertex:
        def __init__(self, name, color):
            assert type(color) is int
            assert 0 <= color and color < pow(2, 31)
            self.edges = set([])
            self.name = name
            self.color = color

    """
    The class for undirected graphs.
    """
    def __init__(self):
        """
        Create a new empty graph.
        """
        self._vertices = {}

    def nof_vertices(self):
        """
        Get the number of vertices in the graph.
        """
        return len(self._vertices)

    def add_vertex(self, v, color = 0):
        """
        Add a new vertex named 'v' with color 'c' in the graph.
        If the vertex already exists, do nothing.
        The color must be an integer between 0 and 2^31-1.
        The vertex name v should be hashable and immutable,
        preferably an integer or a string not containing spaces.
        Returns False if the vertex already existed, True otherwise.
        """
        if v in self._vertices:
            return False
        self._vertices[v] = self._Vertex(v, color)
        return True
        
    def add_edge(self, v1, v2):
        """
        Add an edge between vertices v1 and v2.
        Adds the vertices v1 and v2 if they do not already exist.
        The vertex names v1 and v2 should be hashable and immutable,
        preferably integers or strings not containing spaces.
        """
        if v1 not in self._vertices:
            self.add_vertex(v1)
        if v2 not in self._vertices:
            self.add_vertex(v2)
        self._vertices[v1].edges.add(self._vertices[v2])
        self._vertices[v2].edges.add(self._vertices[v1])

    def write_dot(self, file):
        """
        Write the graph into a file in the graphviz dot format.
        """
        file.write("graph g {\n")
        for v, vertex in sorted(self._vertices.items()):
            file.write(f'"{v}" [label="{vertex.color}"];\n')
        for v, vertex in sorted(self._vertices.items()):
            for neighbour in vertex.edges:
                if neighbour.name >= vertex.name:
                    file.write(f'"{v}" -- "{neighbour.name}";\n')
        file.write("}\n")

    def _make_bliss_graph(self):
        graph = PyGraph()
        bliss_map = {}
        bliss_map_inv = {}
        for v, vertex in self._vertices.items():
            bliss_map[v] = graph.add_vertex(vertex.color)
            bliss_map_inv[bliss_map[v]] = v
        for name, vertex in self._vertices.items():
            for neighbour in vertex.edges:
                if neighbour.name < vertex.name:
                    continue
                graph.add_edge(bliss_map[name], bliss_map[neighbour.name])
        return (graph, bliss_map, bliss_map_inv)

    @staticmethod
    def _automorphism_reporter(permutation, args):
        (reporter_func, reporter_args, bliss_map_inv) = args

        if reporter_func:
            p = {}
            for (index, image) in enumerate(permutation):
                p[bliss_map_inv[index]] = bliss_map_inv[image]

            reporter_func(p, reporter_args)

    def find_automorphisms(self,
                           reporter_function,
                           reporter_function_arg=None):
        """
        Find a generating set for the automorphism group of the graph.
        The generators are reported by calling the hook function
        'reporter_function' with two arguments: the generator and
        the user-defined argument 'reporter_function_arg'.
        """
        if not (reporter_function is None or callable(reporter_function)):
            raise TypeError("the 'reporter_function' argument of "
                            "find_automorphisms() should be None or "
                            "a function")

        (graph, bliss_map, bliss_map_inv) = self._make_bliss_graph()

        report_args = (reporter_function, reporter_function_arg, bliss_map_inv)

        graph.find_automorphisms(PyBlissGraph._automorphism_reporter,
                                 report_args)

    def canonical_labeling(self,
                           reporter_function=None,
                           reporter_function_arg=None):
        """
        Find a canonical labeling for the graph.
        The labeling is a mapping from the vertices to the set {0,...,N-1},
        where N is the number of vertices in the graph.
        The canonical form of the graph can be found by applying
        the 'relabel' method with the returned labeling.
        """
        if not (reporter_function is None or callable(reporter_function)):
            raise TypeError("the 'reporter_function' argument of "
                            "canonical_labeling() should be None or "
                            "a function")
        (graph, bliss_map, bliss_map_inv) = self._make_bliss_graph()

        report_args = (reporter_function, reporter_function_arg, bliss_map_inv)

        labeling = graph.canonical_form(PyBlissGraph._automorphism_reporter,
                                        report_args)

        labeling_dict = {bliss_map_inv[index]: image
                         for (index, image) in enumerate(labeling)}
        return labeling_dict

    def relabel(self, lab):
        """
        Apply the argument labeling 'lab' to the graph, returning a copy of
        the graph where the vertices have been relabeled according to 'lab'.
        The labeling is given as a dictionary mapping each vertex
        in the graph into some distinct immutable name.
        """
        assert type(lab) is dict
        assert len(lab) == self.nof_vertices()

        graph_relabeled = PyBlissGraph()
        for name, vertex in self._vertices.items():
            inserted = graph_relabeled.add_vertex(lab[name], vertex.color)
            if not inserted:
                raise RuntimeError("'lab' is not a bijection")
        for name, vertex in self._vertices.items():
            for neighbour in vertex.edges:
                if neighbour.name < vertex.name:
                    continue
                graph_relabeled.add_edge(lab[name], lab[neighbour.name])

        return graph_relabeled
