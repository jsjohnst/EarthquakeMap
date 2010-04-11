//
//  EQMapAppDelegate.h
//  EQMap
//
//  Created by Matt Christiansen on 4/10/10.
//  Copyright Cal Poly Pomona 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RootViewController;
@class DetailViewController;
@class Earthquake;

@interface EQMapAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
	
	NSMutableArray *earthquakeList;
	
	NSURLConnection *earthquakeFeedConnection;
	NSMutableData *earthquakeData;
	
	Earthquake *currentEarthquakeObject;
	NSMutableArray *currentParseBatch;
	NSUInteger parsedEarthquakesCounter;
	NSMutableString *currentParsedCharacterData;
	
	BOOL accumulatingParsedCharacterData;
	BOOL didAbortParsing;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray *earthquakeList;

@property (nonatomic, retain) NSURLConnection *earthquakeFeedConnection;
@property (nonatomic, retain) NSMutableData *earthquakeData;

@property (nonatomic, retain) Earthquake *currentEarthquakeObject;
@property (nonatomic, retain) NSMutableString *currentParsedCharacterData;
@property (nonatomic, retain) NSMutableArray *currentParseBatch;

- (void)addEarthquakesToList:(NSArray *)earthquakes;
- (void)handleError:(NSError *)error;

@end
