#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// This entire file is wrapped in a big #ifdef so the pathfinding logic
// isn't compiled in if SIMPLE_GRAPH_DIJKSTRA isn't #defined.
#ifdef SIMPLE_GRAPH_DIJKSTRA

// Little utility class to handle data used in computing the hash used for
// Dijkstra pathfinding.
class SimpleGraphDijkstraMin: object
	id = nil
	len = nil
	construct(i?, l?) {
		id = (i ? i : 0);
		len = (l ? l : 0);
	}
;

// Pathfinding methods for SimpleGraph
// This is mostly here to support the ProcgenMap library.
modify SimpleGraph
	_dijkstraHash = nil		// hash for graph traversal
	_longestPathLength = nil	// computed length of longest path

	// Clear the hash and longest path, so they have to be
	// recomputed if needed.
	clearDijkstra() {
		_dijkstraHash = nil;
		_longestPathLength = nil;
	}

	// Returns a path between the two specified vertices, computed using
	// the Dijkstra algorithm.
	dijkstraPath(v0, v1) {
		local h, r, v;

		h = getDijkstraHash(v0);
		if(!h || !h[v1])
			return(nil);

		v = h[v1];
		r = [ v, v1 ];

		while(v) {
			if(v == v0) return(r);
			if(h[v]) r = r.prepend(h[v]);
			v = h[v];
		}

		return(nil);
	}

	// Convenience method for removing an item from a list by value.
	_listRemoveByValue(lst, v) {
		local idx;

		idx = lst.indexOf(v);
		if(idx == nil) return(lst);
		return(lst.removeElementAt(idx));
	}

	// Returns the dijkstra hash for the given vertex, computing it
	// if necessary.
	getDijkstraHash(v0) {
		local alt, dHash, dj, prevHash, i, id, l, r;

		// First, we check to see if we've got a cached version of
		// the requested hash.  If so, return it.
		dj = _dijkstraHash;
		if(dj && dj[v0])
			return(dj[v0]);

		// Cache miss, so we have to compute the hash.
		dHash = new LookupTable();
		prevHash = new LookupTable();
		r = [];

		// We start off by setting all distances arbitrarily
		// high.  At the same time we add every vertex to a master
		// list that we'll use to keep track of what we still need
		// to check.
		l = vertexIDList();
		for(i = 1; i <= l.length; i++) {
			dHash[l[i]] = 1000000;
			prevHash[l[i]] = nil;
			r += l[i];
		}

		// Set the distance to the source vertex to zero
		dHash[v0] = 0;

		// Now check each unchecked vertex
		while(r.length > 0) {
			// Get the vertex closest to where we currently are
			id = _dijkstraMin(r, dHash);
			if(!id)
				return(nil);

			// Remove this vertex from the list of unchecked
			// vertices
			r = _listRemoveByValue(r, id);

			// Check all the edges of this vertex
			l = vertexEdgeIDList(id);
			for(i = 1; i <= l.length; i++) {
				// Distance to each edge is the distance to
				// the vertex plus one, unless the vertex
				// on the other end has already been found to
				// be closer.
				alt = dHash[id] + 1;
				if(alt < dHash[l[i]]) {
					dHash[l[i]] = alt;
					// Path back from edge vertex to
					// this vertex.
					prevHash[l[i]] = id;
				}
			}
		}
		dj = _dijkstraHash;
		if(!dj) {
			dj = new LookupTable();
			_dijkstraHash = dj;
		}
		dj[v0] = prevHash;

		return(prevHash);
	}

	// Given a list of nodes and a Dijkstra hash, figure out which
	// node has the shortest distance in the hash.
	_dijkstraMin(r, hash) {
		local i, min;

		if(!r || !hash)
			return(nil);

		min = new SimpleGraphDijkstraMin(r[1], hash[r[1]]);

		for(i = 1; i <= r.length; i++) {
			if(hash[r[i]] == nil) continue;
			if(min.len > hash[r[i]])
				min = new SimpleGraphDijkstraMin(r[i],
					hash[r[i]]);
		}

		if(!min)
			return(nil);

		return(min.id);
	}

	// Return longest path through the graph starting at the given
	// node.
	// This is here because it's used in the procgenMap library,
	// to estimate the size of a map to allocate.  It probably
	// really shouldn't be used for anything else unless you
	// really know what you're doing because it's a performance trap.
	longestPath(id?) {
		if(_longestPathLength != nil)
			return(_longestPathLength);

		// First make each vertex as being "not traversed".
		// KLUDGE ALERT:  This is maybe a misfeature, because it
		// touches the "canonical" vertices (instead of a local copy of
		// them).  By eh...it's a IF game, we should probably worry
		// more about the resource overhead of what we're doing than
		// worrying about thread safety or whatever.
		vertexList().forEach(function(v) {
			v._traverseFlag = nil;
		});
		_longestPathLength = _longestPath(id ? id : _firstVertex) + 1;

		return(_longestPathLength);
	}

	// Very simple, naive longest path algorithm.
	// This should work for most graphs of IF maps, because they tend
	// to be small and fairly well-behaved.
	_longestPath(id) {
		local d, max, v0, v1;

		v0 = getVertex(id);
		if(!v0)
			return(0);

		// Right now the longest path we know of is zero steps long
		max = 0;

		// Mark the starting vertex as "visited"
		v0._traverseFlag = true;

		// Go through each edge on this vertex.
		v0.edgeIDList().forEach(function(o) {
			// If we've already "visited" the vertex on the
			// far end of the edge, skip it.
			v1 = getVertex(o);
			if(!v1 || (v1._traverseFlag == true))
				return;

			// We compute the longest path involving the current
			// vertex by recursively computing the longest path
			// involving each of its neighbors and adding one to
			// that.
			d = 1 + _longestPath(o);
			if(d > max)
				max = d;
		});

		// Unmark this vertex as "visited", so other vertices
		// can try to path their way through us.
		v0._traverseFlag = nil;

		return(max);
	}
;

#endif // SIMPLE_GRAPH_DIJKSTRA
