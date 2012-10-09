//
//  ShowStatsView.h
//  MaxHealth
//
//  Created by Jason Leighton on 10/2/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowStatsView : UIView
{
    NSMutableArray *statLabels;
    NSMutableArray *trackedStats;
    NSMutableArray *trackedCategories;
    
}



@property (nonatomic) NSMutableArray *values;
@property (nonatomic) int startIndex;
@property (nonatomic) int numRecordsToShow;
@property (nonatomic) int barWidth;

-(void) setCategoriesAndStats:(NSString *)cat1 stat1:(NSString *)stat1 cat2:(NSString *)cat2 stat2:(NSString *)stat2 cat3:(NSString *)cat3 stat3:(NSString *)stat3;

@end
