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
