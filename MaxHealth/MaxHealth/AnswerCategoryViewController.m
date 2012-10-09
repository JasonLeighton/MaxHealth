//
//  AnswerCategoryViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/26/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "AnswerCategoryViewController.h"
#import "StatCategory.h"
#import "GradientButton.h"
#import "LetronicUtils.h"

@interface AnswerCategoryViewController ()

@end

@implementation AnswerCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UICreated=false;
    }
    return self;
}


- (id)initWithStatCategory:(StatCategory*)category nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self setStatCategory:category];
    }
    return self;
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
    [[self navigationItem] setTitle:self.statCategory.categoryName];
    self.view.backgroundColor=[UIColor clearColor];
    //self.scrollView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize=self.contentView.bounds.size;
//  self.scrollView.showsVerticalScrollIndicator = NO;

    if (!UICreated)
    {
        [self createUI];
    }
    
    self.scrollView.contentSize=CGSizeMake(self.scrollView.contentSize.width,(float)[self GetHeightOfContent]);
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[pickerStat choices] count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title=[[pickerStat choices] objectAtIndex:row];
    //NSLog (@"Grabbing title %@ for row %d",title,row);
    return title;
    
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerStat.multipleChoiceValue=row;
    if (pickerStat.statType==TSE_INTVALUE)
    {
        pickerStat.intValue=pickerStat.intMin+row;
    }
    else if (pickerStat.statType==TSE_MULTIPLE_CHOICE)
    {
    
    }
}

- (void)changeTime:(UIDatePicker *)sender
{
    pickerStat.dateValue=sender.date;
}

-(void)updateButton:(UIButton *)button basedOnStat:(TrackedStat *)ts
{
    // Color button
    [button setBackgroundColor:ts.answeredStat?[UIColor greenColor]:[UIColor yellowColor]];
    [button setTitleColor:ts.answeredStat?[UIColor blackColor]:[UIColor blackColor] forState:UIControlStateNormal];
    
    // Set text of button
    if (ts.statType==TSE_MULTIPLE_CHOICE)
    {
        [button setTitle:[ts.choices objectAtIndex:ts.multipleChoiceValue] forState:UIControlStateNormal];
    }
    else if (ts.statType==TSE_INTVALUE)
    {
        [button setTitle:[NSString stringWithFormat:@"%d",ts.intValue] forState:UIControlStateNormal];
    }
    else if (ts.statType==TSE_TIME)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [button setTitle:[dateFormatter stringFromDate:ts.dateValue] forState:UIControlStateNormal];
    }
    
    if (ts.answeredStat==false)
    {
        [button setTitle:@"Haven't answered" forState:UIControlStateNormal];
    }
}


- (void)removeViews:(id)object {
    [[self.view viewWithTag:909] removeFromSuperview];
    [[self.view viewWithTag:910] removeFromSuperview];
    [[self.view viewWithTag:911] removeFromSuperview];
}

// Gets rid of picker
- (void)dismissPicker:(id)sender
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:909].alpha = 0;
    [self.view viewWithTag:910].frame = datePickerTargetFrame;
    [self.view viewWithTag:911].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    
}

- (void)dismissPickerWithAnswer:(id)sender
{
    [self dismissPicker:sender];
    pickerStat.answeredStat=true;
    
    [self updateButton:selectedButton basedOnStat:pickerStat];
    
}


