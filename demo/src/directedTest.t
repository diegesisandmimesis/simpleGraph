#charset "us-ascii"
//
// directedTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" that illustrates the
// functionality of the simpleGraph library
//
// It can be compiled via the included makefile with
//
//	# t3make -f directedTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

// Game definition only contains the bare minimum required to successfully
// compile because we never reach a prompt.
versionInfo:    GameID;

gameMain:       GameMainDef
	newGame() {
		generateGraph();
	}
	generateGraph() {
		local g;

		// Just generate a simple three-vertex, two-edge graph
		// and then log the results.
		g = new SimpleGraphDirected();
		g.addEdge('foo', 'bar');
		g.addEdge('bar', 'foo');
		g.addEdge('foo', 'baz');
		g.removeEdge('bar', 'foo');
		g.log();
	}
;
