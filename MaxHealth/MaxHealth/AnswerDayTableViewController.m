//
//  AnswerDayTableViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 10/2/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//
#import "Profile.h"
#import "AnswerDayTableViewController.h"
#import "AnswerCategoryViewController.h"

@interface AnswerDayTableViewController ()

@end

@implementation AnswerDayTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithHealthRecord:(HealthRecord *)hr
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        healthRecord=hr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor=[UIColor clearColor];
    [[self navigationItem] setTitle:@"Questions"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return healthRecord.allCategories.count*3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.row%healthRecord.allCategories.count;
    StatCategory *cat=[[healthRecord allCategories] objectAtIndex:index];
                       
    if (cat!=nil)
    {
        AnswerCategoryViewController *vc=[[AnswerCategoryViewController alloc] initWithStatCategory:cat nibName:nil bundle:nil];
        UINavigationController *navController=[self navigationController];
        [navController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Questions";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    int index=indexPath.row%healthRecord.allCategories.count;
    StatCategory *cat=[healthRecord.allCategories objectAtIndex:index];
    [cell.textLabel setText:cat.categoryName];
    
    [cell.textLabel setTextColor:cat.areAllStatsAnswered?[UIColor greenColor]:[UIColor blackColor]];
    cell.backgroundColor=[UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.backgroundView setNeedsDisplay];
    return cell;
}



@end
