//
//  Profile.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/5/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"
#import "HealthRecord.h"

// Trims whitespace on both sides of string
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@interface Profile : NSObject
{
    
}

CWL_DECLARE_SINGLETON_FOR_CLASS(Profile)
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *emailAddress;
@property (nonatomic) int height; // number of inches
@property (nonatomic) int weight; // in lbs
@property (nonatomic) BOOL isFemale;
@property (nonatomic) int UserID; // For networking
@property (nonatomic) NSDate *birthdate;
@property (nonatomic) NSMutableArray *healthRecords;
@property (nonatomic) HealthRecord *todaysHealthRecord;
@property (nonatomic) int todaysChecksum;


-(void) SetProfileDefaults;

@end
