#import "DetailViewController.h"
#import "RootViewController.h"
#import "Earthquake.h"
#import "EarthquakeLocationAnnotation.h"
#import "AllEarthquakeLocationAnnotationView.h"
#import "DetailEarkquakeLocationAnnotationView.h"

@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, mapView, locateMeButton, activityIndicator, locationManager;

#pragma mark -
#pragma mark Managing the detail item

- (void) loadAllEarthQuakes:(NSArray *) earthquakeList {
	
	for (Earthquake *earthquake in earthquakeList) {
	
	    EarthquakeLocationAnnotation *earthquakeAnnotation = [[[EarthquakeLocationAnnotation alloc] initWithCoordinate: [earthquake getCoordinates]] autorelease];
		[earthquakeAnnotation setTitle:earthquake.location];
		[earthquakeAnnotation setSubtitle:[NSString stringWithFormat:@"%.1f", earthquake.magnitude]];
		
		[mapView addAnnotation:earthquakeAnnotation];
	}
}

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }
	
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
	
	MKAnnotationView <EarthquakeLocationAnnotationView> *earthquakeLocationAnnotationView;
	
	NSString *annotationViewIdentifier = @"EQAnnotationView";
	
	earthquakeLocationAnnotationView = (MKAnnotationView <EarthquakeLocationAnnotationView> *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
	
	if (detailItem == nil) {
		
		if ( earthquakeLocationAnnotationView == nil ) {
			earthquakeLocationAnnotationView = [[[AllEarthquakeLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier] autorelease];
		} else {
			earthquakeLocationAnnotationView.annotation = annotation;
		}
		
	} else {
		earthquakeLocationAnnotationView = [[DetailEarkquakeLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
	}	
	
	[earthquakeLocationAnnotationView setEnabled:YES];
	
	return earthquakeLocationAnnotationView;
	
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (self.mapView.userLocation.location) {
		NSLog(@"Inside the if");
		static CFAbsoluteTime lastTime = 0.0;
		CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
		MKCoordinateSpan span;
		MKCoordinateRegion region;
		
		span.latitudeDelta = 5;
		span.longitudeDelta = 5;
		
		region.span = span;
		
		if((now - lastTime) > 15.0) { // 15 seconds
			static CLLocation *oldLocation = nil;
			if (oldLocation == nil) {
				NSLog(@"Inside the if 2");
				oldLocation = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
				region.center = oldLocation.coordinate;
				[mapView setRegion:region animated:TRUE];
				[mapView regionThatFits:region];
				
			} else {
				NSLog(@"Inside the if 3");
			    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
			    CLLocationDistance distance = [newLocation getDistanceFrom:oldLocation];
				
			    lastTime = now;
			    NSString *test = [[NSString alloc] initWithFormat:@"CHANGE! Lat: %g°, Lon: %g°, Distanz: %gm", mapView.userLocation.location.coordinate.latitude, mapView.userLocation.location.coordinate.longitude, distance];
			    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Observer" message:test delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			    [alert show];[alert release];[test release];
			    oldLocation = newLocation;
				region.center = newLocation.coordinate;
				[mapView setRegion:region animated:TRUE];
				[mapView regionThatFits:region];
			}
		}
    }
}


- (void)configureView {
	
	// remove all previous annotations.
	
	if ([self.mapView.annotations count] > 0) {	
		[self.mapView removeAnnotations:self.mapView.annotations];
	}

	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta=0.5;
	span.longitudeDelta=0.5;

	region.span = span;
	region.center = [detailItem getCoordinates];
	
	EarthquakeLocationAnnotation *earthquakeAnnotation = [[[EarthquakeLocationAnnotation alloc] initWithCoordinate: [detailItem getCoordinates]] autorelease];
	[earthquakeAnnotation setTitle:detailItem.location];
	[earthquakeAnnotation setSubtitle:[NSString stringWithFormat:@"%.1f", detailItem.magnitude]];
	
	[mapView addAnnotation:earthquakeAnnotation];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
}

- (void) zoomToUserLocation {
	MKCoordinateRegion region;
	region.center = self.locationManager.location.coordinate;
	
	MKCoordinateSpan span;
	
	span.latitudeDelta = 5;
	span.longitudeDelta = 5;
	
	region.span = span;
	
	[mapView setRegion:region animated:YES];
	
}


- (void) startLocation: (id) sender{
	
	NSMutableArray *items = [[toolbar items] mutableCopy];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];

	UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];


    locateMeButton = nil;

	locateMeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"black.png"] style:UIBarButtonItemStyleDone target:self action:@selector(stopLocation:)];
			
	[items removeObjectAtIndex:2];
	[items insertObject:activityItem atIndex:2];
	[items insertObject:locateMeButton atIndex:3];
	
	[toolbar setItems:items animated:YES];

	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 10;
	[self.locationManager startUpdatingLocation];
	
	[self.mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
	
	self.mapView.showsUserLocation = YES;
	
	//[mapView setShowsUserLocation:YES];
	
	[items release];
	[activityIndicator release];
    [activityItem release];
	
	NSLog(@"start");
}

- (void) stopLocation: (id) sender {
	
	[activityIndicator stopAnimating];
	NSMutableArray *items = [[toolbar items] mutableCopy];
	
	[items removeObjectAtIndex:3];
	[items removeObjectAtIndex:2];
	
	locateMeButton = nil;
	
	locateMeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"black.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(startLocation:)];
	
	[items insertObject:locateMeButton atIndex:2];
	[toolbar setItems:items animated:YES];
	
	[mapView setShowsUserLocation:NO];
	
	[items release];
	
	NSLog(@"stop");
	
}
	
#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Earthquake List";

	locateMeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"black.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(startLocation:)];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
	[items insertObject:flexItem atIndex:1];
	[items insertObject:locateMeButton atIndex:2];
    [toolbar setItems:items animated:YES];
    [items release];
	[flexItem release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
	[items removeAllObjects];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 [mapView setMapType:MKMapTypeStandard];
	 [mapView setZoomEnabled:YES];
	 [mapView setScrollEnabled:YES];
	 [mapView sizeToFit];
	 [mapView setDelegate:self];
	 
 }

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

}

- (void)dealloc {
    [popoverController release];
    [toolbar release];
	[mapView release];
    [detailItem release];	
	[mapView release];
    [super dealloc];
}

@end
