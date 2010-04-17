#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol EarthquakeLocationAnnotationView <NSObject>

@required
- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end

