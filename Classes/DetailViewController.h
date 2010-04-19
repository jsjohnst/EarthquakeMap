#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Earthquake.h"
#import "EarthquakeLocationAnnotationView.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
	UIActivityIndicatorView *activityIndicator;
	CLLocationManager *locationManager;
	
	UIBarButtonItem *locateMeButton;
    
    Earthquake *detailItem;
	
	IBOutlet MKMapView *mapView;
	
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *locateMeButton;
@property (nonatomic, retain) Earthquake *detailItem;

- (void) loadAllEarthQuakes:(NSArray *) earthquakeList;
- (void) zoomToUserLocation;
- (void) startLocation: (id) sender;
- (void) stopLocation: (id) sender;

@end
