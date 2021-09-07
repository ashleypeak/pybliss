from __future__ import print_function
import unittest
import PyBliss

try:
    # Python 2
    from cStringIO import StringIO
except ModuleNotFoundError:
    # Python 3
    from io import StringIO


class Stats:
    def __init__(self):
        self.nof_graphs = 0


def traverse1(G, N, R, stats):
    """
    Enumerate all graphs over N vertices up to isomorphism
    by using a form of the 'trivial' method.
    All graphs are generated and isomorph rejection is only applied
    to the 'leaf graph'.
    """
    if G.nof_vertices() == N:
        canform = G.relabel(G.canonical_labeling())
        if canform not in R:
            stats.nof_graphs += 1
            R.add(canform)
        return
    i = G.nof_vertices()
    v = "v" + str(i)
    for k in range(pow(2, i)):
        G.add_vertex(v)
        for j in range(i):
            if (k & 0x01) == 1:
                G.add_edge(v, "v" + str(j))
            k = k // 2
        traverse1(G, N, R, stats)
        G.del_vertex(v)


def traverse2(G, N, R, stats):
    """
    Enumerate all graphs over N vertices up to isomorphism
    by using a form of the 'folklore' method.
    Graphs are build iteratively and isomorph rejection is applied
    to all graphs.
    """
    canform = G.relabel(G.canonical_labeling())
    if canform in R:
        return
    R.add(canform)
    if G.nof_vertices() == N:
        stats.nof_graphs += 1
        return
    i = G.nof_vertices()
    v = "v" + str(i)
    for k in range(pow(2, i)):
        G.add_vertex(v)
        for j in range(i):
            if (k & 0x01) == 1:
                G.add_edge(v, "v" + str(j))
            k = k // 2
        traverse2(G, N, R, stats)
        G.del_vertex(v)


def traverse3(G, N, stats):
    """
    Enumerate all graphs over N vertices up to isomorphism
    by using a form the 'weak canonical augmentation' method.
    """
    if G.nof_vertices() == N:
        stats.nof_graphs += 1
        return
    i = G.nof_vertices()
    vertices = G.get_vertices()
    children = set([])
    for k in range(pow(2, i)):
        G.add_vertex('tmp')
        for j in range(0, i):
            if (k & 0x01) == 1:
                G.add_edge('tmp', vertices[j])
            k = k // 2
        child = G.relabel(G.canonical_labeling())
        G.del_vertex('tmp')  # restore G
        if child in children:
            continue
        child2 = child.copy()
        child2.del_vertex(0)
        child2_canform = child2.relabel(child2.canonical_labeling())
        if child2_canform.get_isomorphism(G) is not None:
            children.add(child)
    for child in children:
        traverse3(child, N, stats)


def get_automorphism_generators(graph):
    def report(perm, output_list):
        output_list.append(perm)

    generators = []
    graph.find_automorphisms(report, generators)

    return generators


def get_graphviz_dot(graph):
    output = StringIO()
    graph.write_dot(output)

    return output.getvalue()


class TestEnumerate(unittest.TestCase):
    def setUp(self):
        self.test_graph = PyBliss.Graph()
        self.test_graph.add_vertex('v1')
        self.test_graph.add_vertex('v2')
        self.test_graph.add_vertex('v3')
        self.test_graph.add_vertex('v4')
        self.test_graph.add_edge('v1', 'v2')
        self.test_graph.add_edge('v1', 'v3')
        self.test_graph.add_edge('v2', 'v3')
        self.test_graph.add_edge('v1', 'v4')

    def test_graphviz_dot_output(self):
        output = get_graphviz_dot(self.test_graph)

        # We have to run these assertions independently, rather than checking
        # that the total output matches a particular string, because the
        # write_dot() function makes no guarantees about order or nodes/edges.
        self.assertIn('"v1" [label=0];', output)
        self.assertIn('"v2" [label=0];', output)
        self.assertIn('"v3" [label=0];', output)
        self.assertIn('"v4" [label=0];', output)
        self.assertIn('"v1" -- "v2";', output)
        self.assertIn('"v1" -- "v3";', output)
        self.assertIn('"v1" -- "v4";', output)
        self.assertIn('"v2" -- "v3";', output)

    def test_automorphism_generators(self):
        generators = get_automorphism_generators(self.test_graph)

        # The test graph should have just one generator, which swaps nodes 2
        # and 3.
        self.assertEqual(len(generators), 1)
        self.assertEqual(generators[0]['v1'], 'v1')
        self.assertEqual(generators[0]['v2'], 'v3')
        self.assertEqual(generators[0]['v3'], 'v2')
        self.assertEqual(generators[0]['v4'], 'v4')

    def test_canonical_labeling_format(self):
        # Test that the canonical labelling relabels the graph to zero-indexed
        # integers.
        canlab = self.test_graph.canonical_labeling()

        self.assertEqual(set(canlab.values()), set(range(4)))

        graph_relabeled = self.test_graph.relabel(canlab)
        output = get_graphviz_dot(graph_relabeled)

        # We can't test the connections because we don't know how the
        # labelings have changed, but we can test the nodes output correctly.
        self.assertIn('"0" [label=0];', output)
        self.assertIn('"1" [label=0];', output)
        self.assertIn('"2" [label=0];', output)
        self.assertIn('"3" [label=0];', output)

    def test_canonical_labeling(self):
        # Make a second graph which is an automorphism of the first
        generators = get_automorphism_generators(self.test_graph)
        graph2 = self.test_graph.relabel(generators[0])

        # Get both canonical labelings
        canlab1 = self.test_graph.canonical_labeling()
        canlab2 = graph2.canonical_labeling()

        # Relabel both graphs canonically and get their dot files
        graph1_canon_dot = get_graphviz_dot(self.test_graph.relabel(canlab1))
        graph2_canon_dot = get_graphviz_dot(graph2.relabel(canlab2))

        self.assertEqual(graph1_canon_dot, graph2_canon_dot)

    def test_traverse1(self):
        N = 3
        stats = Stats()
        G = PyBliss.Graph()
        traverse1(G, N, set([]), stats)

        self.assertEqual(stats.nof_graphs, 4)

    def test_traverse2(self):
        N = 5
        stats = Stats()
        G = PyBliss.Graph()
        traverse2(G, N, set([]), stats)

        self.assertEqual(stats.nof_graphs, 34)

    def test_traverse3(self):
        N = 6
        stats = Stats()
        G = PyBliss.Graph()
        traverse3(G, N, stats)

        self.assertEqual(stats.nof_graphs, 156)
