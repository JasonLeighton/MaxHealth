//
//  TrackedStat.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "TrackedStat.h"
#import "StatCategory.h"
#import "LetronicUtils.h"

@implementation TrackedStat

@synthesize name,intValue,floatValue,statType,floatMin,floatMax,intMin,intMax,boolValue,multipleChoiceValue,question,dateValue,choices,answeredStat,parentCategory;

-(id) initWithName:(NSString *)newname andType:(TrackedStatEnum)tse andQuestion:(NSString *)q
{
    self=[super init];
    if (self)
    {
        self.statType=tse;
        self.question=q;
        self.name=newname;
        if (tse==TSE_TIME)
            self.dateValue=[LetronicUtils UTCDateToLocalDate:[NSDate date]];
    }
    return self;
}

// Class function that allocs/inits a new stat with a name
+(id) InitWithName:(NSString *)newname andType:(TrackedStatEnum)tse andQuestion:(NSString *)q
{
    TrackedStat *ts=[[TrackedStat alloc] initWithName:newname andType:tse andQuestion:q];
    return ts;
}
// Returns true if this stat is part of an embedded category, so we don't have to send/receive questions and choice strings
-(BOOL) isEmbedded
{
    if (parentCategory!=nil)
    {
        if ([parentCategory isEmbedded])
            return true;
    }
    return false;
}
// Serialize to Json
- (NSDictionary*) proxyForJson
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:self.name forKey:@"Name"];
    [dict setObject:[NSNumber numberWithBool:self.answeredStat] forKey:@"AnsweredStat"];
    
    if (![self isEmbedded])
    {
        [dict setObject:self.question forKey:@"Question"];
        [dict setObject:[NSNumber numberWithInt:self.statType] forKey:@"StatType"];
    }
    
    if (self.answeredStat)
    {
        if (self.statType==TSE_INTVALUE)
        {
            [dict setObject:[NSNumber numberWithInt:self.intValue] forKey:@"IntValue"];
            if (![self isEmbedded])
            {
                [dict setObject:[NSNumber numberWithInt:self.intMin] forKey:@"IntMin"];
                [dict setObject:[NSNumber numberWithInt:self.intMax] forKey:@"IntMax"];
            }
        }
        else if (self.statType==TSE_MULTIPLE_CHOICE)
        {
            [dict setObject:[NSNumber numberWithInt:self.multipleChoiceValue] forKey:@"MultipleChoiceValue"];
            if (![self isEmbedded])
            {
                [dict setObject:self.choices forKey:@"Choices"];
            }
        }
        else if (self.statType==TSE_FlOATVALUE)
        {
            [dict setObject:[NSNumber numberWithFloat:self.floatValue] forKey:@"FloatValue"];
            if (![self isEmbedded])
            {
                [dict setObject:[NSNumber numberWithFloat:self.floatMin] forKey:@"FloatMin"];
                [dict setObject:[NSNumber numberWithFloat:self.floatMax] forKey:@"FloatMax"];
            }
        }
        else if (self.statType==TSE_TIME)
        {
            [dict setObject:[self.dateValue description] forKey:@"Time"];
        }
        else if (self.statType==TSE_BOOL)
        {
            [dict setObject:[NSNumber numberWithBool:self.boolValue] forKey:@"BoolValue"];
        }
    }
    else
    {
        // Still have to fill out some fields since we ask questions for non embedded types
        if (![self isEmbedded])
        {
            if (self.statType==TSE_INTVALUE)
            {
                [dict setObject:[NSNumber numberWithInt:self.intMin] forKey:@"IntMin"];
                [dict setObject:[NSNumber numberWithInt:self.intMax] forKey:@"IntMax"];
            }
            else if (self.statType==TSE_MULTIPLE_CHOICE)
            {
                [dict setObject:self.choices forKey:@"Choices"];
            }
            else if (self.statType==TSE_FlOATVALUE)
            {
                [dict setObject:[NSNumber numberWithFloat:self.floatMin] forKey:@"FloatMin"];
                [dict setObject:[NSNumber numberWithFloat:self.floatMax] forKey:@"FloatMax"];
            }
        }
    }
    
    return dict;
    
}
// Creates random data for this stat
-(void)createRandomDataForStat
{
    self.answeredStat=true;
    if (self.statType==TSE_INTVALUE)
    {
        self.intValue=self.intMin+(arc4random() % (self.intMax-self.intMin));
    }
    else if (self.statType==TSE_MULTIPLE_CHOICE)
    {
        self.multipleChoiceValue=arc4random() % [self.choices count];
        
    }
    else if (self.statType==TSE_FlOATVALUE)
    {
        self.floatValue=self.floatMin+(arc4random() % (int)(self.floatMax-self.floatMin));
    }
    else if (self.statType==TSE_DATE || self.statType==TSE_TIME)
    {
        self.dateValue=[NSDate date];
        self.dateValue=[self.dateValue dateByAddingTimeInterval:arc4random () % 10000000];
    }
    else if (self.statType==TSE_BOOL)
    {
        if (arc4random() % 2)
        {
            self.boolValue=true;
        }
        else
            self.boolValue=false;
    }
}
// Returns a unique checksum for this stat
-(int)GetChecksum
{
    int checksum=0;
    checksum+=self.boolValue*11;
    checksum+=self.intValue*12;
    checksum+=self.floatValue*13.5;
    checksum+=self.multipleChoiceValue*33;
    checksum+=self.answeredStat*21;
    return checksum;
}
@end
