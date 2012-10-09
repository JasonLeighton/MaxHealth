//
//  Category.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackedStat.h"

@interface StatCategory : NSObject
{
    
}
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSMutableArray *trackedStats;

+(id)InitWithName:(NSString *)name;
-(id)initWithName:(NSString *)name;
- (NSDictionary*) proxyForJson;
-(void)addTrackedStat:(TrackedStat *)stat;
-(TrackedStat *)FindStat:(NSString *)str;
-(int)GetChecksum;
-(BOOL)areAllStatsAnswered;
-(BOOL) isEmbedded;
-(void)createRandomDataForCategory;
@end
