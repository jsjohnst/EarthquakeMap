#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Earthquake : NSObject {
@private
	CGFloat magnitude;
	NSString *location;
	NSDate *date;
	NSString *USGSWebLink;
	double latitude;
	double longitude;
	CLLocationCoordinate2D coordinates;

}

@property (nonatomic, assign) CGFloat magnitude;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *USGSWebLink;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;

- (CLLocationCoordinate2D) getCoordinates;

@end
