//
//  DetailViewController.m
//  asdf
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright Cal Poly Pomona 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "Earthquake.h"
#import "EarthquakeLocationAnnotation.h"

@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem;

#pragma mark -
#pragma mark Managing the detail item

- (void) loadAllEarthQuakes:(NSArray *) earthquakeList {
	
	EarthquakeLocationAnnotation *earthquakeAnnotation;
	
	for (Earthquake *earthquake in earthquakeList) {
		
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		
		span.latitudeDelta=0.5;
		span.longitudeDelta=0.5;
		
		CLLocationCoordinate2D location;
		location.latitude = earthquake.latitude;
		location.longitude = earthquake.longitude;
	
		
		region.span = span;
		region.center = location;
		
		
	    earthquakeAnnotation = [[[EarthquakeLocationAnnotation alloc] initWithCoordinate: location] autorelease];
		[earthquakeAnnotation setMTitle:detailItem.location];
		[earthquakeAnnotation setMSubTitle:[NSString stringWithFormat:@"%.1f", detailItem.magnitude]];
		
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


-(CLLocationCoordinate2D) earthquakeLocation {
	
    CLLocationCoordinate2D location;
    location.latitude = detailItem.latitude;
    location.longitude = detailItem.longitude;
	
    return location;
}

- (void)configureView {
	
	[mapView removeAnnotations:mapView.annotations];

	EarthquakeLocationAnnotation *earthquakeAnnotation;

	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta=0.5;
	span.longitudeDelta=0.5;
	
	CLLocationCoordinate2D earthquakeLocation = [self earthquakeLocation];
	
	region.span = span;
	region.center = earthquakeLocation;
	
//	if(earthquakeAnnotation != nil) {
////		[mapView removeAnnotation:earthquakeAnnotation];
//		NSLog(@"got here");
////		[earthquakeAnnotation release];
//	}
	
	earthquakeAnnotation = [[[EarthquakeLocationAnnotation alloc] initWithCoordinate: earthquakeLocation] autorelease];
	[earthquakeAnnotation setMTitle:detailItem.location];
	[earthquakeAnnotation setMSubTitle:[NSString stringWithFormat:@"%.1f", detailItem.magnitude]];
	
	[mapView addAnnotation:earthquakeAnnotation];
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
	[earthquakeAnnotation release];
}




#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
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
// - (void)viewDidLoad {
//	 [super viewDidLoad];
// }

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

- (void)dealloc {
//    [popoverController release];
//    [toolbar release];
//    
//    [detailItem release];
//	
//	[mapView release];
	
    [super dealloc];
}

@end
