//
//  LetronicUtils.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/26/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "LetronicUtils.h"

@implementation LetronicUtils

+(NSDate *)GetDateWithNoTime:(NSDate *)incomingDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:incomingDate];
    NSDate *outgoingDate = [cal dateFromComponents:comps];
    return outgoingDate;
}
+(BOOL)AreDatesEqual:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
    firstDate=[LetronicUtils GetDateWithNoTime:firstDate];
    secondDate=[LetronicUtils GetDateWithNoTime:secondDate];
    if ([firstDate compare:secondDate]==NSOrderedSame)
        return true;
    return false;
}

// Converts the passed in UTC date to the local system time
+(NSDate *)UTCDateToLocalDate:(NSDate *)utcDate
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: utcDate];
    NSDate *retDate=[NSDate dateWithTimeInterval: seconds sinceDate: utcDate];
    return retDate;
}
// Converts the passed in local date to the utc
+(NSDate *) LocalDateToUTCDate:(NSDate *)localDate
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: localDate];
    return [NSDate dateWithTimeInterval: seconds sinceDate: localDate];
}

// Converts the passed in UTC date to the local system time
+(NSDate *)UTCDateToLocalDate2:(NSDate *)sourceDate
{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return destinationDate;
    
}



+(NSDate *)StringToDate:(NSString *)str
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    NSDate *myDate = [df dateFromString: str];
    if (myDate==NULL || myDate==nil)
    {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
        myDate = [df dateFromString: str];
        
    }
    if (myDate==NULL || myDate==nil)
    {
        NSLog (@"Couldn't get date from string %@",str);
        
    }
        
    return myDate;
}

@end

@implementation UIView (viewRecursion)
- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}
@end

@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

@end
