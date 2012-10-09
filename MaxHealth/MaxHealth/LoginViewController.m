//
//  LoginViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/4/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "LoginViewController.h"
#import "CreateAccountViewController.h"
#import "Profile.h"
#import "LobbyViewController.h"
#import "Popup.h"
#import "AnswerDayViewController.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize PasswordTextField;
@synthesize UsernameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        keepLogin=true;
        keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"MaxHealthLogin" accessGroup:nil];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:@"Login"];
    self.view.backgroundColor=[UIColor clearColor];
    
    NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
    NSString *username = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    if (password!=nil && username!=nil)
    {
        [UsernameTextField setText:username];
        [PasswordTextField setText:password];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)GetRecordsCallback:(NetworkResponse *)nr data:(id)callbackData
{
    [Popup StopActivityIndicator];
    if (nr.IsSuccess)
    {
        LobbyViewController *vc=[[LobbyViewController alloc] init];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:vc];
        UIWindow   *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        // Transition to new navcontroller
        [UIView transitionWithView:mainWindow duration:0.5 options: UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            mainWindow.rootViewController = navController;
        } completion:nil];
    }
    else
    {
        [Popup ShowPopup:@"Profile Error" message:@"Couldn't retrieve records!" popupType:OK  delegate:nil];
    }

}
-(void)GetProfileCallback:(NetworkResponse *)nr data:(id)callbackData
{
    [Popup StopActivityIndicator];
    if (nr.IsSuccess)
    {
        if (keepLogin)
        {
            [keychainItem setObject:[PasswordTextField text] forKey:(__bridge id)kSecValueData];
            [keychainItem setObject:[UsernameTextField text] forKey:(__bridge id)kSecAttrAccount];
        }
        else
        {
            [keychainItem resetKeychainItem];
        }
        [Popup ShowActivityIndicatorOnView:self.view];
        [Networking GetRecords:20 callback:@selector(GetRecordsCallback:data:) fromObject:self];
    }
    else
    {
        [Popup ShowPopup:@"Profile Error" message:@"Couldn't retrieve profile!" popupType:OK  delegate:nil];
        
        NSLog (@"Couldn't retrieve profile!");
    }
    
}

-(void)LoginCallback:(NetworkResponse *)nr data:(id)callbackData
{
    [Popup StopActivityIndicator];
    if (nr.IsSuccess)
    {
        [Popup ShowActivityIndicatorOnView:self.view];
        [Networking GetProfile:@selector(GetProfileCallback:data:) fromObject:self];
    }
    else
    {
        [Popup ShowPopup:@"Login Error" message:@"Username or password was incorrect." popupType:OK  delegate:nil];
            
        NSLog (@"Couldn't login!");
    }
}


- (IBAction)LoginPressed:(id)sender
{
    NSLog (@"Login pressed!");
    [Popup ShowActivityIndicatorOnView:[self view]];
    [Networking Login:[UsernameTextField text] password:[PasswordTextField text] callback:@selector(LoginCallback:data:) fromObject:self];
    
}

- (IBAction)CreateAccountPressed:(id)sender
{
    NSLog (@"Create account pressed!");
    CreateAccountViewController *vc=[[CreateAccountViewController alloc] init];
    //AnswerDayViewController *vc=[[AnswerDayViewController alloc] init];
    UINavigationController *navController=[self navigationController];
    [navController pushViewController:vc animated:YES];
}

- (IBAction)KeepMeLoggedIn:(id)sender
{
    UISwitch *sw=(UISwitch *)sender;
    NSLog (@"Switch is now %d",[sw isOn]);
    keepLogin=[sw isOn];
    
}
@end
