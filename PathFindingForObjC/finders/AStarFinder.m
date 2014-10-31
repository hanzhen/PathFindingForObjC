//
//  AStarFinder.m
//
//  Created by JasioWoo on 14/10/28.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "AStarFinder.h"
#import "PFUtil.h"
#import "PFGrid.h"

@implementation AStarFinder


- (NSArray *)findPathInStartNode:(PFNode *)startNode toEndNode:(PFNode *)endNode withGrid:(PFGrid *)grid traceFinding:(NSMutableArray *__autoreleasing *)traceArrForTest {
	
	NSMutableArray *openList = [NSMutableArray array];
	PFNode *node = nil, *neighbor = nil;
	NSArray *neighbors = nil;
	NSUInteger l=0;
	int i=0, x=0, y=0, endX=endNode.x, endY=endNode.y;
	float ng = 0;
	
	// set the `g` and `f` value of the start node to be 0
	startNode.g = 0;
	startNode.f = 0;
	
	// push the start node into the open list
	[openList addObject:startNode];
	startNode.opened = 1;
	
	// trace
	if (traceArrForTest) {[(*traceArrForTest) addObject:[startNode copy]];}
	
	// while the open list is not empty
	while (openList.count>0) {
		// pop the position of node which has the minimum `f` value.
		[openList sortUsingSelector:@selector(descFWeightSort:)];
		node = [openList lastObject];
		[openList removeLastObject];
		node.closed = YES;
		
		// trace
		NSMutableArray *traceArr = nil;
		if (traceArrForTest) {
			[(*traceArrForTest) addObject:[node copy]];
			traceArr = [NSMutableArray array];
		}
		
		// if reached the end position, construct the path and return it
		if (node == endNode) {
			return [PFUtil backtrace:endNode];
		}
		
		// get neigbours of the current node
		neighbors = [grid getNeighborsWith:node isAllowDiagonal:self.allowDiagonal isCrossCorners:self.dontCrossCorners];
		for (i = 0, l = neighbors.count; i < l; ++i) {
			neighbor = neighbors[i];
			
			if (neighbor.closed) {
				continue;
			}
			
			x = neighbor.x;
			y = neighbor.y;
			
			// get the distance between current node and the neighbor
			// and calculate the next g score
//			ng = node.g + ((x-node.x == 0 || y-node.y == 0) ? 1 : M_SQRT2);
			ng = node.g + ((x-node.x == 0 || y-node.y == 0) ? 1 : 1.4);
			
			// check if the neighbor has not been inspected yet, or
			// can be reached with smaller cost from the current node
			if (neighbor.opened==0 || ng < neighbor.g) {
				neighbor.g = ng;
				neighbor.h = neighbor.h==0 ? self.weight * [self calculateHeuristicValueWithX:abs(x - endX) andY:abs(y - endY)] : neighbor.h;
				neighbor.f = neighbor.g + neighbor.h;
				neighbor.parent = node;
				
				if (neighbor.opened==0) {
					[openList addObject:neighbor];
					neighbor.opened = 1;
				}
				
				// trace
				if (traceArrForTest) { [traceArr addObject:[neighbor copy]]; }
			}
		} // end for each neighbor
		
		// trace
		if (traceArrForTest && traceArr.count>0) { [(*traceArrForTest) addObject:traceArr]; }
	} // end while not open list empty
	
	// fail to find the path
	return nil;
}





@end
