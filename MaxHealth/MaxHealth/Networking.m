//
//  Networking.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/19/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "Networking.h"
#import "SBJson.h"
#import "LetronicUtils.h"
#import "NetSecrets.h"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation NetworkResponse
@synthesize ResponseCode,ResponseText,IsSuccess;
-(id)init:(BOOL)isSuccess responseCode:(int)responseCode responseText:(NSString *)resp
{
    self=[super init];
    if (self)
    {
        ResponseCode=responseCode;
        IsSuccess = isSuccess;
        ResponseText = resp;
    }
    return self;
}
@end

@implementation Networking
CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(Networking);
static AFHTTPClient *AFClient;
static SBJsonParser *JSONParser;
static SBJsonWriter *JSONWriter;

+(float)ClientVersion
{
    return 1.0;
}

+(BOOL)InitNetworking
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFClient=[AFHTTPClient clientWithBaseURL:url];
    [AFClient setParameterEncoding:AFJSONParameterEncoding];
    
    JSONParser = [[SBJsonParser alloc] init];
    JSONWriter = [[SBJsonWriter alloc] init];
    
    if (AFClient)
        return YES;
    else
        return NO;
    
}
// Login a user to webservice with provided name and password.  Calls callbackSelector when response is acquired
+(void)Login:(NSString *)name password:(NSString *)password callback:(SEL)callbackSelector fromObject:(id)callbackObject
{
    [AFClient setAuthorizationHeaderWithUsername:name password:password];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    APP_SIGNATURE, @"AppSignature",
                                    [NSNumber numberWithFloat:[Networking ClientVersion]], @"ClientVersion",
                                        nil];

    NSMutableURLRequest *request=[AFClient requestWithMethod:@"POST" path:@"Login" parameters:jsonDictionary];
    AFHTTPRequestOperation *operation=[AFClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
           [AFClient clearAuthorizationHeader];
            NetworkResponse *nr=[[NetworkResponse alloc] init:YES responseCode:[operation.response statusCode] responseText:operation.responseString];
           [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error)
       {
           [AFClient clearAuthorizationHeader];
           NSLog(@"error: %@", operation.responseString);
           NetworkResponse *nr=[[NetworkResponse alloc] init:NO responseCode:[operation.response statusCode] responseText:operation.responseString];
           
           [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];

           
       }];
    
    [operation start];
    
}
// Logouts the current user and clears data associated with that profile
+(void)Logout
{
    NSLog (@"Logging out");
    NSMutableURLRequest *request=[AFClient requestWithMethod:@"GET" path:@"Logout" parameters:nil];
    AFHTTPRequestOperation *operation=[AFClient HTTPRequestOperationWithRequest:request success:nil failure:nil];
    [operation start];
    
    [AFClient clearAuthorizationHeader];
    [[Profile sharedProfile] SetProfileDefaults];
    [Networking ClearCookies];
}
// Clears all the cookies for the current session
+(void)ClearCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies)
    {
        [cookieStorage deleteCookie:cookie];
    }
}

