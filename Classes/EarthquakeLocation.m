//
//  EarthquakeLocation.m
//  EQMap
//
//  Created by Matt Christiansen on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EarthquakeLocation.h"


@implementation EarthquakeLocation

@synthesize latitude;
@synthesize longitude;
@synthesize location;

- (id) initWithLatitude: (double) lat andLongitude: (double) lon {
	location.latitude = lat;
	location.longitude = lon;
}

- (void) dealloc {
	[super dealloc];
}

@end
