//
//  AnswerDayViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatCategory.h"
#import "HealthRecord.h"

@interface AnswerDayViewController : UIViewController
{
    
    __weak IBOutlet UIButton *DayButton;
    BOOL isToday;
    BOOL populatedDatabase;
    HealthRecord *healthRecord; // The health record we're answering
    
}
@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIView *contentView;
-(id) initWithHealthRecord:(HealthRecord *)hr;
- (IBAction)DayButtonPressed:(id)sender;
-(UIButton *)CreateButtonForCategory:(StatCategory *)cat withIndex:(int)index;

@end
