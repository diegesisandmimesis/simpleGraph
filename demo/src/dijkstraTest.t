#charset "us-ascii"
//
// dijkstraTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" that illustrates the
// pathfinding of the simpleGraph library
//
// It can be compiled via the included makefile with
//
//	# t3make -f dijkstraTest.t3m
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
        name = 'simpleGraph Library Pathfinding Demo'
        byline = 'Diegesis & Mimesis'
        desc = 'Pathfinding demo for the simpleGraph library. '
        version = '1.0'
        IFID = '12345'
	// No ABOUT text because we're not interactive
	showAbout() {}
;

// Game world only contains the bare minimum required to successfully compile
// because we never reach a prompt in it.
gameMain:       GameMainDef
	newGame() {
		generateGraph();
	}
	generateGraph() {
		local g, i, l;

		// Create a simple four vertex graph.  It will look like
		// 	start <-> foo <-> bar <-> end
		g = new SimpleGraph();
		g.addEdge('start', 'end');
		g.insertEdge('foo', 'bar', 'start', 'end');
		g.log();

#ifdef SIMPLE_GRAPH_DIJKSTRA
		// Find and log a path from "start" to "end".
		"<.p>";
		l = g.dijkstraPath('start', 'end');
		for(i = 1; i <= l.length; i++) {
			"<<l[i]>>\n ";
		}

		// Report the longest path across the graph.
		"<.p>";
		"longest path = <<toString(g.longestPath())>>\n ";
#else // SIMPLE_GRAPH_DIJKSTRA
		// Complain if we were compiled without pathfinding support.
		"<.p>";
		"The simpleGraph library was compiled without pathfinding.\n ";
		"Re-compile with the SIMPLE_GRAPH_DIJKSTRA flag to enable it. ";
		"<.p> ";
#endif // SIMPLE_GRAPH_DIJKSTRA
	}
	showGoodbye() {}
;
