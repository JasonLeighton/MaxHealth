//
//  LobbyViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/5/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "LobbyViewController.h"
#import "LoginViewController.h"
#import "ChooseWorkoutViewController.h"
#import "AnswerDayViewController.h"
#import "AnswerDayTableViewController.h"
#import "Profile.h"
#import "Popup.h"
#import "Networking.h"
#import "ShowStatsViewController.h"
#import "GradientButton.h"

@interface LobbyViewController ()

@end

@implementation LobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setTitle:[[Profile sharedProfile] userName]];
    self.view.backgroundColor=[UIColor clearColor];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)StartWorkoutPressed:(id)sender
{
    [[Profile sharedProfile] setTodaysChecksum:[[[Profile sharedProfile] todaysHealthRecord] GetChecksum]];
    AnswerDayViewController *vc=[[AnswerDayViewController alloc] initWithHealthRecord:[[Profile sharedProfile] todaysHealthRecord]];
    //AnswerDayTableViewController *vc=[[AnswerDayTableViewController alloc] initWithHealthRecord:[[Profile sharedProfile] todaysHealthRecord]];
    
    UINavigationController *navController=[self navigationController];
    [navController pushViewController:vc animated:YES];
}

- (IBAction)WorkoutHistoryPressed:(id)sender {
}

- (IBAction)StatsPressed:(id)sender
{
    ShowStatsViewController *vc=[[ShowStatsViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController=[self navigationController];
    [navController pushViewController:vc animated:YES];

}

-(void)CreateFakeRecords:(int)numRecords
{
    for (int i=numRecords-1;i>=0;i--)
    {
        HealthRecord *hr=[[HealthRecord alloc] init];
        [hr PopulateWithTempData];
        [hr createRandomDataForRecord];
        hr.recordDate=[hr.recordDate dateByAddingTimeInterval:(-3600*24)*i];
        
        [Networking SaveRecord:hr callback:nil fromObject:nil];
    }
}

- (IBAction)OptionsPressed:(id)sender {
    [self CreateFakeRecords:20];
}

- (IBAction)LogoutPressed:(id)sender
{
    [Popup ShowPopup:@"Confirm" message:@"Do you really wish to log out?" popupType:YESNO delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=[alertView cancelButtonIndex])
    {
        [Networking Logout];
        LoginViewController *vc=[[LoginViewController alloc] init];
        UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:vc];
        UIWindow   *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        
        [UIView transitionWithView:mainWindow duration:0.5 options: UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            mainWindow.rootViewController = navController;
        } completion:nil];
    }
    
}

// Given a category, creates a button for it!
-(UIButton *)CreateButton:(NSString *)title withIndex:(int)index
{
    GradientButton *button = [[GradientButton alloc] initWithFrame:CGRectMake(40, 90+(index*55), 240, 44)];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:.3 blue:1.0 alpha:1]];
    
    [button setTitle:title forState:UIControlStateNormal];
    //NSLog (@"Creating button for index %d",index);
    // add targets and actions
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:button];
    return button;
}

// User has clicked on a category button
-(void)buttonClicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    NSString *title=[button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"Answer Questions"])
        [self StartWorkoutPressed:sender];
    else if ([title isEqualToString:@"View Stats"])
        [self StatsPressed:sender];
    else if ([title isEqualToString:@"Logout"])
        [self LogoutPressed:sender];
}


@end
