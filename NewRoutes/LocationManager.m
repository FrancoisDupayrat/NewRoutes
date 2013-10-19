//
//  LocationManager.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

static LocationManager* _sharedManager = nil;

+ (LocationManager*) sharedManager
{
	@synchronized([LocationManager class])
	{
		if (!_sharedManager)
			_sharedManager = [[self alloc] init];
		
		return _sharedManager;
	}
	
	return nil;
}

+ (id) alloc
{
	@synchronized([LocationManager class])
	{
		NSAssert(_sharedManager == nil, @"Attempted to allocate a second instance of LocationManager singleton.");
		_sharedManager = [super alloc];
		return _sharedManager;
	}
	
	return nil;
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        [self geolocUser];
    }
    return self;
}

- (NSNumber*) latitude
{
    return [NSNumber numberWithDouble:lastLocation.coordinate.latitude];
}

- (NSNumber*) longitude
{
    return [NSNumber numberWithDouble:lastLocation.coordinate.longitude];
}


- (CLLocationCoordinate2D) location
{
    return lastLocation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [self geolocUser];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    lastLocation = [manager location];
}

- (void) geolocUser
{
    CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
    if (locationStatus == kCLAuthorizationStatusNotDetermined) {
        if(locationManager == nil)
        {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }
        [locationManager startUpdatingLocation];
        return;
    }
    else if(locationStatus == kCLAuthorizationStatusDenied || locationStatus == kCLAuthorizationStatusRestricted)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Géolocalisation impossible"
                                                        message:locationStatus == kCLAuthorizationStatusDenied ? @"Vous avez refusé la géolocalisation. Pour la réactiver, allez dans les réglages." : @"Les restrictions de l'appareil empêchent la géolocalisation."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		[alert show];
        return;
    }
    if(locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    // show "loading"
    dispatch_async(dispatch_get_main_queue(),^{
        //TODO
        //[self showProgressHUD];
    });
    
    
    // NEW QUEUE
    dispatch_queue_t locationQueue = dispatch_queue_create("location queue", NULL);
    dispatch_async(locationQueue, ^{
        
        [locationManager startUpdatingLocation];
        
        /*
        // perform geocode, to get user-friendly display of a CLLocation (convert latitude/longitude into adress/city ...)
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:locationManager.location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           dispatch_async(dispatch_get_main_queue(),^ {
                               // do stuff with placemarks on the main thread
                               
                               if (placemarks.count == 0) {
                                   // KILL LOADING VIEW
                                   [self killProgressHUD];
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] init];
                                   alert.title = @"Nous n'avons pas trouvé votre ville. Essayez la recherche manuelle.";
                                   [alert addButtonWithTitle:@"Ok"];
                                   [alert show];
                               }
                               
                               
                               if(placemarks && placemarks.count > 0)
                               {
                                   //do something
                                   CLPlacemark *topResult = [placemarks objectAtIndex:0];
                                   NSString *addressTxt = [NSString stringWithFormat:@"%@",
                                                           [topResult locality]];
                                   
                                   
                                   currentCity = [[Ville alloc] init];
                                   currentCity.nom = addressTxt;
                                   currentCity.latitude = [[NSNumber alloc] initWithFloat:topResult.location.coordinate.latitude];
                                   currentCity.longitude = [[NSNumber alloc] initWithFloat:topResult.location.coordinate.longitude];
                                   currentCity.pays = topResult.country;
                                   currentCity.code = topResult.postalCode;
                                   
                                   [self showAnimateGeolocEnd];
                                   
                                   [self initListingAndGo];
                                   
                                   
                                   
                               }
                           }); // end main Queue
                           
                           
                       }];*/
    }); // end location Queue
}

- (BOOL) checkLocationValid
{
    if(lastLocation != nil)
    {
        return true;
    }
    CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Géolocalisation impossible"
                                                    message:locationStatus == kCLAuthorizationStatusDenied ? @"Vous avez refusé la géolocalisation. Pour la réactiver, allez dans les réglages." :
                          kCLAuthorizationStatusRestricted ? @"Les restrictions de l'appareil empêchent la géolocalisation." : kCLAuthorizationStatusRestricted ? @"Vous devez accepter la géo-localisation avant de pouvoir commencer" : @"Localisation en cours ..."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert show];
    return false;
}

@end
