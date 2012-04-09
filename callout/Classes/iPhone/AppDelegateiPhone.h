
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MapViewController.h"


/** 
 * Delegate. 
 * Sets MapViewController as the window's root view controller. 
 */
@interface AppDelegateiPhone : AppDelegate

@property (nonatomic,retain) IBOutlet MapViewController *mapVC;

@end
