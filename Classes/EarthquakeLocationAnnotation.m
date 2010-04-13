#import "EarthquakeLocationAnnotation.h"


@implementation EarthquakeLocationAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate = c;
	//NSLog(@"%f%f", c.latitude, c.longitude);
	return self;
}

- (void) dealloc {
	[title release];
	[subtitle release];
	[super dealloc];
}
@end
