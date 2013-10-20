//
//  DirectionsMapViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapView.h"

@interface DirectionsMapViewController : UIViewController <MKMapViewDelegate>
{
    MapView* mapView;
    UINavigationItem* navTitle;
    UIBarButtonItem* venuesCountItem;
}

@property (strong, nonatomic) IBOutlet MapView *mapView;
@property (strong, nonatomic) IBOutlet UINavigationItem* navTitle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* venuesCountItem;

- (IBAction) showSelectVenuesList:(id)sender;

@end
