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

@synthesize toolbar, popoverController, detailItem, mapView, earthquakeLocationAnnotationView, locateMeButton;

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
	
	NSString *annotationViewIdentifier = @"EQAnnotationView";
	
	earthquakeLocationAnnotationView = (MKAnnotationView <EarthquakeLocationAnnotationView> *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
	
	if (detailItem == nil) {
		
		if ( earthquakeLocationAnnotationView == nil ) {
			earthquakeLocationAnnotationView = [[[AllEarthquakeLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier] autorelease];
		} else {
			earthquakeLocationAnnotationView.annotation = annotation;
		}
		
	} else {
		
		if ( earthquakeLocationAnnotationView == nil ) {
			earthquakeLocationAnnotationView = [[[DetailEarkquakeLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier] autorelease];
		} else {
			earthquakeLocationAnnotationView = nil;
			earthquakeLocationAnnotationView = (DetailEarkquakeLocationAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
			earthquakeLocationAnnotationView = [[[DetailEarkquakeLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier] autorelease];
		}
	}	
	
	[earthquakeLocationAnnotationView setEnabled:YES];
	
	return earthquakeLocationAnnotationView;
	
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


- (void) startLocation: (id) sender{
	
	NSMutableArray *items = [[toolbar items] mutableCopy];
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];

	UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];


    locateMeButton = nil;

	locateMeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"black.png"] style:UIBarButtonItemStyleDone target:self action:@selector(stopLocation:)];
			
	[items removeObjectAtIndex:2];
	[items insertObject:activityItem atIndex:2];
	[items insertObject:locateMeButton atIndex:3];
	
	[toolbar setItems:items animated:YES];
	
	[items release];
	[activityIndicator release];
    [activityItem release];
	
	NSLog(@"start");
}

- (void) stopLocation: (id) sender {
	
	NSMutableArray *items = [[toolbar items] mutableCopy];
	
	[items removeObjectAtIndex:3];
	[items removeObjectAtIndex:2];
	
	locateMeButton = nil;
	
	locateMeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"black.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(startLocation:)];
	
	[items insertObject:locateMeButton atIndex:2];
	[toolbar setItems:items animated:YES];
	
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
	[earthquakeLocationAnnotationView release];
    [super dealloc];
}

@end
