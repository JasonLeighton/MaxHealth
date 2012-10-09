//
//  AnswerDayViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "AnswerDayViewController.h"
#import "HealthRecord.h"
#import "AnswerCategoryViewController.h"
#import "GradientButton.h"
#import "LetronicUtils.h"
#import "Profile.h"
#import "Networking.h"

@interface AnswerDayViewController ()


@end

@implementation AnswerDayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
     
    }
    return self;
}
-(id) initWithHealthRecord:(HealthRecord *)hr
{
    self = [self init];
    if (self)
    {
        healthRecord=hr;
        isToday=YES;
    }
    return self;
}
/*-(id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}*/

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


-(int)GetHeightOfContent
{
    int scrollViewHeight=0;//self.scrollView.bounds.size.height;
    for (UIView* view in self.scrollView.allSubViews)
    {
        if (!view.hidden && view!=self.contentView)
        {
            CGFloat y = view.frame.origin.y;
            CGFloat h = view.frame.size.height;
            if (y + h > scrollViewHeight)
            {
                scrollViewHeight = h + y;
            }
        }
    }
    
    NSLog (@"Height is %d",scrollViewHeight);
    return scrollViewHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize=self.contentView.bounds.size;
    //self.scrollView.showsVerticalScrollIndicator = NO;
    [[self navigationItem] setTitle:@"Questions"];
    self.view.backgroundColor=[UIColor clearColor];
    //self.scrollView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    // Create buttons
    int index=0;
    for (StatCategory *cat in [healthRecord allCategories])
    {
        [self CreateButtonForCategory:cat withIndex:index];
        index++;
    }
    self.scrollView.contentSize=CGSizeMake(self.scrollView.contentSize.width,(float)[self GetHeightOfContent]);
}

-(void)colorButton:(UIButton *)button
{
    StatCategory *cat=[[healthRecord allCategories] objectAtIndex:button.tag-200];
    [button setBackgroundColor:[cat areAllStatsAnswered]?[UIColor greenColor]:[UIColor yellowColor]];
    [button setTitleColor:[cat areAllStatsAnswered]?[UIColor blackColor]:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.view setNeedsDisplay];
    //NSLog (@"Coloring button for stat %@ with value of %@",ts.name,ts.answeredStat?@"True":@"False");
}

-(void)viewWillAppear:(BOOL)animated
{
    for (UIView *v in self.contentView.subviews)
    {
        if (v.tag>=200)
        {
            UIButton *b=(UIButton *)v;
            [self colorButton:b];
     
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([[Profile sharedProfile] todaysChecksum]!=[healthRecord GetChecksum])
    {
        // Data changed, so save it!
        [Networking SaveRecord:healthRecord callback:nil fromObject:nil];
    }
}

// Given a category, creates a button for it!
-(UIButton *)CreateButtonForCategory:(StatCategory *)cat withIndex:(int)index
{
    GradientButton *button = [[GradientButton alloc] initWithFrame:CGRectMake(40, 90+(index*55), 240, 44)];
    [button setBackgroundColor:[cat areAllStatsAnswered]?[UIColor greenColor]:[UIColor yellowColor]];

    [button setTitle:cat.categoryName forState:UIControlStateNormal];
    NSLog (@"Creating button for index %d",index);
    // add targets and actions
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.contentView addSubview:button];
    button.tag=200+index;
    return button;
}

// User has clicked on a category button
-(void)buttonClicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    StatCategory *cat=[healthRecord FindCategory:[button titleForState:UIControlStateNormal]];
    if (cat!=nil)
    {
        AnswerCategoryViewController *vc=[[AnswerCategoryViewController alloc] initWithStatCategory:cat nibName:nil bundle:nil];
        UINavigationController *navController=[self navigationController];
        [navController pushViewController:vc animated:YES];
    }
}

-(void)viewDidUnload
{
    self.scrollView=nil;
    self.contentView=nil;    

    DayButton = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DayButtonPressed:(id)sender {
    
    isToday=!isToday;
    if (isToday)
    {
        [DayButton setTitle:@"Today" forState:UIControlStateNormal];
    }
    else
        [DayButton setTitle:@"Yesterday" forState:UIControlStateNormal];
}
@end
