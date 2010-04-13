#import "Earthquake.h"


@implementation Earthquake

@synthesize magnitude;
@synthesize location;
@synthesize date;
@synthesize USGSWebLink;
@synthesize latitude;
@synthesize longitude;

- (void) dealloc {
	[location release];
	[date release];
	[USGSWebLink release];
	[super dealloc];
}

@end
