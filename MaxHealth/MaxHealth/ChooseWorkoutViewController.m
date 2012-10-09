//
//  ChooseWorkoutViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/5/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "ChooseWorkoutViewController.h"
#import "WorkoutMapViewController.h"

@interface ChooseWorkoutViewController ()

@end

@implementation ChooseWorkoutViewController

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
    [[self navigationItem] setTitle:@"Choose Workout"];
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

void StartWorkout(int workoutType)
{
    WorkoutMapViewController *vc=[[WorkoutMapViewController alloc] init];
    UIWindow   *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    // Transition to new controller
    [UIView transitionWithView:mainWindow duration:0.5 options: UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        mainWindow.rootViewController = vc;
    } completion:nil];
}

- (IBAction)WalkingPressed:(id)sender
{
    StartWorkout(0);
}

- (IBAction)CyclingPressed:(id)sender {
    StartWorkout(1);
}

- (IBAction)HikingPressed:(id)sender {
    StartWorkout(2);
}

- (IBAction)TennisPressed:(id)sender {
    StartWorkout(3);
}

- (IBAction)GolfPressed:(id)sender {
    StartWorkout(4);
}

- (IBAction)KayakingPressed:(id)sender {
    StartWorkout(5);
}

- (IBAction)RunningPressed:(id)sender {
    StartWorkout(6);
}
@end
