#charset "us-ascii"
//
// simpleGraphSubgraph.t
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

#ifdef SIMPLE_GRAPH_SUBGRAPH

modify SimpleGraph
	// Identify all the disconnected subgraphs in the graph, returning
	// a vector in which each element is itself a vector containing all
	// of the vertices in a subgraph.
	// So given the graph:
	//
	//	foo1 <-> foo2  bar1 <-> bar2  baz1 <-> baz2 <-> baz3
	//
	// the return value would be
	//
	//	[ [ foo1, foo2 ], [ bar1, bar2 ], [ baz1, baz2, baz3 ] ]
	//
	generateSubgraphs() {
		local i, l, r, u;

		// Vector for our return value.
		r = new Vector();

		// Vector for keeping track of our "unchecked" vertices.
		// Unchecked vertices are ones that we haven't evaluated
		// at all yet.
		// We start out with all of the vertices in the graph
		// as unchecked.
		l = new Vector(vertexIDList());

		// Vector for keeping track of our "unvisited" vertices.
		// Unvisited vertices are ones that we know are in the
		// subgroup we're currently working on, but we haven't
		// "visited" the vertex to check out all of its edges yet.
		u = new Vector();

		// Keep going as long as we have unchecked vertices.
		while(l.length > 0) {
			// Add a new vector to our return vector.  This is
			// where we'll be putting vertices in the current
			// subgraph.
			r.append(new Vector());

			// Add the first unchecked vertex to the "unvisited"
			// list.
			u.append(l[1]);

			// Loop as long as we have unvisited vertices.
			while(u.length > 0) {
				// Pick the first unvisited vertex, and iterate
				// over all its edges.  By definition all the
				// vertices adjacent to this vertex are in the
				// same subgraph as it, so they're all bound
				// for the subgraph vector we're currently
				// working on.
				getVertex(u[1]).edgeIDList().forEach(
					function(e) {
						// If we haven't already added
						// this adjacent vertex to
						// the subgraph vector, add
						// it to the unvisited vertex
						// list...so we'll eventually
						// go through all of ITS edges
						// too.  We add it to the
						// subgraph vector only after
						// we've "visited" it and
						// checked its edges, as
						// we're doing for a different
						// vector now.
						if(r[r.length].indexOf(e)
							== nil)
							u.append(e);

						// Remove this adjacent vertex
						// from the unchecked list.
						if((i = l.indexOf(e)) != nil)
							l.removeElementAt(i);
					}
				);

				// Add the first unvisited vertex to the
				// current subgroup.
				r[r.length].append(u[1]);

				// ...and then remove it from the unvisited
				// list.
				u.removeElementAt(1);
			}
		}

		// Return the result.
		return(r);
	}
;

#endif // SIMPLE_GRAPH_SUBGRAPH
