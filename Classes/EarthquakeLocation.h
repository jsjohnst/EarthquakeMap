//
//  EarthquakeLocation.h
//  EQMap
//
//  Created by Matt Christiansen on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EarthquakeLocation : NSObject {
	
	CLLocationCoordinate2D location;
	double latitude;
	double longitude;

}

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (id) initWithLatitude: (double) lat andLongitude: (double) lon;

@end
