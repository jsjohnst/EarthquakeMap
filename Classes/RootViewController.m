//
//  RootViewController.m
//  EQMap
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright Cal Poly Pomona 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "EQMapAppDelegate.h"
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

- (UIImage *)imageForMagnitude:(CGFloat)magnitude {	
	if (magnitude >= 5.0) {
		return [UIImage imageNamed:@"5.0.png"];
	}
	if (magnitude >= 4.0) {
		return [UIImage imageNamed:@"4.0.png"];
	}
	if (magnitude >= 3.0) {
		return [UIImage imageNamed:@"3.0.png"];
	}
	if (magnitude >= 2.0) {
		return [UIImage imageNamed:@"2.0.png"];
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [earthquakeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Each subview in the cell will be identified by a unique tag.
    static NSUInteger const kLocationLabelTag = 2;
    static NSUInteger const kDateLabelTag = 3;
    static NSUInteger const kMagnitudeLabelTag = 4;
    static NSUInteger const kMagnitudeImageTag = 5;
    
    // Declare references to the subviews which will display the earthquake data.
    UILabel *locationLabel = nil;
    UILabel *dateLabel = nil;
    UILabel *magnitudeLabel = nil;
    UIImageView *magnitudeImage = nil;
    
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
        
        magnitudeImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.0.png"]] autorelease];
        CGRect imageFrame = magnitudeImage.frame;
        imageFrame.origin = CGPointMake(180, 2);
        magnitudeImage.frame = imageFrame;
        magnitudeImage.tag = kMagnitudeImageTag;
        magnitudeImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview:magnitudeImage];
    } else {
        // A reusable cell was available, so we just need to get a reference to the subviews using their tags.
        locationLabel = (UILabel *)[cell.contentView viewWithTag:kLocationLabelTag];
        dateLabel = (UILabel *)[cell.contentView viewWithTag:kDateLabelTag];
        magnitudeLabel = (UILabel *)[cell.contentView viewWithTag:kMagnitudeLabelTag];
        magnitudeImage = (UIImageView *)[cell.contentView viewWithTag:kMagnitudeImageTag];
    }
    
    // Get the specific earthquake for this row.
	Earthquake *earthquake = [earthquakeList objectAtIndex:indexPath.row];
    
    // Set the relevant data for each subview in the cell.
    locationLabel.text = earthquake.location;
    dateLabel.text = [self.dateFormatter stringFromDate:earthquake.date];
    magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", earthquake.magnitude];
    magnitudeImage.image = [self imageForMagnitude:earthquake.magnitude];
	
	return cell;
}

// When the user taps a row in the table, display the USGS web page that displays details of the earthquake they selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"External App Sheet Title", @"Title for sheet displayed with options for displaying Earthquake data in other applications") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Show USGS Site in Safari", @"Show USGS Site in Safari"), NSLocalizedString(@"Show Location in Maps", @"Show Location in Maps"), nil];
    [sheet showInView:self.view];
    [sheet release];
}

// Called when the user selects an option in the sheet. The sheet will automatically be dismissed.
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    Earthquake *earthquake = (Earthquake *)[earthquakeList objectAtIndex:selectedIndexPath.row];
    switch (buttonIndex) {
        case 0: {
            NSString *webLink = [earthquake USGSWebLink];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webLink]];
        } break;
        case 1: {
            static NSString * const kMapsBaseURL = @"http://maps.google.com/maps?";
            NSString *mapsQuery = [NSString stringWithFormat:@"z=6&t=h&ll=%f,%f", earthquake.latitude, earthquake.longitude];
            mapsQuery = [mapsQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *mapsURLString = [kMapsBaseURL stringByAppendingString:mapsQuery];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapsURLString]];
        } break;
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
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

