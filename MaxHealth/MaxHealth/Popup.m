//
//  Popup.m
//  MaxHealth
//
//  Created by Jason Leighton on 9/21/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import "Popup.h"


@implementation Popup

static UIActivityIndicatorView *activityIndicator;

+(void) ShowPopup:(NSString *)title message:(NSString *)message popupType:(PopupTypeEnum)popupType delegate:(id)delegate
{
    UIAlertView *alert= [[UIAlertView alloc]
                          initWithTitle: title
                          message: message
                          delegate: delegate
                         cancelButtonTitle:nil otherButtonTitles:nil];

    if (popupType==OK)
    {
        int index=[alert addButtonWithTitle:@"OK"];
        [alert setCancelButtonIndex:index];
    }
    else if (popupType==OKCANCEL)
    {
        int index=[alert addButtonWithTitle:@"OK"];
        index=[alert addButtonWithTitle:@"Cancel"];
        [alert setCancelButtonIndex:index];
        
    }
    else if (popupType==YESNO)
    {
        int index=[alert addButtonWithTitle:@"Yes"];
        index=[alert addButtonWithTitle:@"No"];
        [alert setCancelButtonIndex:index];
        
    }
    else if (popupType==YESNOCANCEL)
    {
        int index=[alert addButtonWithTitle:@"Yes"];
        index=[alert addButtonWithTitle:@"No"];
        index=[alert addButtonWithTitle:@"Cancel"];
        [alert setCancelButtonIndex:index];        
    }
    [alert show];
}

+(void)ShowActivityIndicatorOnView:(UIView *)view
{
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
	activityIndicator.center = view.center;
	[view addSubview: activityIndicator];
    [activityIndicator startAnimating];
}
+(void)StopActivityIndicator
{
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

@end
