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
@synthesize mTitle;
@synthesize mSubTitle;

- (NSString *)subtitle{
	return mSubTitle;
}

- (NSString *)title{
	return mTitle;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate = c;
	//NSLog(@"%f%f", c.latitude, c.longitude);
	return self;
}

@end
