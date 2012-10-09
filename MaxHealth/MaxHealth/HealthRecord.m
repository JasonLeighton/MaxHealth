//
//  HealthRecord.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "HealthRecord.h"
#import "LetronicUtils.h"

@implementation HealthRecord

// Add a category to our list
-(void)AddCategory:(StatCategory *)category
{
    [self.allCategories addObject:category];
}


// Clears all the categories in our global list
-(void)ClearAllCategories
{
    [self.allCategories removeAllObjects];
}

// Given a search string, returns a category matching that string, else nil if non is found
-(StatCategory *)FindCategory:(NSString *)str
{
    for (StatCategory *cat in self.allCategories)
    {
        if ([cat.categoryName isEqualToString:str])
            return cat;
    }
    return nil;
}

// Gets a unique checksum for this record
-(int)GetChecksum
{
    int checksum=0;
    for (StatCategory *cat in self.allCategories)
    {
        checksum+=[cat GetChecksum];
    }
    return checksum;
}


// Temp function to populate our question database
-(void)PopulateWithTempData
{
    StatCategory *cat;
    TrackedStat *stat;
    
    [self.allCategories removeAllObjects];
    
    // Mood
    cat=[StatCategory InitWithName:@"Overall Mood"];
    stat=[TrackedStat InitWithName:@"Mood" andType:TSE_INTVALUE andQuestion:@"On a scale of 1 to 5 (1 being bad), rate your overall mood for this day:"];
    stat.intMin=1; stat.intMax=5;
    [cat addTrackedStat:stat];
    [self AddCategory:cat];
    
    // Exercise
    cat=[StatCategory InitWithName:@"Exercise"];
    [self AddCategory:cat];
    stat=[TrackedStat InitWithName:@"Exercise" andType:TSE_MULTIPLE_CHOICE andQuestion:@"What kind of exercise did you do this day?"];
    stat.choices=[[NSMutableArray alloc] initWithObjects:@"Didn't exercise",@"Running",@"Walking",@"Hiking",@"Cycling",@"General Cardio",@"Weightlifting", nil];
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Exercise Minutes" andType:TSE_INTVALUE andQuestion:@"How many minutes did you exercise?"];
    stat.intMin=0; stat.intMax=120;
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Exercise Intensity" andType:TSE_INTVALUE andQuestion:@"On a scale of 1 to 5 (1 being low), rate the intensity of your exercise:"];
    stat.intMin=1; stat.intMax=5;
    [cat addTrackedStat:stat];
    
    // Weather
    cat=[StatCategory InitWithName:@"Weather"];
    [self AddCategory:cat];
    stat=[TrackedStat InitWithName:@"Weather Type" andType:TSE_MULTIPLE_CHOICE andQuestion:@"What was the predominant weather for this day?"];
    stat.choices=[[NSMutableArray alloc] initWithObjects:@"Rainy",@"Cloudy",@"Partly Cloudy/Partly Sunny",@"Sunny", nil];
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Temperature" andType:TSE_MULTIPLE_CHOICE andQuestion:@"How did you feel about the temperature for this day?"];
    stat.choices=[[NSMutableArray alloc] initWithObjects:@"Too hot!",@"Too cold!",@"Just right", nil];
    [cat addTrackedStat:stat];
    
    // Sleep
    cat=[StatCategory InitWithName:@"Sleep"];
    [self AddCategory:cat];
    stat=[TrackedStat InitWithName:@"Restfulness" andType:TSE_MULTIPLE_CHOICE andQuestion:@"How rested do you feel for this day?"];
    stat.choices=[[NSMutableArray alloc] initWithObjects:@"Not rested at all",@"Somewhat rested",@"Very rested", nil];
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Bedtime last night" andType:TSE_TIME andQuestion:@"What time did you go to bed last night?"];
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Awake today" andType:TSE_TIME andQuestion:@"What time did you get up today?"];
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Estimated bedtime tonight" andType:TSE_TIME andQuestion:@"What time do you estimate going to bed tonight?"];
    [cat addTrackedStat:stat];
    
    // Vices
    cat=[StatCategory InitWithName:@"Vices"];
    [self AddCategory:cat];
    
    stat=[TrackedStat InitWithName:@"Number of drinks" andType:TSE_INTVALUE andQuestion:@"How many alcoholic drinks did you have this day?"];
    stat.intMin=0; stat.intMax=20;
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Number of cigarettes" andType:TSE_INTVALUE andQuestion:@"How many cigarettes did you have this day?"];
    stat.intMin=0; stat.intMax=80;
    [cat addTrackedStat:stat];
    
    // Productivity
    cat=[StatCategory InitWithName:@"Productivity & Learning"];
    [self AddCategory:cat];
    
    stat=[TrackedStat InitWithName:@"Productive scale" andType:TSE_INTVALUE andQuestion:@"On a scale of 1 to 5 (1 being low), rate your productivity for this day:"];
    stat.intMin=1; stat.intMax=5;
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Learning scale" andType:TSE_INTVALUE andQuestion:@"On a scale of 1 to 5 (1 being low), rate the amount of learning you did on this day:"];
    stat.intMin=1; stat.intMax=5;
    [cat addTrackedStat:stat];
    
    stat=[TrackedStat InitWithName:@"Creativity scale" andType:TSE_INTVALUE andQuestion:@"On a scale of 1 to 5 (1 being low), rate your creativity for this day:"];
    stat.intMin=1; stat.intMax=5;
    [cat addTrackedStat:stat];
   
}

// Serialize to Json
- (NSDictionary*) proxyForJson
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.recordDate.description, @"RecordDate",
            [NSNumber numberWithInt:self.localTimeZoneAdjustment],@"LocalTimeZoneAdjustment",
            self.allCategories, @"Categories",
            nil];
}

// Creates random data for this record
-(void)createRandomDataForRecord
{
    
    for (StatCategory *cat in self.allCategories)
    {
        [cat createRandomDataForCategory];
        
    }
}


-(id)init
{
    self=[super init];
    if (self)
    {
        self.allCategories=[[NSMutableArray alloc] init];
        self.recordDate=[LetronicUtils UTCDateToLocalDate:[NSDate date]];
        self.localTimeZoneAdjustment=[[NSTimeZone localTimeZone] secondsFromGMT] / 3600;
    }
    return self;
}
@end
