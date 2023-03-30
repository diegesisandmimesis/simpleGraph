#charset "us-ascii"
//
// subgraphTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" that illustrates the
// pathfinding of the simpleGraph library
//
// It can be compiled via the included makefile with
//
//	# t3make -f subgraphTest.t3m
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

versionInfo: GameID;

// Game world only contains the bare minimum required to successfully compile
// because we never reach a prompt in it.
gameMain:       GameMainDef
	newGame() { generateGraph(); }

	generateGraph() {
		local g;

		// Graph with 8 vertices, in 3 disconnected subgraphs.
		g = new SimpleGraph();
		g.addEdge('foo1', 'foo2');
		g.addEdge('bar1', 'bar2');
		g.addEdge('baz1', 'baz2');
		g.addEdge('baz2', 'baz3');
		g.addEdge('baz3', 'baz4');
		//g.log();

		g.generateSubgraphs().forEach(function(o) {
			"<<toString(o)>>\n ";
		});
	}
;
