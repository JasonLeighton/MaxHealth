//
//  CreateAccountViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/4/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"

@interface CreateAccountViewController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *emailAddress;
    __weak IBOutlet UIButton *birthdateButton;
    __weak IBOutlet UITextField *username;
    __weak IBOutlet UILabel *weightLabel;
    __weak IBOutlet UILabel *heightLabel;
    __weak IBOutlet UIButton *genderButton;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UITextField *confirmPassword;
     UIScrollView *scrollView;
    UIView *contentView;
    
    //UIDatePicker *datePickerView;
    //UIActionSheet *actionSheet;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
- (IBAction)HeightChanged:(id)sender;
- (IBAction)WeightChanged:(id)sender;
- (IBAction)BirthdatePressed:(id)sender;
- (IBAction)GenderPressed:(id)sender;
- (IBAction)CreateAccountPressed:(id)sender;
-(void)CreateAccountCallback:(NetworkResponse *)nr data:(id)callbackData;


@end
