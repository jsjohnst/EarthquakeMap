#import "EarthquakeLocationAnnotationView.h"


@implementation EarthquakeLocationAnnotationView

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
	MKPinAnnotationView *pinView = nil;
	
	if ( pinView == nil ) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	} else {
		pinView = annotation;
	}

	
	pinView.pinColor = MKPinAnnotationColorPurple;
	pinView.canShowCallout = YES;

    return pinView;
}

- (void) dealloc {
	[self release];
	[super dealloc];
}

@end