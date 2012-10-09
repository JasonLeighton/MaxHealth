//
//  ShowStatsViewController.m
//  MaxHealth
//
//  Created by Jason Leighton on 10/1/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "ShowStatsViewController.h"
#import "Profile.h"
#import "ShowStatsView.h"
#import "LetronicUtils.h"
#import "Popup.h"
@interface ShowStatsViewController ()

@end


@implementation StatCompare
@synthesize stat1Name,stat2Name,cat1Name,cat2Name,pearsonCoefficient;
@end

@implementation ShowStatsViewController

@synthesize graphRect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        shortDateFormatter.dateStyle=NSDateFormatterShortStyle;
               
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Stats"];

    // Make our graph area
    self.barWidth=60;
    self.numRecordsToShow=5;
    int widthOfGraph=(self.numRecordsToShow*self.barWidth);
    self.graphRect=CGRectMake(self.view.bounds.size.width-widthOfGraph,0,widthOfGraph,self.view.bounds.size.height-100);
    statsView=[[ShowStatsView alloc] initWithFrame:self.graphRect];
    statsView.numRecordsToShow=self.numRecordsToShow;
    statsView.barWidth=self.barWidth;
    
    // Tell it what categories to display
    [statsView setCategoriesAndStats:@"Overall Mood" stat1:@"Mood" cat2:@"Sleep" stat2:@"Restfulness" cat3:@"Weather" stat3:@"Weather Type"];
    
    [self.view addSubview:statsView];
    self.view.backgroundColor=[UIColor clearColor];
    
    // Create Date labels
    dateLabels=[[NSMutableArray alloc] init];
    for (int i=0;i<self.numRecordsToShow;i++)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(00+(i*self.barWidth),305, 70, 44)];
        label.textColor=[UIColor whiteColor];
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:12];
        label.shadowColor=[UIColor blackColor];
        label.shadowOffset=CGSizeMake(1,1);

        //label.transform= CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
        [dateLabels addObject:label];
        //label.text=@"Testing";
        [self.view addSubview:label];
    }
    [self updateLabels];
}

- (void)viewDidUnload
{
    leftArrowButton = nil;
    rightArrowButton = nil;
    statsView=nil;
    [dateLabels removeAllObjects];
    dateLabels=nil;
    [super viewDidUnload];
}

// Draw date labels
-(void)updateLabels
{
    Profile *p=[Profile sharedProfile];

    int endIndex=statsView.startIndex+self.numRecordsToShow;
    if (endIndex>=p.healthRecords.count)
        endIndex=p.healthRecords.count;
    int count=(endIndex-statsView.startIndex);
    
    for (int i=0;i<count;i++)
    {
        HealthRecord *hr=[p.healthRecords objectAtIndex:statsView.startIndex+i];
        UILabel *label=[dateLabels objectAtIndex:i];
        label.text=[shortDateFormatter stringFromDate:hr.recordDate];
    }

}

// User pressed left arrow - scroll to the right
- (IBAction)leftArrowPressed:(id)sender
{
    if (statsView.startIndex>1)
    {
        statsView.startIndex--;
        [statsView setNeedsDisplay];
        [self updateLabels];
        NSLog (@"Decrementing startIndex to %d",statsView.startIndex);
    }
}

// User pressed right arrow - scroll to the left
- (IBAction)rightArrowPressed:(id)sender
{
    Profile *p=[Profile sharedProfile];
    int numShown=(p.healthRecords.count-self.numRecordsToShow);
    if (statsView.startIndex<numShown)
    {
        statsView.startIndex++;
        [statsView setNeedsDisplay];
        [self updateLabels];
        NSLog (@"Incrementing startIndex to %d",statsView.startIndex);

    }
    
}