// Grabs the profile for the current logged in user
+(void)GetProfile:(SEL)callbackSelector fromObject:(id)callbackObject
{
    NSMutableURLRequest *request=[AFClient requestWithMethod:@"POST" path:@"GetProfile" parameters:nil];
    AFHTTPRequestOperation *operation=[AFClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
           NSError *error = nil;
           NSDictionary *dict= [JSONParser objectWithString:operation.responseString error:&error];
           Profile *p=[Profile sharedProfile];

           [p setUserName:[dict objectForKey:@"Username"]];
           [p setEmailAddress:[dict objectForKey:@"EmailAddress"]];
           [p setBirthdate:[LetronicUtils StringToDate:[dict objectForKey:@"Birthday"]]];
           [p setHeight:[[dict objectForKey:@"Height"] intValue]];
           [p setWeight:[[dict objectForKey:@"Weight"] intValue]];
           [p setIsFemale:[[dict objectForKey:@"IsFemale"] boolValue]];
           
           NetworkResponse *nr=[[NetworkResponse alloc] init:YES responseCode:[operation.response statusCode] responseText:operation.responseString];
           [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error)
       {
           
           NSLog(@"error: %@", operation.responseString);
           NetworkResponse *nr=[[NetworkResponse alloc] init:NO responseCode:[operation.response statusCode] responseText:operation.responseString];
           
           [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
           
       }];
    
    [operation start];
   
}


// Creates a profile on the network
+(void)CreateProfile:(Profile *)p password:(NSString *)password callback:(SEL)callbackSelector fromObject:(id)callbackObject
{
  
    NSLog (@"Creating Profile with username %@",p.userName);
    
    //[callbackObject performSelector:callbackSelector withObject:nil withObject:nil];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    APP_SIGNATURE, @"AppSignature",
                                    [NSNumber numberWithFloat:[Networking ClientVersion]], @"ClientVersion",
                                    p.userName,@"Username",
                                    password,@"Password",
                                    p.emailAddress,@"EmailAddress",
                                    [p.birthdate description],@"Birthday",
                                    [NSNumber numberWithBool:p.isFemale],@"IsFemale",
                                    [NSNumber numberWithInt:p.height],@"Height",
                                    [NSNumber numberWithInt:p.weight],@"Weight",
                                    nil];
    
    NSMutableURLRequest *request=[AFClient requestWithMethod:@"POST" path:@"CreateProfile" parameters:jsonDictionary];
    AFHTTPRequestOperation *operation=[AFClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
           NSLog(@"operation hasAcceptableStatusCode: %d", [operation.response statusCode]);
           NSLog(@"response string: %@ ", operation.responseString);
           
           NetworkResponse *nr=[[NetworkResponse alloc] init:YES responseCode:[operation.response statusCode] responseText:operation.responseString];
           [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error)
       {
           
           NSLog(@"error: %@", operation.responseString);
           NetworkResponse *nr=[[NetworkResponse alloc] init:NO responseCode:[operation.response statusCode] responseText:operation.responseString];
           
           [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
           
       }];
    
    [operation start];

}

// Parses an array of records returned from GetRecords
+(void)ParseReturnedRecords:(NSDictionary *)dict
{
    Profile *p=[Profile sharedProfile];
    [p.healthRecords removeAllObjects];
    NSArray *records=[dict objectForKey:@"Records"];
    for (NSDictionary *record in records)
    {
        HealthRecord *hr=[[HealthRecord alloc] init];
        hr.recordDate=[LetronicUtils StringToDate:[record objectForKey:@"RecordDate"]];
        hr.localTimeZoneAdjustment=[[record objectForKey:@"LocalTimeZoneAdjustment"] intValue];
        NSLog (@"RecordDate=%@ LocalTimeZoneAdjustment=%d",[hr.recordDate description],hr.localTimeZoneAdjustment);
        NSArray *categories=[record objectForKey:@"Categories"];
                for (NSDictionary *category in categories)
        {
            StatCategory *sc=[StatCategory InitWithName:[category objectForKey:@"CategoryName"]];
            NSArray *trackedStats=[category objectForKey:@"TrackedStats"];
            for (NSDictionary *incomingStat in trackedStats)
            {
                TrackedStat *ts=[TrackedStat InitWithName:[incomingStat objectForKey:@"Name"] andType:[[incomingStat objectForKey:@"StatType"] intValue] andQuestion:[incomingStat objectForKey:@"Question"]];
                
                if ([[incomingStat objectForKey:@"AnsweredStat"] boolValue])
                {
                    ts.answeredStat=true;
                    int statType=[[incomingStat objectForKey:@"StatType"] intValue];
                    if (statType==TSE_INTVALUE)
                    {
                        ts.intValue=[[incomingStat objectForKey:@"IntValue"] intValue];
                        ts.intMin=[[incomingStat objectForKey:@"IntMin"] intValue];
                        ts.intMax=[[incomingStat objectForKey:@"IntMax"] intValue];
                    }
                    else if (statType==TSE_MULTIPLE_CHOICE)
                    {
                        ts.multipleChoiceValue=[[incomingStat objectForKey:@"MultipleChoiceValue"] intValue];
                        ts.choices=[incomingStat objectForKey:@"Choices"];
                    }
                    else if (statType==TSE_BOOL)
                    {
                        ts.boolValue=[[incomingStat objectForKey:@"MultipleChoiceValue"] boolValue];
                    }
                    else if (statType==TSE_DATE)
                    {
                        ts.dateValue=[LetronicUtils StringToDate:[incomingStat objectForKey:@"Time"]];
                    }
                    else if (statType==TSE_TIME)
                    {
                        ts.dateValue=[LetronicUtils StringToDate:[incomingStat objectForKey:@"Time"]];
                    }
                }
                
                [sc addTrackedStat:ts];
                
            }
                
            [hr AddCategory:sc];
        }
        
        [p.healthRecords addObject:hr];
     
        if ([LetronicUtils AreDatesEqual:hr.recordDate secondDate:[LetronicUtils UTCDateToLocalDate:[NSDate date]]])
        {
            NSLog (@"Setting todays health record...it has %d categories",hr.allCategories.count);
            p.todaysHealthRecord=hr;
        }
    }
    NSLog (@"Parsed %d records, and profile now has %d records",[records count],[[[Profile sharedProfile] healthRecords] count]);
}

+(void)GetRecords:(int)numRecords callback:(SEL)callbackSelector fromObject:(id)callbackObject
{
    NSString *pathStr=[[NSString alloc] initWithFormat:@"GetRecords/%d",numRecords];
    NSMutableURLRequest *request=[AFClient requestWithMethod:@"POST" path:pathStr parameters:nil];
    AFHTTPRequestOperation *operation=[AFClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
           NSError *error = nil;
           NSDictionary *dict= [JSONParser objectWithString:operation.responseString error:&error];
           [Networking ParseReturnedRecords:dict];
           
           NetworkResponse *nr=[[NetworkResponse alloc] init:YES responseCode:[operation.response statusCode] responseText:operation.responseString];
           if (callbackObject)
               [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error)
       {
           
           NSLog(@"GetRecords Error: %@", operation.responseString);
           NetworkResponse *nr=[[NetworkResponse alloc] init:NO responseCode:[operation.response statusCode] responseText:operation.responseString];
           
           if (callbackObject)
               [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
           
       }];

    [operation start];
    
}

// Saves the passed in record to the network
+(void)SaveRecord:(HealthRecord *)hr callback:(SEL)callbackSelector fromObject:(id)callbackObject
{
    NSLog (@"Saving HealthRecord");
    
    NSString *jsonString = [hr JSONRepresentation];
    NSDictionary *dictToSend = [NSDictionary dictionaryWithObjectsAndKeys:
                                    jsonString, @"HealthRecord",nil];
    
    NSMutableURLRequest *request=[AFClient requestWithMethod:@"POST" path:@"SaveRecord" parameters:dictToSend];
    AFHTTPRequestOperation *operation=[AFClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
           NSLog(@"operation hasAcceptableStatusCode: %d", [operation.response statusCode]);
           NSLog(@"response string: %@ ", operation.responseString);
           
           NetworkResponse *nr=[[NetworkResponse alloc] init:YES responseCode:[operation.response statusCode] responseText:operation.responseString];
           if (callbackObject!=nil)
               [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error)
       {
           
           NSLog(@"error: %@", operation.responseString);
           NetworkResponse *nr=[[NetworkResponse alloc] init:NO responseCode:[operation.response statusCode] responseText:operation.responseString];
           
           if (callbackObject!=nil)
               [callbackObject performSelector:callbackSelector withObject:nr withObject:nil];
           
           
       }];
    
    [operation start];
}
@end
