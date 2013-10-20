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
@synthesize venuesCountItem;
@synthesize navTitle;

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
    [mapView initWithFrame:mapView.frame];
    NSArray* venues = [[VenuesManager sharedManager] selectedVenues];
    VenueLocation* previous = nil;
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
        [mapView.mapView addAnnotation:annotation];
        Place* from = [Place new];
        Place* to = [Place new];
        if(previous == nil)
        {
            from.latitude = [[LocationManager sharedManager].latitude doubleValue];
            from.longitude = [[LocationManager sharedManager].longitude doubleValue];
        }
        else
        {
            from.latitude = previous.coordinate.latitude;
            from.longitude = previous.coordinate.longitude;
        }
        to.latitude = annotation.coordinate.latitude;
        to.longitude = annotation.coordinate.longitude;
        [mapView showRouteFrom:from to:to];
        previous = annotation;
    }
    
    Place* from = [Place new];
    Place* to = [Place new];
    from.latitude = previous.coordinate.latitude;
    from.longitude = previous.coordinate.longitude;
    to.latitude = [[LocationManager sharedManager].latitude doubleValue];
    to.longitude = [[LocationManager sharedManager].longitude doubleValue];
    [mapView showRouteFrom:from to:to];
    //mapView.mapView.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([LocationManager sharedManager].location, 10000, 10000);
    [mapView.mapView setRegion:viewRegion animated:YES];
    
}
- (IBAction) showSelectVenuesList:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
