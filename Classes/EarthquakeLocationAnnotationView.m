#import "EarthquakeLocationAnnotationView.h"


@implementation EarthquakeLocationAnnotationView

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
	MKPinAnnotationView *pinView = nil;
	
//	pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
	
	if ( pinView == nil ) {
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] autorelease];
	}
	
	pinView.pinColor = MKPinAnnotationColorPurple;
	pinView.canShowCallout = YES;
	
    return pinView;
}

@end