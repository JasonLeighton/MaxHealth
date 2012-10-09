//
//  MapRoute.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/12/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPoint.h"



@interface MapRoute : NSObject
{
    NSMutableArray *allMapPoints;
    NSString *routeName;
    
}
@property (nonatomic, copy) NSString *routeName;
-(id) initWithName:(NSString *)name;
-(MapPoint *)getPointAtIndex:(int)index;
-(NSArray *)allMapPoints;
-(MapPoint *)addCoordinate:(CLLocationCoordinate2D)c;
-(void)removePoint:(MapPoint *)pnt;
-(void)movePointAtIndex:(int)from toIndex:(int)to;
-(NSString *)itemArchivePath;
-(BOOL)saveChanges;

@end

