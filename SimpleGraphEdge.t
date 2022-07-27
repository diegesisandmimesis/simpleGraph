#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

class SimpleGraphEdge: object
	_vertex0 = nil
	_vertex1 = nil
	_length = 0
	construct(v0, v1) {
		_vertex0 = v0;
		_vertex1 = v1;
	}
	getVertices() {
		return([_vertex0, _vertex1]);
	}
	setVertices(v0, v1) {
		_vertex0 = v0;
		_vertex1 = v1;
	}
	matchVertices(v0, v1) {
		if(((_vertex0 == v0) && (_vertex1 == v1))
			|| ((_vertex1 == v0) && (_vertex0 == v1)))
			return(true);
		return(nil);
	}
;
