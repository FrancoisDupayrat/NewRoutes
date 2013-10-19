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

@interface VenueListMapViewController ()

@end

@implementation VenueListMapViewController

@synthesize category;
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
    [super viewDidLoad];
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
                                       NSLog(@"venues number : %d", venues.count);
                                       for(NSDictionary* venue in venues)
                                       {
                                           NSLog(@"venue : %@", [venue objectForKey:@"name"]);
                                       }
                                   }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
