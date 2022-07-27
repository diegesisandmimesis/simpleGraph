#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

// Class for map vertices.
// A vertex is just a node, and in our case all we care about is the vertex ID
// and what other vertices it is connected to.
class SimpleGraphVertex: object
	id = nil			// vertex ID
	_edges = nil			// LookupTable of edges
	_traverseFlag = nil		// used in pathfinding

	construct(v) {
		self.id = v;
	}
	getEdges() {
		if(_edges == nil) _edges = new LookupTable();
		return(_edges);
	}
	edgeList() { return(getEdges().valsToList()); }
	edgeIDList() { return(getEdges().keysToList()); }
	getEdge(id0) { return(getEdges()[id0]); }
	setEdge(id0, e) {
		if(getEdge(id0)) return(nil);
		getEdges()[id0] = e;
		return(e);
	}
	removeEdge(id0) { getEdges().removeElement(id0); }
;
