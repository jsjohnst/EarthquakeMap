#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EarthquakeLocationAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (id) initWithCoordinate:(CLLocationCoordinate2D) c;	

@end
