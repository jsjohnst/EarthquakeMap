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

- (void) dealloc {
	[mTitle release];
	[mSubTitle release];
	[super dealloc];
}
@end
