#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	
	NSArray *earthquakeList;
	NSDateFormatter *dateFormatter;
	
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSArray *earthquakeList;
@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;

@end
