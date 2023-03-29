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
	_data = nil			// user data for vertex

	// Constructor requires only the vertex ID
	construct(v, d?) {
		self.id = v;
		_data = ((d != nil) ? d : nil);
	}

	getData() { return(_data); }
	setData(v) { _data = v; }

	// Returns the hash table of edges.
	getEdges() {
		if(_edges == nil) _edges = new LookupTable();
		return(_edges);
	}

	// Returns the edges as an array.  Values are instances of
	// the edge class, NOT edge/vertex IDs.
	edgeList() { return(getEdges().valsToList()); }

	// Returns an array of the edge IDs.
	edgeIDList() { return(getEdges().keysToList()); }

	// Returns the edge matching the passed ID.
	getEdge(id0) { return(getEdges()[id0]); }

	// Set an entry in the edge hash table.  First arg is the edge ID,
	// second is an instance of the edge class.
	setEdge(id0, e) {
		if(getEdge(id0)) return(nil);
		getEdges()[id0] = e;
		return(e);
	}

	// Removes the edge with the passed edge ID from the edge hash table.
	removeEdge(id0) { getEdges().removeElement(id0); }

	// Returns the degree of the vertex
	getDegree() {
		return(edgeIDList().length);
	}

	isAdjacent(id0) { return(getEdge(id0) != nil); }
;
