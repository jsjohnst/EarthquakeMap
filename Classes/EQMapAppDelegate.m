#import "EQMapAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "Earthquake.h"
#import <CFNetwork/CFNetwork.h>


@implementation EQMapAppDelegate

@synthesize window;
@synthesize splitViewController;
@synthesize rootViewController;
@synthesize detailViewController;

@synthesize earthquakeList;
@synthesize earthquakeFeedConnection;
@synthesize earthquakeData;
@synthesize currentEarthquakeObject;
@synthesize currentParsedCharacterData;
@synthesize currentParseBatch;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {

	[window addSubview:splitViewController.view];
	
    self.earthquakeList = [NSMutableArray array];
    rootViewController.earthquakeList = earthquakeList;

	static NSString *feedURLString = @"http://earthquake.usgs.gov/eqcenter/catalogs/7day-M2.5.xml";
    NSURLRequest *earthquakeURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    self.earthquakeFeedConnection = [[[NSURLConnection alloc] initWithRequest:earthquakeURLRequest delegate:self] autorelease];
    
    NSAssert(self.earthquakeFeedConnection != nil, @"Failure to create URL connection.");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}

#pragma mark NSURLConnection delegate methods


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.earthquakeData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [earthquakeData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"No Connection Error", @"Error message displayed when not connected to the Internet.") forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        [self handleError:error];
    }
    self.earthquakeFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.earthquakeFeedConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    [NSThread detachNewThreadSelector:@selector(parseEarthquakeData:) toTarget:self withObject:earthquakeData];
    self.earthquakeData = nil;
}

- (void)parseEarthquakeData:(NSData *)data {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    self.currentParseBatch = [NSMutableArray array];
    self.currentParsedCharacterData = [NSMutableString string];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
	
    if ([self.currentParseBatch count] > 0) {
        [self performSelectorOnMainThread:@selector(addEarthquakesToList:) withObject:self.currentParseBatch waitUntilDone:NO];
    }
    self.currentParseBatch = nil;
    self.currentEarthquakeObject = nil;
    self.currentParsedCharacterData = nil;
    [parser release];        
    [pool release];
}

- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error Title", @"Title for alert displayed when download or parse error occurs.") message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)addEarthquakesToList:(NSArray *)earthquakes {
    [self.earthquakeList addObjectsFromArray:earthquakes];
	if ([self.earthquakeList count] >= 100){
		NSLog(@"count = 100");
		[rootViewController.tableView reloadData];
		[detailViewController loadAllEarthQuakes:earthquakeList];
	}
}


#pragma mark Parser constants

static const const NSUInteger kMaximumNumberOfEarthquakesToParse = 100;

static NSUInteger const kSizeOfEarthquakeBatch = 10;

static NSString * const kEntryElementName = @"entry";
static NSString * const kLinkElementName = @"link";
static NSString * const kTitleElementName = @"title";
static NSString * const kUpdatedElementName = @"updated";
static NSString * const kGeoRSSPointElementName = @"georss:point";

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (parsedEarthquakesCounter >= kMaximumNumberOfEarthquakesToParse) {
        didAbortParsing = YES;
        [parser abortParsing];
    }
    if ([elementName isEqualToString:kEntryElementName]) {
        Earthquake *earthquake = [[[Earthquake alloc] init] autorelease];
        self.currentEarthquakeObject = earthquake;
    } else if ([elementName isEqualToString:kLinkElementName]) {
        NSString *relAttribute = [attributeDict valueForKey:@"rel"];
        if ([relAttribute isEqualToString:@"alternate"]) {
            NSString *USGSWebLink = [attributeDict valueForKey:@"href"];
            static NSString * const kUSGSBaseURL = @"http://earthquake.usgs.gov/";
            self.currentEarthquakeObject.USGSWebLink = [kUSGSBaseURL stringByAppendingString:USGSWebLink];
        }
    } else if ([elementName isEqualToString:kTitleElementName] || [elementName isEqualToString:kUpdatedElementName] || [elementName isEqualToString:kGeoRSSPointElementName]) {
        accumulatingParsedCharacterData = YES;
        [currentParsedCharacterData setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName]) {
        [self.currentParseBatch addObject:self.currentEarthquakeObject];
        parsedEarthquakesCounter++;
        if (parsedEarthquakesCounter % kSizeOfEarthquakeBatch == 0) {
            [self performSelectorOnMainThread:@selector(addEarthquakesToList:) withObject:self.currentParseBatch waitUntilDone:NO];
            self.currentParseBatch = [NSMutableArray array];
        }
    } else if ([elementName isEqualToString:kTitleElementName]) {
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
        [scanner scanString:@"M " intoString:NULL];
        CGFloat magnitude;
        [scanner scanFloat:&magnitude];
        self.currentEarthquakeObject.magnitude = magnitude;
        [scanner scanString:@", " intoString:NULL];
        NSString *location = nil;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet illegalCharacterSet]  intoString:&location];
        self.currentEarthquakeObject.location = location;
    } else if ([elementName isEqualToString:kUpdatedElementName]) {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        self.currentEarthquakeObject.date = [dateFormatter dateFromString:self.currentParsedCharacterData];
    } else if ([elementName isEqualToString:kGeoRSSPointElementName]) {
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParsedCharacterData];
        double latitude, longitude;
        [scanner scanDouble:&latitude];
        [scanner scanDouble:&longitude];
        self.currentEarthquakeObject.latitude = latitude;
        self.currentEarthquakeObject.longitude = longitude;
    }
    accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (accumulatingParsedCharacterData) {
        [self.currentParsedCharacterData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (didAbortParsing == NO) {
        [self performSelectorOnMainThread:@selector(handleError:) withObject:parseError waitUntilDone:NO];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[earthquakeFeedConnection release];
    [earthquakeData release];
    [earthquakeList release];
    [currentEarthquakeObject release];
    [currentParsedCharacterData release];
    [currentParseBatch release];
	
	
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

