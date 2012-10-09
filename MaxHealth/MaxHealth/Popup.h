//
//  Popup.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/21/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Popup : NSObject
{
   
}

typedef enum
{
    OK=0,
    OKCANCEL=1,
    YESNO=2,
    YESNOCANCEL=3
} PopupTypeEnum;

+(void) ShowPopup:(NSString *)title message:(NSString *)message popupType:(PopupTypeEnum)popupType delegate:(id)delegate;
+(void) ShowActivityIndicatorOnView:(UIView *)view;
+(void) StopActivityIndicator;

@end
