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

		_logSubgraphs(g);

		// Connect the first two subgraphs
		g.addEdge('foo2', 'bar1');

		_logSubgraphs(g);

		// And connect the last
		g.addEdge('bar2', 'baz1');

		_logSubgraphs(g);

		g = new SimpleGraphDirected();
		g.addEdge('foo1', 'foo2');
		g.addEdge('foo2', 'foo1');
		g.addEdge('foo2', 'foo3');
		g.addEdge('foo3', 'foo2');
		g.addEdge('bar1', 'bar2');
		g.addEdge('bar2', 'bar1');
		g.addEdge('bar2', 'bar3');
		g.addEdge('bar3', 'bar2');

		_logSubgraphs(g);
	}

	_logSubgraphs(g) {
		local l;

		"<.p>\nDisconnected subgraphs: \n";
		
		l = g.generateSubgraphs();
		if(l.length > 1) {
			l.forEach(function(o) {
				"\t<<toString(o)>>\n ";
			});
		} else {
			"No disconnected subgraphs.\n ";
		}
	}
;
