#charset "us-ascii"
//
// simpleGraphNextHopCache.t
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

#ifdef SIMPLE_GRAPH_NEXT_HOP_CACHE

modify SimpleGraphVertex
	// Table of the next hop from us to every other vertex in the
	// graph.
	nextHopCache = perInstance(new LookupTable())

	// Returns the next hop for the given destination.
	getNextHop(id0) { return(nextHopCache[id0]); }

	// Remember a next hop.  First arg is the destination vertex ID
	// and the second is the next hop vertex itself.
	// The destination might be distant (many hops away),
	// but the next hop will always be adjacent to this vertex (that
	// is, adjacent to the vertex whose table is being updated here).
	setNextHop(id0, v) { nextHopCache[id0] = v; }

	clearNextHop() {
		nextHopCache.keysToList().forEach(function(o) {
			nextHopCache.removeElement(o);
		});
	}
;

modify SimpleGraph
	// Generate the next hop lookup tables for each vertex.
	generateNextHopCache() {
		local l, p;

		// All the vertices in the graph as a LookupTable.
		l = getVertices();

		// We go through each vertex...
		l.forEachAssoc(function(k0, v0) {
			// ...and check it against EVERY OTHER vertex
			// in the graph.
			l.forEachAssoc(function(k1, v2) {
				// Make sure we don't try to compute
				// a path to ourselves.
				if(k0 == k1)
					return;

				// Get the Dijkstra path between the
				// vertices.
				if((p = dijkstraPath(k0, k1)) == nil)
					return;

				// Make sure it's a valid path.
				if(p.length < 2)
					return;

				// The first element of the path is the
				// current vertex, and the second is the
				// next hop.  Remember it.
				v0.setNextHop(k1, getVertex(p[2]));
			});
		});
	}

	// Return the next hop.  Broken out as a separate method to make
	// it easier for derived classes to do fancy things here.
	fetchNextHop(v0, v1) { return(v0.getNextHop(v1.id)); }

	// Returns the (cached) path between the two vertices.
	findNextHopPath(v0, v1) {
		local r, v;

		if((v0 == nil) || (v1 == nil))
			return(nil);
		// Make sure we have vertex intances.  If we don't, assume
		// we got vertex IDs instead and try to look them up.
		if(!v0.ofKind(SimpleGraphVertex))
			v0 = getVertex(v0);
		if(!v1.ofKind(SimpleGraphVertex))
			v1 = getVertex(v1);

		// If we don't have vertices at this point, we're done, fail.
		if((v0 == nil) || (v1 == nil))
			return(nil);

		// A vector to hold the path.
		r = new Vector();

		// The first step on the path is always the starting vertex.
		v = v0;

		// We keep iterating until we get a nil vertex.
		while(v != nil) {
			// First, add the vertex to our path.
			r.append(v);

			// If the current vertex is the destination vertex,
			// the we're done.  Immediately return the path.
			if(v == v1)
				return(r);

			// Get the next step in the path.
			v = fetchNextHop(v, v1);
		}

		// Return the path.  We only reach here if pathing failed.
		return(r);
	}
;

#endif // SIMPLE_GRAPH_NEXT_HOP_CACHE