// Given 2 category names an 2 stat names, goes through all of our health records and finds correlations between them
-(float)getPearsonCoefficient:(NSString *)cat1Name stat1Name:(NSString *)stat1Name cat2Name:(NSString *)cat2Name stat2Name:(NSString *)stat2Name
{
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    NSMutableArray *array2=[[NSMutableArray alloc] init];
    Profile *p=[Profile sharedProfile];
    
    for (int i=0;i<p.healthRecords.count;i++)
    {
        HealthRecord *hr=[p.healthRecords objectAtIndex:i];
        
        // Do stat1
        StatCategory *sc=[hr FindCategory:cat1Name];
        TrackedStat *ts=[sc FindStat:stat1Name];
        float normValue;
        
        if (ts.answeredStat==false)
            return 0;
        
        if (ts.statType==TSE_INTVALUE)
        {
            normValue=(float)ts.intValue/(float)ts.intMax;
        }
        else if (ts.statType==TSE_MULTIPLE_CHOICE)
        {
            normValue=(float)ts.multipleChoiceValue/(float)(ts.choices.count-1);
        }
        else
            return 0; // Don't do other types aside from int and multiple choice yet
        
        [array1 addObject:[NSNumber numberWithFloat:normValue]];
        
        // Do stat2
        sc=[hr FindCategory:cat2Name];
        ts=[sc FindStat:stat2Name];
        
        if (ts.answeredStat==false)
            return 0;

        if (ts.statType==TSE_INTVALUE)
        {
            normValue=(float)ts.intValue/(float)ts.intMax;
        }
        else if (ts.statType==TSE_MULTIPLE_CHOICE)
        {
            normValue=(float)ts.multipleChoiceValue/(float)(ts.choices.count-1);
        }
        else
            return 0; // Don't do other types aside from int and multiple choice yet
        
        [array2 addObject:[NSNumber numberWithFloat:normValue]];
    }
    
    // Now that we have all our normalized values in arrays, find the Pearson coefficient
    float sum1=0,sum2=0,sum1sq=0,sum2sq=0,sumProducts=0;
    for (int i=0;i<array1.count;i++)
    {
        float val=[[array1 objectAtIndex:i] doubleValue];
        sum1+=val;
        sum1sq+=(val*val);
    }
    for (int i=0;i<array2.count;i++)
    {
        float val=[[array2 objectAtIndex:i] doubleValue];
        sum2+=val;
        sum2sq+=(val*val);
    }
    for (int i=0;i<array1.count;i++)
        sumProducts+=[[array2 objectAtIndex:i] doubleValue]*[[array2 objectAtIndex:i] doubleValue];
    
    float numerator=sumProducts-(sum1*sum2/array1.count);
    float denominator=sqrt((sum1sq - (sum1*sum1)/array1.count) * (sum2sq - (sum2*sum2)/array2.count));
    if (denominator==0)
        return 0;

    return numerator/denominator;
    
}

// Goes through all categories and stats and tries to find the top 3 correlations/negative correlations
- (IBAction)findCorrelationPressed:(id)sender
{
    Profile *p=[Profile sharedProfile];
    HealthRecord *hr=p.todaysHealthRecord;
    NSMutableArray *listOfStatsCompared=[[NSMutableArray alloc] init];
    
    for (int c1=0;c1<hr.allCategories.count;c1++)
    {
        StatCategory *cat1=[hr.allCategories objectAtIndex:c1];
        for (int s1=0;s1<cat1.trackedStats.count;s1++)
        {
            TrackedStat *stat1=[cat1.trackedStats objectAtIndex:s1];
            
            for (int c2=c1;c2<hr.allCategories.count;c2++)
            {
                if (c1==c2)
                    continue;
                
                StatCategory *cat2=[hr.allCategories objectAtIndex:c2];
                for (int s2=s1;s2<cat2.trackedStats.count;s2++)
                {
                    TrackedStat *stat2=[cat2.trackedStats objectAtIndex:s2];
                    
                    if (c1==c2 && s1==s2)
                        continue;
                    
                    float pearsonCoefficient=[self getPearsonCoefficient:cat1.categoryName stat1Name:stat1.name cat2Name:cat2.categoryName stat2Name:stat2.name];
                    
                    if (pearsonCoefficient==0)
                        continue;
                    
                    // Now that we have a valid coefficient, place it in our list for later sorting
                    StatCompare *statsCompared=[[StatCompare alloc] init];
                    statsCompared.cat1Name=cat1.categoryName;
                    statsCompared.cat2Name=cat2.categoryName;
                    statsCompared.stat1Name=stat1.name;
                    statsCompared.stat2Name=stat2.name;
                    statsCompared.pearsonCoefficient=pearsonCoefficient;
                    
                    [listOfStatsCompared addObject:statsCompared];
                }
            }
        }
    }
    
    // Sort our Pearson values
    NSArray *correlations=[listOfStatsCompared sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2)
    {
        float p1=[obj1 pearsonCoefficient];
        float p2=[obj2 pearsonCoefficient];
    
        if (abs(p1)>abs(p2))
            return (NSComparisonResult)NSOrderedAscending;
        else if (abs(p1)<abs(p2))
            return (NSComparisonResult)NSOrderedDescending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // Display up to three correlations
    if (correlations.count>=3)
    {
        NSMutableString *message=[[NSMutableString alloc] init];
        for (int i=0;i<3;i++)
        {
            [message appendFormat:@"\n* Correlation between %@ and %@ (%f)\n",[[correlations objectAtIndex:i] stat1Name],[[correlations objectAtIndex:i] stat2Name],[[correlations objectAtIndex:i] pearsonCoefficient]];
        }
        [Popup ShowPopup:@"Correlations" message:message popupType:OK delegate:nil];

    }
    else
    {
        [Popup ShowPopup:@"Error" message:@"Not enough data for correlations." popupType:OK delegate:nil];
    }
       
}
@end
