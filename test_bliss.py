# from bliss import PyVector
# v = PyVector()
# v.push_back(3)
# v.push_back(6)
# v.push_back(9)
# print(v.at(1))

# from bliss import is_perm
# print(is_perm([0, 2, 1, 4, 3]))
# print(is_perm([1, 2, 3, 4, 5]))

# from bliss import ferror
# print(ferror())

# from bliss import hashtest
# print(hashtest())
# exit()

# from bliss import PyUintSeqHash
# h = PyUintSeqHash()
# h.update(1)
# print('h', h.get_value())
# h2 = PyUintSeqHash(h)
# print(h.compare(h2))
# h2.update(1)
# print('h2', h2.get_value())
# print(h.compare(h2))

# from bliss import PyTimer
# import time
# t = PyTimer()
# time.sleep(1)
# print(t.get_duration())
# t.reset()
# print(t.get_duration())

# from bliss import PyOrbit
# o = PyOrbit()
# o.init(10)
# print(o.nof_orbits())
# o.merge_orbits(1, 2)
# print(o.nof_orbits())
# print(o.orbit_size(2))
# print(o.is_minimal_representative(2))
# print(o.get_minimal_representative(2))
# o.reset()
# print(o.nof_orbits())
# print(o.is_minimal_representative(0))

# from bliss import PyHeap
# h = PyHeap()
# h.init(10)
# print(h.is_empty())
# h.insert(2)
# h.insert(3)
# print("empty", h.is_empty())
# print("size", h.size())
# print("val", h.remove())
# print("size", h.size())
# h.clear()
# print("size", h.size())

# from bliss import PyKQueue
# k = PyKQueue()
# k.init(10)
# print("empty", k.is_empty())
# print("size", k.size())
# k.push_front(2)
# k.push_front(3)
# print("size", k.size())
# print("front", k.front())
# print("popfront", k.pop_front())
# print("size", k.size())
# print("front", k.front())
# k.clear()
# print("size", k.size())
# k.push_front(2)
# k.push_front(3)
# k.push_back(4)
# print("size", k.size())
# print("popfront", k.pop_front())
# print("popfront", k.pop_front())
# print("popfront", k.pop_front())

# from bliss import PyCell, PyPartition
# c = PyCell()
# c.length = 1
# print("length", c.length)
# print("unit", c.is_unit())
# c.length = 2
# print("length", c.length)
# print("unit", c.is_unit())
# c = PyCell()
# c.length = 3
# p = PyPartition()
# p.init(5)
# p.splitting_queue_add(c)
# p.splitting_queue_add(c)
# print("empty", p.splitting_queue_is_empty())
# print("pop", p.splitting_queue_pop())
# print("empty", p.splitting_queue_is_empty())
# p.splitting_queue_clear()
# print("empty", p.splitting_queue_is_empty())


from bliss import PyGraph

g = PyGraph(3)
print("vertices", g.get_nof_vertices())
g.add_vertex()
print("vertices", g.get_nof_vertices())

g = PyGraph(3)
g.add_edge(0, 1)
g.add_edge(0, 2)
g_ident = PyGraph(3)
g_ident.add_edge(0, 1)
g_ident.add_edge(0, 2)
g_iso = PyGraph(3)
g_iso.add_edge(0, 1)
g_iso.add_edge(1, 2)
g_diff = PyGraph(3)
g_diff.add_edge(0, 1)
g_diff.add_edge(0, 2)
g_diff.add_edge(1, 2)
print("compare_ident", g.compare(g_ident))
print("compare_iso", g.compare(g_iso))
print("compare_diff", g.compare(g_diff))
