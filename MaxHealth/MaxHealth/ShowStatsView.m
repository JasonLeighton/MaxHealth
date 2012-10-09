//
//  ShowStatsView.m
//  MaxHealth
//
//  Created by Jason Leighton on 10/2/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "ShowStatsViewController.h"
#import "ShowStatsView.h"
#import "profile.h"

@implementation ShowStatsView

@synthesize values,startIndex,barWidth,numRecordsToShow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        statLabels=[[NSMutableArray alloc] init];
        trackedStats=[[NSMutableArray alloc] init];
        trackedCategories=[[NSMutableArray alloc] init];
        for (int i=0;i<3;i++)
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10,20+(i*25), 200, 30)];
            if (i==0)
                label.textColor=[UIColor greenColor];
            else if (i==1)
                label.textColor=[UIColor colorWithRed:0 green:.5 blue:1 alpha:1];
            else if (i==2)
                label.textColor=[UIColor yellowColor];
           
            label.shadowColor=[UIColor blackColor];
            label.shadowOffset=CGSizeMake(1,1);
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:14];
            [statLabels addObject:label];
            [self addSubview:label];
        }

    }
    return self;
}
-(void) setCategoriesAndStats:(NSString *)cat1 stat1:(NSString *)stat1 cat2:(NSString *)cat2 stat2:(NSString *)stat2 cat3:(NSString *)cat3 stat3:(NSString *)stat3
{
    [trackedStats removeAllObjects];
    [trackedCategories removeAllObjects];
    [trackedCategories addObject:cat1];
    [trackedCategories addObject:cat2];
    [trackedCategories addObject:cat3];
    [trackedStats addObject:stat1];
    [trackedStats addObject:stat2];
    [trackedStats addObject:stat3];
    
    UILabel *label;
    label=[statLabels objectAtIndex:0];
    label.text=stat1;
    label=[statLabels objectAtIndex:1];
    label.text=stat2;
    label=[statLabels objectAtIndex:2];
    label.text=stat3;
}
-(void) drawStatIndex:(int)statIndex
{
    UILabel *label=[statLabels objectAtIndex:statIndex];
    CGColorRef color=label.textColor.CGColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawingRect=CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
    float maxHeightOfLines=drawingRect.size.height*.75f;
    
    Profile *p=[Profile sharedProfile];
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 3.0f);

    int endIndex=self.startIndex+self.numRecordsToShow+1;
    if (endIndex>=p.healthRecords.count)
        endIndex=p.healthRecords.count;
    int count=(endIndex-self.startIndex);
    for (int k = 0; k < count; k++)
    {
        HealthRecord *hr=[p.healthRecords objectAtIndex:self.startIndex+k];
        StatCategory *cat=[hr FindCategory:[trackedCategories objectAtIndex:statIndex]];
        TrackedStat *ts=[cat FindStat:[trackedStats objectAtIndex:statIndex]];
        float normValue=0;
        
        if (ts.statType==TSE_INTVALUE)
            normValue=(float)ts.intValue/(float)ts.intMax;
        else if (ts.statType==TSE_MULTIPLE_CHOICE)
            normValue=(float)ts.multipleChoiceValue/(float)ts.choices.count;
        
        CGFloat x = drawingRect.origin.x+(k * self.barWidth);
        CGFloat y = drawingRect.size.height - (normValue * maxHeightOfLines);
        
        if (k==0)
            CGContextMoveToPoint (context, x, y);
        else
            CGContextAddLineToPoint (context, x,y);
    }
    CGContextStrokePath(context);
    //CGContextFillPath(context);

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:.25f green:.25f blue:.25f alpha:.5f].CGColor);
    CGRect drawingRect=CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
    CGContextAddRect(context, drawingRect);
    CGContextFillPath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:.25f].CGColor);
    CGContextSetLineWidth(context, 1.0f);

    for (int i=0;i<self.numRecordsToShow;i++)
    {
        CGFloat x = i*self.barWidth;
        CGContextMoveToPoint (context, x, 0);
        CGContextAddLineToPoint (context, x,self.bounds.size.height);
        CGContextStrokePath(context);
    }
    for (int i=0;i<3;i++)
    {
        StatCategory *cat=[trackedCategories objectAtIndex:i];
        if (cat!=nil)
            [self drawStatIndex:i];
    }
    
    return;
}

@end
