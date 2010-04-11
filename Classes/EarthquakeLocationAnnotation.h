//
//  EarthquakeLocationAnnotation.h
//  EQMap
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright 2010 Cal Poly Pomona. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EarthquakeLocationAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubTitle;
}

@end
