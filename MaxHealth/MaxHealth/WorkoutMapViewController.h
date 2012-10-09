//
//  WorkoutMapViewController.h
//  MaxHealth
//
//  Created by Jason Leighton on 9/5/12.
//  Copyright (c) 2012 Jason Leighton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapRoute.h"

@interface WorkoutMapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    IBOutlet MKMapView *worldView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    MapRoute *route;
}

@end
