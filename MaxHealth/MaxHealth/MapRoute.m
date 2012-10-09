//
//  MapRoute.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/12/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "MapRoute.h"
@implementation MapRoute
@synthesize routeName;

-(id)initWithName:(NSString *)name
{
    self=[super init];
    if (self)
    {
        NSString *path=[self itemArchivePath];
        allMapPoints=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!allMapPoints)
        {
            allMapPoints=[[NSMutableArray alloc] init];
            self.routeName=name;
        }
        
    }
    return self;
}

-(id)init
{
    NSLog(@"Use MapRoute:initWithName");
    return nil;
}

-(MapPoint *)getPointAtIndex:(int)index
{
    return [allMapPoints objectAtIndex:index];
}

-(NSArray *)allMapPoints;
{
    return allMapPoints;
}
-(MapPoint *)addCoordinate:(CLLocationCoordinate2D)c
{
    MapPoint *p=[[MapPoint alloc] initWithCoordinate:c];
    [allMapPoints addObject:p];
    
    return p;
}
-(void)removePoint:(MapPoint *)p
{
    [allMapPoints removeObjectIdenticalTo:p];
}
-(void)movePointAtIndex:(int)from toIndex:(int)to
{
    if (from==to) return;
    MapPoint *p=[allMapPoints objectAtIndex:from];
    [allMapPoints removeObjectAtIndex:from];
    [allMapPoints insertObject:p atIndex:to];
}
-(NSString *)itemArchivePath
{
    NSArray *documentDirectories=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}
-(BOOL)saveChanges
{
    NSString *path=[self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:allMapPoints toFile:path];
}
@end