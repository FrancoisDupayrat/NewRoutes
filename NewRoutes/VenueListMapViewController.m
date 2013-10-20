//
//  VenueListMapViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "VenueListMapViewController.h"
#import <Foursquare2.h>
#import "LocationManager.h"
#import "VenueLocation.h"
#import "VenuesManager.h"
#import "CategoryListViewController.h"
#import "VenuesOrderMapViewController.h"
#import "VenueDetailViewController.h"
#import "VenuesManager.h"

@interface VenueListMapViewController ()

@end

@implementation VenueListMapViewController

@synthesize category;
@synthesize mapView;
@synthesize venuesCountItem;
@synthesize nextButton;
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
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextScreen:)];
    [navTitle setTitle:[category objectForKey:@"name"]];
    NSArray* venues = [VenuesManager sharedManager].selectedVenues;
    int count = (int)venues.count;
    NSString* title = count == 0 ? @"Aucun lieu sélectionné" :
    count == 1 ? @"Un lieu sélectionné" :
    [NSString stringWithFormat:@"%d lieux sélectionnés", count];
    [venuesCountItem setTitle:title];
    
    
    for(NSDictionary* venue in venues)
    {
        NSLog(@"selected venue : %@", [venue objectForKey:@"name"]);
        NSNumber * latitude = [venue objectForKey:@"lat"];
        NSNumber * longitude = [venue objectForKey:@"lng"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        VenueLocation *annotation = [[VenueLocation alloc] initWithName:[venue objectForKey:@"name"]
                                                                     id:[venue objectForKey:@"id"]
                                                             coordinate:coordinate];
        annotation.isSelected = YES;
        [mapView addAnnotation:annotation];
    }
    
    [Foursquare2 searchVenuesNearByLatitude:[LocationManager sharedManager].latitude
                                  longitude:[LocationManager sharedManager].longitude
                                 accuracyLL:NULL
                                   altitude:NULL
                                accuracyAlt:NULL
                                      query:@""
                                      limit:[NSNumber numberWithInt:50]
                                     intent:intentBrowse
                                     radius:[NSNumber numberWithInt:10000]//10km
                                 categoryId:[category objectForKey:@"id"]
                                   callback:^(BOOL success, id result) {
                                       NSDictionary* response = [result objectForKey:@"response"];
                                       NSArray* venues = (NSArray*)[response objectForKey:@"venues"];
                                       NSLog(@"venues number : %d", (int)venues.count);
                                       
                                       for(NSDictionary* venue in venues)
                                       {
                                           NSDictionary* location = [venue objectForKey:@"location"];
                                           NSLog(@"available venue : %@", [venue objectForKey:@"name"]);
                                           NSNumber * latitude = [location objectForKey:@"lat"];
                                           NSNumber * longitude = [location objectForKey:@"lng"];
                                           
                                           CLLocationCoordinate2D coordinate;
                                           coordinate.latitude = latitude.doubleValue;
                                           coordinate.longitude = longitude.doubleValue;
                                           VenueLocation *annotation = [[VenueLocation alloc] initWithName:[venue objectForKey:@"name"]
                                                                                                        id:[venue objectForKey:@"id"]
                                                                                                coordinate:coordinate] ;
                                           [mapView addAnnotation:annotation];
                                       }
                                   }];
    mapView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([LocationManager sharedManager].location, 10000, 10000);
    [mapView setRegion:viewRegion animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapViewParam viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[VenueLocation class]]) {
        VenueLocation* venue = annotation;
        NSString *identifier = venue.isSelected ? @"SelectedVenueLocation" : @"AvailableVenueLocation";
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            MKPinAnnotationView *pin =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            pin.canShowCallout = YES;
            pin.animatesDrop = NO;
            pin.draggable = NO;
            pin.pinColor = venue.isSelected ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
            annotationView = pin;
            annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            UIButton* go = [UIButton buttonWithType:UIButtonTypeSystem];
            [go setTitle:venue.isSelected ? @"Retirer" : @"Go" forState:UIControlStateNormal];
            CGRect buttonFrame = go.frame;
            buttonFrame.size = CGSizeMake(32, 32); //Height is limited to 32 pixels
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
    else if(venue.isSelected)
    {
        [[VenuesManager sharedManager] removeVenue:venue.fID];
        [mapView removeAnnotation:venue];
    }
    else
    {
        [[VenuesManager sharedManager] selectVenue:venue];

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enregistré !"
                                                        message:[NSString stringWithFormat:@"Point d'intérêt %@ enregistré. Vous avez actuellement %d points sur votre parcours", venue.name, [VenuesManager sharedManager].selectedVenues.count]
                                                       delegate:self
                                              cancelButtonTitle:@"Voir le parcours"
                                              otherButtonTitles:@"Chercher un autre", nil];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [alert dismissWithClickedButtonIndex:1 animated:YES];
		[alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self nextScreen:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction) showSelectVenuesList:(id)sender
{
    
}

- (IBAction) nextScreen:(id)sender
{
    VenuesOrderMapViewController* vc = [[VenuesOrderMapViewController alloc] initWithNibName:@"VenuesOrderMapViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
