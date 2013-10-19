//
//  LocationManager.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocation* lastLocation;
    CLLocationManager* locationManager;
}

@property (nonatomic, readonly) NSNumber* latitude;
@property (nonatomic, readonly) NSNumber* longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

+ (LocationManager*) sharedManager;

- (BOOL) checkLocationValid;

@end
