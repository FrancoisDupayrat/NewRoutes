//
//  VenueListMapViewController.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VenueListMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>
{
    NSDictionary* category;
    MKMapView* mapView;
    UINavigationItem* navTitle;
    UIBarButtonItem* venuesCountItem;
    UIBarButtonItem* nextButton;
}

@property (nonatomic, retain) NSDictionary* category;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UINavigationItem* navTitle;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* venuesCountItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* nextButton;

- (IBAction) showSelectVenuesList:(id)sender;
- (IBAction) nextScreen:(id)sender;

@end
