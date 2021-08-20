from collections import defaultdict

from _graph import _Graph


class Graph:
    class _Vertex:
        def __init__(self, name, color):
            assert type(color) is int
            assert 0 <= color and color < pow(2, 31)
            self.edges = set([])
            self.name = name
            self.color = color

        def __hash__(self):
            # So long as _Vertex is only instantiated through Graph, this
            # should be unique (modulo hash clashes) because Graph enforces
            # uniqueness of names.
            # Can't hash __str__ because hashes are immutable, and __str__
            # changes whenever edges are added/removed.
            return hash(self.name)

        def __str__(self):
            nnames = [str(neighbour.name) for neighbour in self.edges]
            nnames.sort()

            s = str(self.name) + " " + str(self.color) + " " + str(nnames)
            return "(" + s + ")"

        def __eq__(self, other):
            if not isinstance(other, Graph._Vertex):
                return False

            return str(self) == str(other)

        def __lt__(self, other):
            if not isinstance(other, Graph._Vertex):
                raise TypeError()

            return str(self) < str(other)

    """
    The class for undirected graphs.
    """
    def __init__(self):
        """
        Create a new empty graph.
        """
        self._vertices = {}

    def __hash__(self):
        return hash(str(self))

    def __str__(self):
        s = ""
        for name, vertex in sorted(self._vertices.items()):
            s += str(vertex)

        return "<" + s + ">"

    def __eq__(self, other):
        """
        Check whether the graph is equal to the graph 'other'.
        That is, whether the graphs have the same vertices colored with
        the same colors and the same edges.
        """
        if not isinstance(other, Graph):
            return False

        if len(self._vertices) != len(other._vertices):
            return False

        for name, vertex in self._vertices.items():
            if name not in other._vertices:
                return False
            if vertex.color != other._vertices[name].color:
                return False

            self_edges = set([v.name for v in vertex.edges])
            other_edges = set([v.name for v in other._vertices[name].edges])

            if self_edges != other_edges:
                return False

        return True

    def __ne__(self, other):
        return not self == other

    def nof_vertices(self):
        """
        Get the number of vertices in the graph.
        """
        return len(self._vertices)

    def get_vertices(self):
        """
        Return the (list of) vertices in the graph.
        """
        return list(self._vertices.keys())

    def add_vertex(self, v, color=0):
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
        
    def del_vertex(self, v):
        """
        Delete the vertex named 'v' from the graph.
        If the vertex does not exist, do nothing.
        The vertex name v should be hashable and immutable,
        preferably an integer or a string not containing spaces.
        """
        if v in self._vertices:
            vertex = self._vertices[v]
            for neighbour in vertex.edges:
                if neighbour is not vertex:
                    neighbour.edges.remove(vertex)
            del self._vertices[v]
        
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

    def del_edge(self, v1, v2):
        """
        Delete the edge between vertices v1 and v2.
        The vertex names v1 and v2 should be hashable and immutable,
        preferably integers or strings not containing spaces.
        """
        if v1 not in self._vertices:
            return
        if v2 not in self._vertices:
            return
        self._vertices[v1].edges.discard(self._vertices[v2])
        self._vertices[v2].edges.discard(self._vertices[v1])

    def write_dot(self, file):
        """
        Write the graph into a file in the graphviz dot format.
        """
        file.write("graph g {\n")
        for v, vertex in sorted(self._vertices.items()):
            file.write('"' + str(v) + '" [label=' + str(vertex.color) + '];\n')
        for v, vertex in sorted(self._vertices.items()):
            for neighbour in vertex.edges:
                if neighbour.name >= vertex.name:
                    file.write(
                        '"' + str(v) + '" -- "' + str(neighbour.name) + '";\n')
        file.write("}\n")

    def _make_bliss_graph(self):
        graph = _Graph()
        bliss_map = {}
        bliss_map_inv = {}
        for v, vertex in self._vertices.items():
            bliss_map[v] = graph.add_vertex(vertex.color)
            bliss_map_inv[bliss_map[v]] = v
        for name, vertex in self._vertices.items():
            for neighbour in vertex.edges:
                if neighbour < vertex:
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

        graph.find_automorphisms(Graph._automorphism_reporter,
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

        labeling = graph.canonical_form(Graph._automorphism_reporter,
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

        graph_relabeled = Graph()
        for name, vertex in self._vertices.items():
            inserted = graph_relabeled.add_vertex(lab[name], vertex.color)
            if not inserted:
                raise RuntimeError("'lab' is not a bijection")
        for name, vertex in self._vertices.items():
            for neighbour in vertex.edges:
                if neighbour < vertex:
                    continue
                graph_relabeled.add_edge(lab[name], lab[neighbour.name])

        return graph_relabeled

    def copy(self):
        """
        Return a copy of this graph.
        """
        graph_copy = Graph()

        for name, vertex in self._vertices.items():
            graph_copy.add_vertex(name, vertex.color)
        for name, vertex in self._vertices.items():
            for neighbour in vertex.edges:
                if neighbour < vertex:
                    continue
                graph_copy.add_edge(name, neighbour.name)

        return graph_copy

    def get_isomorphism(self, other):
        """
        Return an isomorphism from this graph to the graph 'other' or None if
        the graphs are not isomorphic.
        Observe that for empty graphs an empty dictionary is returned and
        thus one should not check isomorphism by 'if g1.get_isomorphism(g2)'
        but by 'if g1.get_isomorphism(g2) is not None'.
        The returned isomorphism 'lab' is a labeling such that
        self.relabel(lab).is_equal(g) == True.
        """
        if not isinstance(other, Graph):
            raise TypeError(
                "get_isomorphism() requires an argument of type Graph")

        if len(self._vertices) != len(other._vertices):
            return None

        # Simple color and degree check
        self_colors = defaultdict(int)
        self_degrees = defaultdict(int)
        for name, vertex in self._vertices.items():
            self_colors[vertex.color] += 1
            self_degrees[len(vertex.edges)] += 1

        other_colors = defaultdict(int)
        other_degrees = defaultdict(int)
        for name, vertex in other._vertices.items():
            other_colors[vertex.color] += 1
            other_degrees[len(vertex.edges)] += 1

        if self_colors != other_colors:
            return None
        if self_degrees != other_degrees:
            return None

        self_canlab = self.canonical_labeling()
        self_canform = self.relabel(self_canlab)

        other_canlab = other.canonical_labeling()
        other_canform = other.relabel(other_canlab)

        if self_canform != other_canform:
            return None

        other_canlab_inv = {image: name
                            for name, image in other_canlab.items()}
        isomorphism = {name: other_canlab_inv[image]
                       for name, image in self_canlab.items()}

        assert self.relabel(isomorphism) == other
        return isomorphism
