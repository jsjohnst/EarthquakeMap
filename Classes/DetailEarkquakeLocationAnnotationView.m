#import "DetailEarkquakeLocationAnnotationView.h"


@implementation DetailEarkquakeLocationAnnotationView

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
	MKPinAnnotationView *pinView = nil;
	
	if ( pinView == nil ) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	} else {
		pinView = annotation;
	}
	
	
	pinView.pinColor = MKPinAnnotationColorPurple;
	pinView.canShowCallout = YES;
	pinView.animatesDrop = YES;
	
	return pinView;
}

- (void) dealloc {
	[super dealloc];
}

@end
