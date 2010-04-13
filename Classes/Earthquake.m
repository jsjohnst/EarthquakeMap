#import "Earthquake.h"


@implementation Earthquake

@synthesize magnitude;
@synthesize location;
@synthesize date;
@synthesize USGSWebLink;
@synthesize latitude;
@synthesize longitude;
@synthesize coordinates;

- (CLLocationCoordinate2D) getCoordinates {
	coordinates.latitude = latitude;
	coordinates.longitude = longitude;
	
	return coordinates;
}

- (void) dealloc {
	[location release];
	[date release];
	[USGSWebLink release];
	[super dealloc];
}

@end
