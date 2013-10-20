//
//  VenuesManager.h
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenueLocation.h"

@interface VenuesManager : NSObject
{
    NSMutableArray* selectedVenues;
}

@property (nonatomic, readonly) NSArray* selectedVenues;

+ (VenuesManager*) sharedManager;

- (void)selectVenue:(VenueLocation*)venue;
- (void)removeVenue:(NSString*)fID;
- (int) getIndex:(NSString*)fID;

@end
