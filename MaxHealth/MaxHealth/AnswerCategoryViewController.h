//
//  AnswerCategoryViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/26/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatCategory.h"

@interface AnswerCategoryViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL UICreated;
    TrackedStat *pickerStat;
    UIButton *selectedButton;
    
}
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic) StatCategory *statCategory;
- (id)initWithStatCategory:(StatCategory*)category nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void) createUI;

@end
