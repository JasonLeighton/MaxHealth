//
//  ShowStatsViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 10/1/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowStatsView.h"

@interface ShowStatsViewController : UIViewController
{
    __weak IBOutlet UIButton *leftArrowButton;
    
    __weak IBOutlet UIButton *rightArrowButton;
    ShowStatsView *statsView;
    NSDateFormatter *shortDateFormatter;
    NSMutableArray *dateLabels;

    
}

@property(nonatomic) CGRect graphRect;
@property(nonatomic) int numRecordsToShow;
@property(nonatomic) int barWidth;
- (IBAction)leftArrowPressed:(id)sender;
- (IBAction)rightArrowPressed:(id)sender;
- (IBAction)findCorrelationPressed:(id)sender;

@end

// Simple class for comparing stats
@interface StatCompare:NSObject
{
}
@property (nonatomic) NSString *stat1Name,*stat2Name,*cat1Name,*cat2Name;
@property (nonatomic) float pearsonCoefficient;

@end
