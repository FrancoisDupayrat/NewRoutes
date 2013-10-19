//
//  VenueListMapViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VenueListMapViewController : UIViewController
{
    NSDictionary* category;
    MKMapView* mapView;
}

@property (nonatomic, retain) NSDictionary* category;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
