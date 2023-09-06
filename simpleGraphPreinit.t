#charset "us-ascii"
//
// simpleGraphPreinit.t
//
#include <adv3.h>
#include <en_us.h>

#include "simpleGraph.h"

simpleGraphPreinit: PreinitObject
	execute() {
		forEachInstance(SimpleGraphVertex, {
			obj: obj.initializeVertex()
		});
		forEachInstance(SimpleGraphEdge, {
			obj: obj.initializeEdge()
		});
	}
;
