//
//  HealthRecord.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/25/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatCategory.h"

@interface HealthRecord : NSObject
{
    
}
@property (nonatomic) NSMutableArray *allCategories;
@property (nonatomic) NSDate *recordDate;
@property (nonatomic) int localTimeZoneAdjustment;

-(id) init;
-(void)AddCategory:(StatCategory *)category;
-(void)ClearAllCategories;
-(StatCategory *)FindCategory:(NSString *)str;
-(void)PopulateWithTempData;
-(int)GetChecksum;
- (NSDictionary*) proxyForJson;
-(void)createRandomDataForRecord;

@end
