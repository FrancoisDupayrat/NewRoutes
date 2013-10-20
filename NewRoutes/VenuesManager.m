//
//  VenuesManager.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "VenuesManager.h"

@implementation VenuesManager

@synthesize selectedVenues;

static VenuesManager* _sharedManager = nil;

+ (VenuesManager*) sharedManager
{
	@synchronized([VenuesManager class])
	{
		if (!_sharedManager)
			_sharedManager = [[self alloc] init];
		
		return _sharedManager;
	}
	
	return nil;
}

+ (id) alloc
{
	@synchronized([VenuesManager class])
	{
		NSAssert(_sharedManager == nil, @"Attempted to allocate a second instance of VenuesManager singleton.");
		_sharedManager = [super alloc];
		return _sharedManager;
	}
	
	return nil;
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        selectedVenues = [NSMutableArray new];
    }
    return self;
}

- (void)selectVenue:(VenueLocation*)venue
{
    NSDictionary* venueInfos = [NSDictionary dictionaryWithObjectsAndKeys:venue.name, @"name", venue.fID, @"id", [NSNumber numberWithDouble:venue.coordinate.latitude], @"lat", [NSNumber numberWithDouble:venue.coordinate.longitude], @"lng", nil];
    [selectedVenues addObject:venueInfos];
}

- (int) getIndex:(NSString*)fID
{
    for(int i = 0; i < selectedVenues.count; i++)
    {
        NSDictionary* infos = [selectedVenues objectAtIndex:i];
        if([fID isEqualToString:[infos objectForKey:@"id"]])
        {
            return i;
        }
    }
    return -1;
}
- (void)removeVenue:(NSString*)fID
{
    NSDictionary* target = nil;
    for (NSDictionary* venue in selectedVenues)
    {
        if([[venue objectForKey:@"id"] isEqualToString:fID])
        {
            target = venue;
        }
    }
    if(target != nil)
    {
        [selectedVenues removeObject:target];
    }
}

- (NSDictionary*) venueAtIndex:(int)index
{
    return [selectedVenues objectAtIndex:index];
}

- (int) count
{
    return selectedVenues.count;
}

@end
