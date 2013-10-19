//
//  DirectionsMapViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "DirectionsMapViewController.h"
#import "VenuesManager.h"
#import "VenueLocation.h"
#import "LocationManager.h"
#import "VenueDetailViewController.h"

@interface DirectionsMapViewController ()

@end

@implementation DirectionsMapViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSArray* venues = [[VenuesManager sharedManager] selectedVenues];
    
    for(NSDictionary* venue in venues)
    {
        NSLog(@"venue : %@", [venue objectForKey:@"name"]);
        NSNumber * latitude = [venue objectForKey:@"lat"];
        NSNumber * longitude = [venue objectForKey:@"lng"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        VenueLocation *annotation = [[VenueLocation alloc] initWithName:[venue objectForKey:@"name"]
                                                                     id:[venue objectForKey:@"id"]
                                                             coordinate:coordinate] ;
        [mapView addAnnotation:annotation];
    }
    mapView.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([LocationManager sharedManager].location, 10000, 10000);
    [mapView setRegion:viewRegion animated:YES];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapViewParam viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"VenueLocation";
    if ([annotation isKindOfClass:[VenueLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            MKPinAnnotationView *pin =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            pin.canShowCallout = YES;
            pin.animatesDrop = NO;
            pin.draggable = NO;
            annotationView = pin;
            annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            UIButton* go = [UIButton buttonWithType:UIButtonTypeSystem];
            [go setTitle:@"Retirer" forState:UIControlStateNormal];
            CGRect buttonFrame = go.frame;
            buttonFrame.size = CGSizeMake(64, 32); //Height is limited to 32 pixels
            go.frame = buttonFrame;
            annotationView.rightCalloutAccessoryView = go;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapViewParam annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    UIButton* button = (UIButton*)control;
    VenueLocation* venue = view.annotation;
    if(button.buttonType == UIButtonTypeDetailDisclosure)
    {
        VenueDetailViewController* vc = [[VenueDetailViewController alloc] initWithNibName:@"VenueDetailViewController" bundle:nil];
        [vc setFID:venue.fID];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [[VenuesManager sharedManager] removeVenue:venue.fID];
        [mapView removeAnnotation:venue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
