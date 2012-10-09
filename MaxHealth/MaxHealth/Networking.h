//
//  Networking.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/19/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CWLSynthesizeSingleton.h"
#import "Profile.h"

@interface NetworkResponse:NSObject
{
}
@property (nonatomic) BOOL IsSuccess;
@property (nonatomic) int ResponseCode;
@property (nonatomic,copy) NSString *ResponseText;

-(id)init:(BOOL)isSuccess responseCode:(int)responseCode responseText:(NSString *)resp;
@end

@interface Networking : NSObject
{
   
    
}

CWL_DECLARE_SINGLETON_FOR_CLASS(Networking)
+(void)Login:(NSString *)name password:(NSString *)password callback:(SEL)callbackSelector fromObject:(id)callbackObject;
+(void)CreateProfile:(Profile *)p password:(NSString *)password callback:(SEL)callbackSelector fromObject:(id)callbackObject;
+(void)GetProfile:(SEL)callbackSelector fromObject:(id)callbackObject;
+(void)GetRecords:(int)numRecords callback:(SEL)callbackSelector fromObject:(id)callbackObject;
+(void)SaveRecord:(HealthRecord *)hr callback:(SEL)callbackSelector fromObject:(id)callbackObject;
+(BOOL)InitNetworking;
+(float)ClientVersion;
+(void)Logout;

@end
