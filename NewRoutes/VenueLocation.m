//
//  VenueLocation.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "VenueLocation.h"

@implementation VenueLocation

@synthesize name;
@synthesize fID;
@synthesize coordinate;

- (id)initWithName:(NSString*)nameParam id:(NSString*)fIDParam coordinate:(CLLocationCoordinate2D)coordinateParam {
    if ((self = [super init]))
    {
        self.name = nameParam;
        self.fID = fIDParam;
        self.coordinate = coordinateParam;
    }
    return self;
}

- (NSString*) title
{
    return name;
}

- (MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.name;
    
    return mapItem;
}

@end
