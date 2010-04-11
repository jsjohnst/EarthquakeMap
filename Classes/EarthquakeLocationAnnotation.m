//
//  EarthquakeLocationAnnotation.m
//  EQMap
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright 2010 Cal Poly Pomona. All rights reserved.
//

#import "EarthquakeLocationAnnotation.h"


@implementation EarthquakeLocationAnnotation

@synthesize coordinate;

- (NSString *)subtitle{
	return @"Sub Title";
}

- (NSString *)title{
	return @"title";
}

-(id) initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f%f", c.latitude, c.longitude);
	return self;
}

@end
