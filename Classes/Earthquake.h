//
//  Earthquake.h
//  EQMap
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright 2010 Cal Poly Pomona. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Earthquake : NSObject {
@private
	CGFloat magnitude;
	NSString *location;
	NSDate *date;
	NSString *USGSWebLink;
	double latitude;
	double longitude;
}

@property (nonatomic, assign) CGFloat magnitude;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) NSString *USGSWebLink;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
