#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Earthquake.h"
#import "EarthquakeLocationAnnotationView.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, MKMapViewDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    Earthquake *detailItem;
	
	MKAnnotationView <EarthquakeLocationAnnotationView> *earthquakeLocationAnnotationView;
	
	IBOutlet MKMapView *mapView;
	
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) Earthquake *detailItem;
@property (nonatomic, retain) MKAnnotationView <EarthquakeLocationAnnotationView> *earthquakeLocationAnnotationView;

- (void) loadAllEarthQuakes:(NSArray *) earthquakeList;

@end
