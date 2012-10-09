//
//  LoginViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/4/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface LoginViewController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    KeychainItemWrapper *keychainItem;
    BOOL keepLogin;
}
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
- (IBAction)LoginPressed:(id)sender;
- (IBAction)CreateAccountPressed:(id)sender;
- (IBAction)KeepMeLoggedIn:(id)sender;

@end
