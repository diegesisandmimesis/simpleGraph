#charset "us-ascii"
//
// simpleGraphCheeger.t
//
// Compute the Cheeger constant of the graph.
//
// The Cheeger constant is a measure of how "lumpy" a graph is...whether
// vertices are mostly all connected to each other, or if there are
// bottlenecks/chokepoints.
//
// WARNING:  This only works on undirected graphs, but we don't implement
//	a check anywhere.
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

#ifdef SIMPLE_GRAPH_CHEEGER

#include <bignum.h>

modify SimpleGraph
	// Property to hold the computed value.
	simpleGraphCheeger = nil

	// We get updated whenever vertices or edges are added or removed.
	updateGraph() {
		inherited();
		clearCheeger();
	}

	// Make sure we have to recompute the value.
	clearCheeger() { simpleGraphCheeger = nil }

	// Returns the value, computing it if necessary.
	getCheeger() {
		local d, l, r, t;

		// If we already computed the value, just return it.
		if(simpleGraphCheeger != nil)
			return(simpleGraphCheeger);

		// Get the vertices.
		l = getVertices();

		// This will hold the min degree.
		r = nil;

		// Go through all the vertices.
		l.forEachAssoc(function(k, v) {
			// Get the degree of the vertex.
			d = v.getDegree();

			// If this is the first vertex or the
			// degree is the smallest degree we've
			// seen, remember it.
			if((r == nil) || (d < r))
				r = d;
		});

		// Total number of edges in the graph.
		t = edgeList().length();

		// constant is the ratio.
		simpleGraphCheeger = new BigNumber(r) / new BigNumber(t);

		return(simpleGraphCheeger);
	}
;

#endif // SIMPLE_GRAPH_CHEEGER
