#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

// Abstract map graph class.
// Our graphs are always undirected and we don't care about edge length.
class SimpleGraph: object
	_vertices = nil			// LookupTable of vertices
	_edges = nil			// LookupTable of edges

	_firstVertex = nil		// First vertex added to graph.
					// By default we assume this is
					// the "entry" vertex (e.g., the
					// player's starting position)

	// Returns all the vertices as a LookupTable
	getVertices() {
		if(_vertices == nil) _vertices = new LookupTable();
		return(_vertices);
	}

	// Returns all the vertex IDs as a List
	vertexIDList() { return(getVertices().keysToList()); }

	// Returns all the vertices as a List
	vertexList() { return(getVertices().valsToList()); }

	_addVertex(id, v) {
		// Set the first vertex property if it hasn't already been set
		if(_firstVertex == nil)
			_firstVertex = id;

		getVertices()[id] = v;
		clearDijkstra();

		return(v);
	}

	// Add a vertex with the given ID
	addVertex(id) {
		if(getVertex(id)) return(nil);
		return(_addVertex(id, new SimpleGraphVertex(id)));
	}

	// Returns the vertex with the given ID
	getVertex(id) {
		return(getVertices()[id]);
	}

	// Removes the vertex with the given ID
	removeVertex(id) {
		getVertices().forEachAssoc(function(k, v) {
			if(k == id) return;
			v.removeEdge(id);
		});
		getVertices().removeElement(id);
		clearDijkstra();
	}

	getEdges() {
		if(_edges == nil) _edges = new LookupTable();
		return(_edges);
	}

	// Returns a list of all the edges in the graph, in the form
	// of a list of 2-element lists, where the 2-element lists are
	// vertex IDs.
	//
	// I.e. the graph
	//
	//	foo <-> bar <-> baz
	//
	// would return
	//
	//	[ [ 'foo', 'bar' ], [ 'bar', 'baz' ] ]
	edgeIDList() {
		local r, v;

		r = [];
		edgeList().forEach(function(o) {
			v = o.getVertices();
			r += [[ v[1], v[2] ]];
		});

		return(r);
	}

	// Returns a list containing all the edges.
	// That is, a list whose entires are instances of SimpleMapEdge
	edgeList() { return(getEdges().valsToList()); }

	// List all the edges on the given vertex
	vertexEdgeList(id) {
		local v;

		v = getVertex(id);
		if(!v) return([]);
		return(v.edgeList());
	}

	vertexEdgeIDList(id) {
		local v;

		v = getVertex(id);
		if(!v) return([]);
		return(v.edgeIDList());
	}

	// Create a new SimpleGraphEdge instance and add it to the graph's
	// table of edges.
	_createEdge(v0, v1) {
		local e;

		e = new SimpleGraphEdge(v0, v1);
		getEdges()[_edgeID(v0, v1)] = e;

		return(e);
	}
	// Convenience method that adds an edge to a single vertex
	// This alone isn't sufficient; external callers should use
	// addEdge() instead.
	_addEdge(v0, v1, e) {
		local v;

		v = getVertex(v0);
		if(!v)
			return(nil);

		v.setEdge(v1, e);

		return(true);
	}
	// Add an edge.  Since we're always an undirected graph, whenever we
	// add an edge we're really adding two:  v0 -> v1 and v1 -> v0.
	// Third arg is an optional boolean.  If true, vertices that don't
	// already exist won't be added.
	addEdge(v0, v1, dontAddVertices?) {
		local e;

		// Create any vertices that don't exist unless we're explicitly
		// told not to
		if(dontAddVertices != true) {
			if(!getVertex(v0)) addVertex(v0);
			if(!getVertex(v1)) addVertex(v1);
		}

		// See if the edge already exists.  If it doesn't, create it
		e = getEdge(v0, v1);
		if(!e)
			e = _createEdge(v0, v1);

		// Update the vertices to know about the new edge
		_addEdge(v0, v1, e);
		_addEdge(v1, v0, e);

		return(true);
	}

	// The edgeID is just the key we use in the LookupTable of edges.
	// We don't do any disambiguation here, that's mostly done by using
	// getEdge(), which checks both vertex orderings.
	_edgeID(id0, id1) {
		return(id0 + ':' + id1);
	}
	getEdge(id0, id1) {
		local e;

		e = getEdges()[_edgeID(id0, id1)];
		if(e) return(e);
		return(getEdges()[_edgeID(id1, id0)]);
	}
	// Another convenience method, this time to remove v1 from v0's
	// adjacency list
	_removeEdge(v0, v1) {
		local v;

		v = getVertex(v0);
		if(!v) return(nil);
		v.removeEdge(v1);
		clearDijkstra();
		return(true);
	}
	// Remove an edge.  Since we're always an undirected graph, when
	// we remove v0 -> v1 we always also remove v1 -> v0.
	removeEdge(v0, v1) {
		_removeEdge(v0, v1);
		_removeEdge(v1, v0);

		// Only one of these will succeed but the other will fail
		// gracefully.
		getEdges().removeElement(_edgeID(v0, v1));
		getEdges().removeElement(_edgeID(v1, v0));

		return(true);
	}

	// Stub method for when we're compiled without pathfinding
	clearDijkstra() {}

	getFirstVertex() {
		return(_firstVertex);
	}

	// Manually set the "first" vertex.
	// The "first" vertex is what we use in traversals;  we assume it
	// represents something like the room the player starts in.
	// By default it's the first vertex added to the graph.
	setFirstVertex(id) {
		if(!getVertex(id))
			return(nil);

		_firstVertex = id;

		return(true);
	}


	// Insert a new vertex id into the edge v0 <-> v1, so
	// v0 <-> v1 becomes v0 <-> id <-> v1
	insertVertex(id, v0, v1) {
		if(!getEdge(v0, v1)) return(nil);
		removeEdge(v0, v1);
		addVertex(id);
		addEdge(v0, id);
		addEdge(id, v1);
		return(true);
	}
	// Remove the src vertex, adding any edges on src to dst
	simplifyVertex(src, dst) {
		local v0, v1;

		v0 = getVertex(src);
		v1 = getVertex(dst);
		if(!v0 || !v1)
			return(nil);
		v0.edgeIDList().forEach(function(o) {
			// Skip edges to either of our vertices.  v0 because
			// it's about to go away and v1 because it's "us".
			if((o == v0) || (o == v1)) return;
			v1.addEdge(o);
		});
		removeVertex(src);
		return(true);
	}
	// Remove vertex id, connecting v0 and v1, so
	//	v0 <-> id <-> v1
	// becomes
	//	v0 <-> v1
	simplifyEdge(id, v0, v1, deleteVertex) {
		if(!getEdge(v0, id) || !getEdge(id, v1))
			return(nil);
		removeEdge(v0, id);
		removeEdge(id, v1);
		addEdge(v0, v1);
		if(deleteVertex) removeVertex(id);
		return(true);
	}
	// Insert a 2-node cyclic graph into the edge v0-v1.  So:
	//	v0 <-> v1
	// ...becomes...
	//	v0 <-> id0 <-> id1 <-> v1
	insertLoop(id0, id1, v0, v1) {
		if(!removeEdge(v0, v1)) return(nil);
		if(!getVertex(id0)) addVertex(id0);
		if(!getVertex(id1)) addVertex(id1);
		addEdge(id0, id1);
		addEdge(v0, id0);
		addEdge(id1, v1);

		return(true);
	}
	// Returns a new copy of this graph
	clone() {
		local g;

		g = new SimpleGraph();
		vertexList().forEach(function(o) {
			g.addVertex(o);
		});
		edgeIDList().forEach(function(o) {
			g.addEdge(o[1], o[2]);
		});

		return(g);
	}
	log() {
		"<.p>\n ";
		vertexList().forEach(function(v) {
			"Vertex <q><<v.id>></q>\n ";
			v.edgeIDList().forEach(function(o) {
				"\t<<o>>\n ";
			});
		});
		"<.p> ";
	}
;
