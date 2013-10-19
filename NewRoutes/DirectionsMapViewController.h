//
//  DirectionsMapViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DirectionsMapViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView* mapView;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
