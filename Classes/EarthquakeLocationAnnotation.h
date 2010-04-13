#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EarthquakeLocationAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	NSString *mTitle;
	NSString *mSubTitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *mTitle;
@property (nonatomic, retain) NSString *mSubTitle;

- (id) initWithCoordinate:(CLLocationCoordinate2D) c;	

@end