// Slides a picker view up for selecting answers to stat questions
-(void)createPickerForStat:(TrackedStat *)ts
{
    //NSLog (@"Creating picker for stat:%@",ts.name);
    pickerStat=ts;
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect pickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 909;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    if (ts.statType==TSE_TIME)
    {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        [datePicker setDate:ts.dateValue];
        datePicker.tag = 910;
        [datePicker addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
        //datePicker.frame = pickerTargetFrame;
        [self.view addSubview:datePicker];
        
    }
    else
    {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
        picker.tag = 910;
        picker.delegate=self;
        picker.showsSelectionIndicator=YES;
        [picker selectRow:ts.intValue-ts.intMin inComponent:0 animated:YES];
        //picker.frame = pickerTargetFrame;
        [self.view addSubview:picker];
    }
        
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 911;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPickerWithAnswer:)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5,0, 200, 44)];
    label.text=ts.name;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    UIBarButtonItem *labelButton = [[UIBarButtonItem alloc] initWithCustomView:label];

    [toolBar setItems:[NSArray arrayWithObjects:labelButton,spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    [[self.view viewWithTag:910] setFrame:pickerTargetFrame];
    
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

-(void)statClicked:(id)sender
{
    UIView *tempView=(UIView *)sender;
    selectedButton=(UIButton *)sender;

    TrackedStat *ts=[self.statCategory.trackedStats objectAtIndex:tempView.tag];

    [self createPickerForStat:ts];
       
}


// Creates all the UI associated with this category
-(void) createUI
{
    UICreated=true;
    
    // Create date formatter to help with time types
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    int curY=10;
    int statIndex=0;
    for (TrackedStat *ts in self.statCategory.trackedStats)
    {
        // Create question label
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20,curY, 280, 70)];
        if (ts.question==nil)
            label.text=@"No question text yet!";
        else
            label.text=ts.question;
        label.textColor=[UIColor whiteColor];
        label.numberOfLines=3;
        label.backgroundColor=[UIColor clearColor];

        [label setShadowColor:[UIColor darkGrayColor]];
        [label setShadowOffset:CGSizeMake(1,1)];
        
        label.numberOfLines = 0;
        [label sizeToFit];
        //UIImage *img=[UIImage imageNamed:@"TextBackground.png"];
        //UIImage *scaledImage=[img scaleToSize:label.frame.size];
        //label.backgroundColor=[UIColor colorWithPatternImage:scaledImage];

        
        [self.contentView addSubview:label];
        curY+=label.frame.size.height+10;
        GradientButton *button;
        
        if (ts.statType==TSE_INTVALUE)
        {
            // Create choices
            ts.choices=[[NSMutableArray alloc] init];
            for (int i=ts.intMin;i<=ts.intMax;i++)
            {
                [ts.choices addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            // Create button
            button = [[GradientButton alloc] initWithFrame:CGRectMake(20, curY, 280, 44)];
            //[button setBackgroundColor:ts.answeredStat?[UIColor greenColor]:[UIColor yellowColor]];
            //[button setTitleColor:ts.answeredStat?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];

            // Set default value
            [button setTitle:[ts.choices objectAtIndex:0] forState:UIControlStateNormal];
            // add targets and actions
            [button addTarget:self action:@selector(statClicked:) forControlEvents:UIControlEventTouchUpInside];
            // add to a view
            button.tag=statIndex;
            [self.contentView addSubview:button];
        }
        else if (ts.statType==TSE_MULTIPLE_CHOICE)
        {
            // Create button
            button = [[GradientButton alloc] initWithFrame:CGRectMake(20, curY, 280, 44)];
            //[button setBackgroundColor:ts.answeredStat?[UIColor greenColor]:[UIColor yellowColor]];

            // Set default value
            [button setTitle:[ts.choices objectAtIndex:0] forState:UIControlStateNormal];
            // add targets and actions
            [button addTarget:self action:@selector(statClicked:) forControlEvents:UIControlEventTouchUpInside];
            // add to a view
            button.tag=statIndex;
            [self.contentView addSubview:button];
            
        }
        else if (ts.statType==TSE_TIME)
        {
            // Create button
            button = [[GradientButton alloc] initWithFrame:CGRectMake(20, curY, 280, 44)];
            //[button setBackgroundColor:ts.answeredStat?[UIColor greenColor]:[UIColor yellowColor]];

            // Set default value
            [button setTitle:[dateFormatter stringFromDate:ts.dateValue] forState:UIControlStateNormal];
            // add targets and actions
            [button addTarget:self action:@selector(statClicked:) forControlEvents:UIControlEventTouchUpInside];
            // add to a view
            button.tag=statIndex;
            [self.contentView addSubview:button];

        }
        if (button!=nil)
            [self updateButton:button basedOnStat:ts];
        
        statIndex++;
        curY+=60;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
