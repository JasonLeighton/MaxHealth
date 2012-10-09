//
//  TrackedStat.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatCategory;

@interface TrackedStat : NSObject
{
    
}

typedef enum
{
    TSE_BOOL,
    TSE_INTVALUE,
    TSE_FlOATVALUE,
    TSE_MULTIPLE_CHOICE,
    TSE_TIME,
    TSE_DATE,
} TrackedStatEnum;

@property (nonatomic,copy) NSString *name;          // Display name of this stat
@property (nonatomic,copy) NSString *question;      // Question associated with this stat ("are you happy today?")
@property (nonatomic) TrackedStatEnum statType;
@property (nonatomic) int intValue;
@property (nonatomic) int floatValue;
@property (nonatomic) float floatMin;
@property (nonatomic) float floatMax;
@property (nonatomic) int intMin;
@property (nonatomic) int intMax;
@property (nonatomic) BOOL boolValue;
@property (nonatomic) int multipleChoiceValue;
@property (nonatomic) NSDate *dateValue;
@property (nonatomic) NSMutableArray *choices;
@property (nonatomic) BOOL answeredStat;
@property (nonatomic) StatCategory *parentCategory;

+(id) InitWithName:(NSString *)newname andType:(TrackedStatEnum)tse andQuestion:(NSString *)q;
-(id) initWithName:(NSString *)newname andType:(TrackedStatEnum)tse andQuestion:(NSString *)q;
-(int) GetChecksum;
-(BOOL) isEmbedded;
//-(BOOL)automateDataForStat;
-(void)createRandomDataForStat;
- (NSDictionary*) proxyForJson;



@end
