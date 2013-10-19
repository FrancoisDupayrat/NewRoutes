//
//  VenueLocation.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueLocation : NSObject <MKAnnotation>
{
    NSString* name;
    NSString* fID;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* fID;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name id:(NSString*)fID coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
