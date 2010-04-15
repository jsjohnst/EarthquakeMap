#import "AllEarthquakeLocationAnnotationView.h"


@implementation AllEarthquakeLocationAnnotationView

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
	[super dealloc];
}

@end