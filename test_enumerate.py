from __future__ import print_function
import sys
import PyBliss


"""
Running this script should output roughly the following (the ordering of edges
in the graphs may change, and the canonical labeling may be different from
system to system, although it should be consistent for a given system):

Computing generators for the automorphism group of the graph:
graph g {
"v1" [label=0];
"v2" [label=0];
"v3" [label=0];
"v4" [label=0];
"v1" -- "v3";
"v1" -- "v4";
"v1" -- "v2";
"v2" -- "v3";
}
Aut gen: {'v1': 'v1', 'v2': 'v3', 'v3': 'v2', 'v4': 'v4'}
A canonical labeling of the graph is: {'v1': 3, 'v2': 2, 'v3': 1, 'v4': 0}
The canonical form of the graph is:
graph g {
"0" [label=0];
"1" [label=0];
"2" [label=0];
"3" [label=0];
"0" -- "3";
"1" -- "2";
"1" -- "3";
"2" -- "3";
}
There are 4 non-isomorphic graphs with 3 vertices
There are 34 non-isomorphic graphs with 5 vertices
There are 156 non-isomorphic graphs with 6 vertices
"""


def report(perm, text=None):
    print(text, perm)


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


class Stats:
    def __init__(self):
        self.nof_graphs = 0


G = PyBliss.Graph()
G.add_vertex('v1')
G.add_vertex('v2')
G.add_vertex('v3')
G.add_vertex('v4')
G.add_edge('v1', 'v2')
G.add_edge('v1', 'v3')
G.add_edge('v2', 'v3')
G.add_edge('v1', 'v4')
print("Computing generators for the automorphism group of the graph:")
G.write_dot(sys.stdout)
G.find_automorphisms(report, "Aut gen:")
canlab = G.canonical_labeling()
print("A canonical labeling of the graph is:", canlab)
print("The canonical form of the graph is:")
G.relabel(canlab).write_dot(sys.stdout)

N = 3
stats = Stats()
G = PyBliss.Graph()
traverse1(G, N, set([]), stats)
print("There are " + str(stats.nof_graphs) + " non-isomorphic graphs with " +
      str(N) + " vertices")

N = 5
stats = Stats()
G = PyBliss.Graph()
traverse2(G, N, set([]), stats)
print("There are " + str(stats.nof_graphs) + " non-isomorphic graphs with " +
      str(N) + " vertices")

N = 6
stats = Stats()
G = PyBliss.Graph()
traverse3(G, N, stats)
print("There are " + str(stats.nof_graphs) + " non-isomorphic graphs with " +
      str(N) + " vertices")
