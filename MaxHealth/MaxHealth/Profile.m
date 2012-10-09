//
//  Profile.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/5/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "Profile.h"

@implementation Profile
CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(Profile);

@synthesize userName,UserID,emailAddress,height,weight,isFemale,birthdate;

-(id)init
{
    self=[super init];
    if (self)
    {
        [self SetProfileDefaults];
    }
    return self;
}
-(void) SetProfileDefaults
{
    [self setHeight:70];
    [self setWeight:140];
    [self setIsFemale:false];
    
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"MM/dd/yyyy";
    NSDate *d = [mmddccyy dateFromString:@"06/01/1980"];
    self.todaysHealthRecord=[[HealthRecord alloc] init];
    [self.todaysHealthRecord PopulateWithTempData];
    self.healthRecords=[[NSMutableArray alloc] init];
    [self.healthRecords addObject:self.todaysHealthRecord];
    
    [self setBirthdate:d];
}


@end
