simpleGraph
Version 1.0
Copyright 2022 Diegesis & Mimesis, distributed under the MIT License



ABOUT THIS LIBRARY

The simpleGraph library provides an interface for creating and manipulating
very simple undirected graphs.  It was written to be used by the procgenMap
library to provide an abstract data model for procgen map generation, but
it can be used for other purposes.

The library implements a version of the Dijkstra pathfinding algorithm for
graph traversal, and a naive method for computing the longest path through
a graph.  Both of these are kinda resource hogs, and so probably shouldn't
be used for "realtime" computations (for example, in a routine called
for NPC pathfinding on every player turn).  Pathfinding support is
compiled when SIMPLE_GRAPH_DIJKSTRA is #defined, which it is by
default in simpleGraph.h.


USAGE

	// Graph creation and manipulation
	//
	// Create a new, empty graph
	local g = new SimpleGraph();

	// Add a vertex.
	g.addVertex('foo');

	// Remove a vertex
	g.removeVertex('foo');

	// Add an edge.  Automagically creates the vertices if they don't
	// exist.
	g.addEdge('foo', 'bar');

	// Remove an edge.
	g.removeEdge('foo', 'bar');

	// Insert a new vertex into the edge foo <-> bar, so
	// foo <-> bar becomes foo <-> baz <-> bar.
	g.insertVertex('baz', 'foo', 'bar');

	// Remove the vertex foo, moving any edges on foo to bar
	g.simplifyVertex('foo', 'bar');

	// Remove the vertex baz and connect foo and bar, so
	// foo <-> baz <-> bar becomes foo <-> bar
	g.simplifyEdge('baz', 'foo', 'bar', true);

	// Same as above, but only removes baz's edges (and doesn't
	// delete baz itself):
	g.simplifyEdge('baz', 'foo', 'bar');

	// Insert baz <-> quux into foo <->bar, so
	// foo <-> bar becomes foo <-> baz <-> quux <-> bar
	g.insertEdge('baz', 'quux', 'foo', 'bar');

	// Make a copy of the graph.
	local c = g.clone();

	//
	// Informational methods
	//
	// Returns a list of vertex IDs.
	l = g.vertexIDList();

	// Returns a list of vertices.  The elements are instances of
	// SimpleGraphVertex.
	l = g.vertexList();

	// Returns a list of edge IDs.  Each array element is itself a
	// 2-element array consisting of the two vertex IDs.
	l = g.edgeIDList();

	// Returns a list of edges.  Each array element is itself a
	// 2-element array consisting of two SimpleGraphVertex instances.
	l = g.edgeList();


	// Returns a list of all the edge IDs on the vertex foo
	l = vertexEdgeList('foo');

	// Returns a list of all the edges on the vertex foo.  Elements of
	// the list are all instances of SimpleGraphVertex.
	l = vertexEdgeIDList('foo');

	//
	// Debugging
	//
	// Output information about the graph.  Will include a list of
	// all the vertex IDs and their associated edges.
	g.log();


LIBRARY CONTENTS

	simpleGraph.h
		Header file, containing all the #defines for the library.

		You can enable and disable features by commenting or
		uncommenting the #define statements.  Each #define is prefaced
		by comments explaining what it does.

	SimpleGraph.t
	SimpleGraphEdge.t
	SimpleGraphVertex.t
		Class definitions for the graph, edge, and vertex classes.

	SimpleGraphDijkstra.t
		Pathfinding logic.  Included/compiled into the module by
		default.

	simpleGraphModule.t
		Contains the module ID for the library.

	simpleGraph.tl
		The library file for the library.

	demo/dikstraTest.t3m
	demo/makefile.t3m
		Makefiles for the demo games.

	demo/src/dijkstraTest.t
	demo/src/sample.t
		Source of the demo games.

	doc/README.txt
		This file


NOTES
	If you get an error like...

		../ProcgenMapLayout.t(193): warning: undefined symbol
		"longestPath" - assuming this is a property name

	...when compiling, make sure you have

		-D SIMPLE_GRAPH_DIJKSTRA

	in the compile options.
