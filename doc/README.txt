FOO
Version 1.0
Copyright 2022 Diegesis & Mimesis, distributed under the MIT License



ABOUT THIS LIBRARY



LIBRARY CONTENTS

	FOO.h
		Header file, containing all the #defines for the library.

		You can enable and disable features by commenting or
		uncommenting the #define statements.  Each #define is prefaced
		by comments explaining what it does.

	FOO.t
		Contains the module ID for the library.

	FOO.tl
		The library file for the library.


	doc/README.txt
		This file


NOTES
	If you get an error like...

		../ProcgenMapLayout.t(193): warning: undefined symbol
		"longestPath" - assuming this is a property name

	...when compiling, make sure you have

		-D SIMPLE_GRAPH_DIJKSTRA

	in the compile options.
