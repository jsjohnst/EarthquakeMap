#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import "AllEarthquakeLocationAnnotationView.h"
//#import "DetailEarkquakeLocationAnnotationView.h"

@protocol EarthquakeLocationAnnotationView <NSObject>

- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end


//@interface EarthquakeLocationAnnotationView : NSObject {
//	BOOL detailView;
//	
//	AllEarthquakeLocationAnnotationView *allEarthquakeLocationAnnotationView;
//	DetailEarkquakeLocationAnnotationView *detailEarthquakeLocationAnnotationView;
//	
//
//}
//
//@property (nonatomic, assign) BOOL detailView;
//
//@property (nonatomic, retain) AllEarthquakeLocationAnnotationView *allEarthquakeLocationAnnotationView;
//@property (nonatomic, retain) DetailEarkquakeLocationAnnotationView *detailEarthquakeLocationAnnotationView;
//
//- (id) initWithDetailView: (BOOL) isItDetailView;
//
//- (id) getView;
