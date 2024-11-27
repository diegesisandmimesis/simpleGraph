#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

// Class for graph edges.
// We assume that graphs are always undirected, so we treat
// the edge foo -> bar the same as bar -> foo.
class SimpleGraphEdge: object
	id0 = nil
	id1 = nil

	// Because we assume the graph is undirected which vertex is _vertex0
	// and which is _vertex1 is arbitrary
	_vertex0 = nil
	_vertex1 = nil

	// By default we treat all edges as length 1.  Most of the stuff
	// this library was designed to do doesn't really care about edge
	// lengths, because all we're using the graph for is to keep track
	// of what rooms are connected to each other.  But we provide a
	// method for keeping track of edge length in case layout widgets
	// want to use it.
	_length = 1

	// Constructor requires two vertex IDs as arguments
	construct(v0, v1, l?) {
		_vertex0 = v0;
		_vertex1 = v1;
		_length = ((l != nil) ? l : 1);
	}

	// Returns our vertices as a 2-element array.
	getVertices() {
		return([_vertex0, _vertex1]);
	}

	// Set our vertices.  This isn't actually used anywhere in the
	// library or any of the libraries that include it as a dependency,
	// but it's provided for completeness' sake.  Might be a misfeature,
	// because changing the vertices in an individual edge might break
	// things if the caller isn't taking care of updating everything
	// else in the graph itself.
	setVertices(v0, v1) {
		_vertex0 = v0;
		_vertex1 = v1;
	}

	// Returns boolean true if the two args are our two vertex IDs,
	// independent of order.
	matchVertices(v0, v1) {
		if(((_vertex0 == v0) && (_vertex1 == v1))
			|| ((_vertex1 == v0) && (_vertex0 == v1)))
			return(true);
		return(nil);
	}

	// Methods for getting/setting the length of the edge.  Implementation
	// wart provided entirely to support possible future developments.
	getLength() { return(_length); }
	setLength(v) { _length = v; }

	// Called at preinit and only used for edges declared via the +[decl]
	// syntax.
	initializeEdge() {
		local v;

		// If we don't have a location we've already failed.
		if(location == nil)
			return;

		if(location.ofKind(SimpleGraph)) {
			// If we're "owned" by the graph declaration, then
			// we need both vertex IDs.
			location.addEdge(id0, id1, nil, self);
		} else if(location.ofKind(SimpleGraphVertex)) {
			// If we're "owned" by a vertex, then we
			// only need one vertex ID (the vertex we're
			// not "owned" by).
			v = location;
			if((v.location == nil)
				|| !v.location.ofKind(SimpleGraph))
				return;

			_vertex0 = v;
			id0 = v.id;

			if(_vertex1 && _vertex1.ofKind(SimpleGraphVertex))
				id1 = _vertex1.id;

			//v.location.addEdge(self);
			// Order of arguments is important here,
			// because the graph might be directed.
			v.location.addEdge(id0, id1, nil, self);
		}
	}
;
