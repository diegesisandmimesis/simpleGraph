#charset "us-ascii"
//
// simpleGraphLaplacian.t
//
// Construct the Laplacian matrix for the graph.
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

#ifdef SIMPLE_GRAPH_LAPLACIAN

modify SimpleGraph
	// Property to hold the computed matrix.
	simpleGraphLaplacian = perInstance(new Vector())

	// We get updated when the number of edges or vertices changes.
	updateGraph() {
		inherited();
		clearLaplacian();
	}

	// Flush any stored matrix we already had.
	clearLaplacian() { simpleGraphLaplacian.setLength(0); }

	// Return the matrix, computing it if necessary.
	getLaplacian() {
		local l, v;

		// If the length is nonzero, we must have previously
		// computed the matrix.  Just return it.
		if(simpleGraphLaplacian.length != 0)
			return(simpleGraphLaplacian);

		// We go through the list of vertices...
		l = getVertices();
		l.forEachAssoc(function(k0, v0) {
			// We create a new vector for each vertex,
			// which will be a row in the matrix.
			v = new Vector();

			// Now we go through the vertex list again.
			l.forEachAssoc(function(k1, v1) {
				// We check if this vertex is the
				// same one as in the outer loop,
				// if it's adjacent to the one in
				// the outer loop, or if it's
				// non-adjacent.
				if(k0 == k1) {
					// Diagonal values are the
					// degree of the vertex.
					v.append(v0.getDegree());
				} else if(v0.isAdjacent(k1)) {
					// Adjacent vertices are -1
					v.append(-1);
				} else {
					// Non-adjacent vertices are 0
					v.append(0);
				}
			});

			// Add the row to the matrix.
			simpleGraphLaplacian.append(v);
		});

		return(simpleGraphLaplacian);
	}
;

#endif // SIMPLE_GRAPH_LAPLACIAN
