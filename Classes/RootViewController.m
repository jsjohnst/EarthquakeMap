//
//  RootViewController.m
//  EQMap
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright Cal Poly Pomona 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Earthquake.h"


@implementation RootViewController

@synthesize detailViewController;
@synthesize earthquakeList;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = 48.0;
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return dateFormatter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [earthquakeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Each subview in the cell will be identified by a unique tag.
    static NSUInteger const kLocationLabelTag = 2;
    static NSUInteger const kDateLabelTag = 3;
    static NSUInteger const kMagnitudeLabelTag = 4;
    
    // Declare references to the subviews which will display the earthquake data.
    UILabel *locationLabel = nil;
    UILabel *dateLabel = nil;
    UILabel *magnitudeLabel = nil;
    
	static NSString *kEarthquakeCellID = @"EarthquakeCellID";    
  	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEarthquakeCellID];
	if (cell == nil) {
        // No reusable cell was available, so we create a new cell and configure its subviews.
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEarthquakeCellID] autorelease];
        
        locationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, 190, 20)] autorelease];
        locationLabel.tag = kLocationLabelTag;
        locationLabel.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:locationLabel];
        
        dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 28, 170, 14)] autorelease];
        dateLabel.tag = kDateLabelTag;
        dateLabel.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:dateLabel];
		
        magnitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(277, 9, 170, 29)] autorelease];
        magnitudeLabel.tag = kMagnitudeLabelTag;
        magnitudeLabel.font = [UIFont boldSystemFontOfSize:24];
        magnitudeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview:magnitudeLabel];
        
    } //else {
//        // A reusable cell was available, so we just need to get a reference to the subviews using their tags.
//        locationLabel = (UILabel *)[cell.contentView viewWithTag:kLocationLabelTag];
//        dateLabel = (UILabel *)[cell.contentView viewWithTag:kDateLabelTag];
//        magnitudeLabel = (UILabel *)[cell.contentView viewWithTag:kMagnitudeLabelTag];
//    }
    
    // Get the specific earthquake for this row.
	Earthquake *earthquake = [earthquakeList objectAtIndex:indexPath.row];
    
    // Set the relevant data for each subview in the cell.
    locationLabel.text = earthquake.location;
    dateLabel.text = [self.dateFormatter stringFromDate:earthquake.date];
    magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", earthquake.magnitude];
	
	return cell;
}

// When the user taps a row in the table, display the USGS web page that displays details of the earthquake they selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	detailViewController.detailItem = [self.earthquakeList objectAtIndex: indexPath.row];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[earthquakeList release];
	[dateFormatter release];
    [detailViewController release];
    [super dealloc];
}


@end

