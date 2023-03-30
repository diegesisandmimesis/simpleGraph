#charset "us-ascii"
//
// nextHopCacheTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Non-interactive test of next hop caching.
//
// It can be compiled via the included makefile with
//
//	# t3make -f nextHopCacheTest.t3m
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
	_graph = nil

	newGame() { generateGraph(); }

	generateGraph() {
		// Create a simple four vertex graph.  It will look like
		// 	start <-> foo <-> bar <-> end
		_graph = new SimpleGraph();
		_graph.addEdge('start', 'end');
		_graph.insertEdge('foo', 'bar', 'start', 'end');

		// Create the next hop cache for each vertex.
		_graph.generateNextHopCache();

		_logPath('start', 'end');
		_logPath('end', 'start');
	}

	_logPath(id0, id1) {
		"Path from <q><<id0>></q> to <q><<id1>></q>\n ";
		_graph.findNextHopPath(id0, id1).forEach(function(o) {
			"\t<q><<o.id>></q>\n ";
		});
	}
;
