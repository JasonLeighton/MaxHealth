//
//  AnswerDayTableViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 10/2/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "Profile.h"
#import "HealthRecord.h"
#import <UIKit/UIKit.h>

@interface AnswerDayTableViewController : UITableViewController
{
    HealthRecord *healthRecord;
}
-(id) initWithHealthRecord:(HealthRecord *)hr;
@end
