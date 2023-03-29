#charset "us-ascii"
//
// simpleGraphDirected.t
//
// Class for handling directed graphs.
//
// The basic SimpleGraph glass implements undirected graphs.  That means that
// edges are bidirectional:  if you have two vertices "foo" and "bar" and
// add an edge from foo to bar, this works as an edge between bar and foo.
//
// In a directed graph the edges are one-way:  adding an edge between foo and
// bar doesn't mean there's an edge between bar and foo.
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

class SimpleGraphDirected: SimpleGraph
	addEdge(v0, v1, dontAddVertices?) {
		local e;

		if(dontAddVertices != true) {
			if(!getVertex(v0)) addVertex(v0);
			if(!getVertex(v1)) addVertex(v1);
		}

		e = getEdge(v0, v1);
		if(!e)
			e = _createEdge(v0, v1);

		_addEdge(v0, v1, e);

		return(true);
	}

	removeEdge(v0, v1) {
		_removeEdge(v0, v1);

		getEdges().removeElement(_edgeID(v0, v1));

		return(true);
	}
;
