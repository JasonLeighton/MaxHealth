//
//  MapPoint.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/12/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c
{
    self = [super init];
    if (self) {
        coordinate = c;
    }
    return self;
}

- (id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32)];
}

@end
