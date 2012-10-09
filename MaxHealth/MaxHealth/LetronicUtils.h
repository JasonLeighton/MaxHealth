//
//  LetronicUtils.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/26/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LetronicUtils : NSObject
{
    
}
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

+(NSDate *)GetDateWithNoTime:(NSDate *)incomingDate;
+(BOOL)AreDatesEqual:(NSDate *)firstDate secondDate:(NSDate *)secondDate;
+(NSDate *)StringToDate:(NSString *)str;
+(NSDate *)UTCDateToLocalDate:(NSDate *)utcDate;
+(NSDate *)LocalDateToUTCDate:(NSDate *)localDate;

@end



@interface UIView (viewRecursion)
- (NSMutableArray*) allSubViews;
@end

@interface UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size;
@end
