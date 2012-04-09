
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "AppDelegateiPhone.h"

@implementation AppDelegateiPhone

@synthesize mapVC = _mapVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    self.window.rootViewController = self.mapVC;
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


- (void)dealloc {
	[super dealloc];
}


@end
