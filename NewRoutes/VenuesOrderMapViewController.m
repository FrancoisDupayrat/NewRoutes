//
//  DirectionsMapViewController.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "VenuesOrderMapViewController.h"
#import "VenuesManager.h"
#import "VenueLocation.h"
#import "LocationManager.h"
#import "VenueDetailViewController.h"
#import "DirectionsMapViewController.h"
#import "SelectedVenuesListViewController.h"

@interface VenuesOrderMapViewController ()

@end

@implementation VenuesOrderMapViewController

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
    NSArray* venues = [[VenuesManager sharedManager] selectedVenues];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showDirections:)];
    self.navigationItem.title = @"Ordre des visites";
    
    int count = (int)venues.count;
    NSString* title = count == 0 ? @"Aucun lieu sélectionné" :
    count == 1 ? @"Un lieu sélectionné" :
    [NSString stringWithFormat:@"%d lieux sélectionnés", count];
    [venuesCountItem setTitle:title];
    
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

-(UIImage *)imageFromText:(NSString *)text
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:12.0];
    CGSize size  = [text sizeWithFont:font];
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(size);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width, secondImage.size.width), MAX(firstImage.size.height, secondImage.size.height));
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
    }
    [firstImage drawAtPoint:CGPointMake(roundf((newImageSize.width-firstImage.size.width)/2),
                                        roundf((newImageSize.height-firstImage.size.height)/2))];
    [secondImage drawAtPoint:CGPointMake(roundf((newImageSize.width-secondImage.size.width)/2),
                                         roundf((newImageSize.height-secondImage.size.height)/2))];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
            int number = [[VenuesManager sharedManager] getIndex:((VenueLocation*)annotation).fID] + 1;
            UIImage* textImage = [self imageFromText:number == -1 ? @"?" : [NSString stringWithFormat:@"%d", number]];
            UIImage* pinImage = [UIImage imageNamed:@"green_pin.png"];
            UIImage* result = [self imageByCombiningImage:pinImage withImage:textImage];
            annotationView.image = result;
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

- (IBAction) showSelectVenuesList:(id)sender
{
    SelectedVenuesListViewController* vc = [[SelectedVenuesListViewController alloc] initWithNibName:@"SelectedVenuesListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) showDirections:(id)sender
{
    DirectionsMapViewController* vc = [[DirectionsMapViewController alloc] initWithNibName:@"DirectionsMapViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
