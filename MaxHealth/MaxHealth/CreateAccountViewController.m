//
//  CreateAccountViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/4/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "LobbyViewController.h"
#import "Profile.h"
#import "Networking.h"
#import "Popup.h"

@interface CreateAccountViewController ()

@end


@implementation CreateAccountViewController
@synthesize scrollView,contentView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[Profile sharedProfile] SetProfileDefaults];
        // Custom initialization
    }
        
    return self;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize=self.contentView.bounds.size;
    //self.scrollView.showsVerticalScrollIndicator = NO;
    [self updateHeightLabel];
    [self updateWeightLabel];
    [self updateBirthdateButton];
    [self updateGenderButton];
    [[self navigationItem] setTitle:@"Create Account"];
    self.view.backgroundColor=[UIColor clearColor];
}

- (void)viewDidUnload
{
    birthdateButton = nil;
    heightLabel = nil;
    weightLabel = nil;
    self.scrollView=nil;
    self.contentView=nil;
    genderButton = nil;
    password = nil;
    confirmPassword = nil;
    username = nil;
    emailAddress = nil;
    username = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) updateHeightLabel
{
    int heightValue=[[Profile sharedProfile] height];
    int ft=heightValue/12;
    int inches=heightValue % 12;
    NSString *str=[[NSString alloc] initWithFormat:@"Height: %d' %d\"",ft,inches];
    [heightLabel setText:str];
    
    
}
-(void) updateWeightLabel
{
    int weightValue=[[Profile sharedProfile] weight];
    NSString *str=[[NSString alloc] initWithFormat:@"Weight: %d lbs",weightValue];
    [weightLabel setText:str];
}
-(void) updateBirthdateButton
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [birthdateButton setTitle:[dateFormatter stringFromDate:[[Profile sharedProfile] birthdate]] forState:UIControlStateNormal];

}

- (IBAction)HeightChanged:(id)sender
{
    UIStepper *stepper=(UIStepper *)sender;
    [[Profile sharedProfile] setHeight:stepper.value];
    [self updateHeightLabel];
}

- (IBAction)WeightChanged:(id)sender {
    UIStepper *stepper=(UIStepper *)sender;
    [[Profile sharedProfile] setWeight:stepper.value];
    [self updateWeightLabel];
}
- (void)changeDate:(UIDatePicker *)sender {
    
    [[Profile sharedProfile] setBirthdate:sender.date];
    [self updateBirthdateButton];
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (IBAction)BirthdatePressed:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[[Profile sharedProfile] birthdate]];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}


- (IBAction)GenderPressed:(id)sender
{
  
    [[Profile sharedProfile] setIsFemale:![[Profile sharedProfile] isFemale]];
    [self updateGenderButton];
}

-(void) updateGenderButton
{
    
    if ([[Profile sharedProfile] isFemale])
    {
        [genderButton setTitle:@"Female" forState:UIControlStateNormal];
    }
    else
        [genderButton setTitle:@"Male" forState:UIControlStateNormal];

}

-(void)CreateAccountCallback:(NetworkResponse *)nr data:(id)callbackData
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
        if (nr.ResponseCode==412)
        {
            [Popup ShowPopup:@"Profile Creation Error" message:@"That email address is already in use.  Please use another email address." popupType:OK  delegate:nil];
        }
        else
        {
             [Popup ShowPopup:@"Profile Creation Error" message:@"There was an error on the server." popupType:OK  delegate:nil];
            
        }
        NSLog (@"Couldn't create account!");
    }

}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(BOOL)ValidateProfileInput
{
    Profile *p=[Profile sharedProfile];
    NSMutableString *errors=[[NSMutableString alloc] init];
    
    if ([allTrim(p.userName) length]<3)
    {
        [errors appendString:@"* Username must be at least 3 characters.\n"];
    
    }
    if (![self NSStringIsValidEmail:p.emailAddress])
    {
        [errors appendString:@"* Email address is not valid.\n"];
    }
    if ([allTrim([password text]) length]<6)
    {
        [errors appendString:@"* Password must be at least 6 characters.\n"];
        
    }
    if (![[password text] isEqualToString:[confirmPassword text]])
    {
        [errors appendString:@"* Passwords do not match.\n"];
    }
    
    if ([errors length]!=0)
    {
        [Popup ShowPopup:@"Profile Creation Error" message:errors popupType:OK delegate:nil];
        return NO;
    }
    
    return YES;
}

- (IBAction)CreateAccountPressed:(id)sender
{
    // Try to create account!
    Profile *p=[Profile sharedProfile];
    p.userName=[username text];
    p.emailAddress=[emailAddress text];
    
    if ([self ValidateProfileInput])
    {
        [Popup ShowActivityIndicatorOnView:[self view]];
        [Networking CreateProfile:p password:[password text] callback:@selector(CreateAccountCallback:data:) fromObject:self];
    }
    
}
@end
