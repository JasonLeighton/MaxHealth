//
//  Category.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "StatCategory.h"

@implementation StatCategory
@synthesize categoryName,trackedStats;

-(id)init
{
    NSLog (@"Error: Use initWithName.");
    return nil;
}
-(id)initWithName:(NSString *)name
{
    self=[super init];
    if (self)
    {
        self.categoryName=name;
        self.trackedStats=[[NSMutableArray alloc] init];
    }
    return self;
}

// Class function that allocs/inits a new category with a name
+(id)InitWithName:(NSString *)name
{
    StatCategory *cat=[[StatCategory alloc] initWithName:name];
    return cat;
}

// Serialize to Json
- (NSDictionary*) proxyForJson
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.categoryName, @"CategoryName",
            self.trackedStats, @"TrackedStats",
            nil];
}

-(void)addTrackedStat:(TrackedStat *)stat
{
    stat.parentCategory=self;
    [[self trackedStats] addObject:stat];
    
}

// Given a search string, returns a stat matching that string, else nil if non is found
-(TrackedStat *)FindStat:(NSString *)str
{
    for (TrackedStat *stat in self.trackedStats)
    {
        if ([stat.name isEqualToString:str])
            return stat;
    }
    return nil;
}

// Returns true if this an embedded category, so we don't have to send/receive questions and choice strings
-(BOOL)isEmbedded
{
    return false;
    NSArray *array=[[NSArray alloc] initWithObjects:@"Overall Mood",@"Exercise",@"Sleep",@"Productivity & Learning",@"Weather",@"Vices", nil];
    for (NSString *str in array)
    {
        if ([self.categoryName isEqualToString:str])
            return true;
    }
    return false;
}

// Returns true if the user has answered all the stats in this category
-(BOOL)areAllStatsAnswered
{
    for (TrackedStat *stat in self.trackedStats)
    {
        if (stat.answeredStat==false)
            return false;
    }
    return true;
}
// Returns a unique checksum for this category
-(int) GetChecksum
{
    int checksum=0;
    for (TrackedStat *stat in self.trackedStats)
    {
        checksum+=[stat GetChecksum];
    }
    return checksum;
}

// Creates random data for all the stats in this category
-(void)createRandomDataForCategory
{
    for (TrackedStat *stat in self.trackedStats)
    {
        [stat createRandomDataForStat];
    }
}
@end
