//
//  BiBestFirstFinder.m
//  PathFindingForObjC-Example
//
//  Created by JasioWoo on 14/10/31.
//  Copyright (c) 2014年 JasioWoo. All rights reserved.
//

#import "BiBestFirstFinder.h"

@implementation BiBestFirstFinder

- (float)calculateHeuristicValueWithX:(float)dx andY:(float)dy {
	return [super calculateHeuristicValueWithX:dx andY:dy] * 1000000;
}

@end
