
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window=_window;

#pragma mark - UIApplicationDelegate

// 1st called on start
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self.window makeKeyAndVisible];
    return YES;
}

// 2nd called on START
// 2nd called when pressing HOME
- (void)applicationDidBecomeActive:     (UIApplication *)application {}

// 1st called when pressing HOME
- (void)applicationWillResignActive:    (UIApplication *)application {}

// 2nd called when pressing HOME
- (void)applicationDidEnterBackground:  (UIApplication *)application {}

// 1st called when coming back from HOME
- (void)applicationWillEnterForeground: (UIApplication *)application {}

// called before application EXIT due to a call or being killed by iOS
- (void)applicationWillTerminate:       (UIApplication *)application {}

#pragma mark - Instance lifecycle

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end