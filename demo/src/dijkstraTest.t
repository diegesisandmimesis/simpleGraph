#charset "us-ascii"
//
// dijkstraTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" that illustrates the
// functionality of the simpleGraph library
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
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

versionInfo:    GameID
        name = 'simpleGraph Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the simpleGraph library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is a simple test game that demonstrates the features
		of the simpleGraph library.
		<.p>
		In-game that's pretty much all there is to it.  Consult the
		README.txt document distributed with the library source for
		a quick summary of how to use the library in your own games.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;

// Game world only contains the bare minimum required to successfully compile
// because we never reach a prompt in it.
gameMain:       GameMainDef
	newGame() {
		generateGraph();
	}
	generateGraph() {
		local g, i, l;

		g = new SimpleGraph();
		g.addEdge('start', 'end');
		g.insertLoop('foo', 'bar', 'start', 'end');
		g.log();

#ifdef SIMPLE_GRAPH_DIJKSTRA
		"<.p>";
		l = g.dijkstraPath('start', 'end');
		for(i = 1; i <= l.length; i++) {
			"<<l[i]>>\n ";
		}

		"<.p>";
		"longest path = <<toString(g.longestPath())>>\n ";
#else // SIMPLE_GRAPH_DIJKSTRA
		"<.p>";
		"The simpleGraph library was compiled without pathfinding.\n ";
		"Re-compile with the SIMPLE_GRAPH_DIJKSTRA flag to enable it. ";
		"<.p> ";
#endif // SIMPLE_GRAPH_DIJKSTRA
	}
	showGoodbye() {}
;
