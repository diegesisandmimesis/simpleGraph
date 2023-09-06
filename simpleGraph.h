//
// simpleGraph.h
//

// Include Dijkstra pathfinding logic
#define SIMPLE_GRAPH_DIJKSTRA

// Enable caching of pathfinding data
//#define SIMPLEGRAPH_DIJKSTRA_CACHE

// Include logic for computing the Laplacian matrix for the graph
//#define SIMPLE_GRAPH_LAPLACIAN

// Include logic for computing the Cheeger constant for the graph
//#define SIMPLE_GRAPH_CHEEGER

SimpleGraph template 'id'?;
SimpleGraphVertex template 'id'?;
SimpleGraphEdge template 'id0' 'id1';


// Don't comment this out.  It's how we announce to the compiler that we're
// here.  This is used for dependency checking in other modules.
#define SIMPLE_GRAPH_H
