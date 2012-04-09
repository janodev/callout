
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "Content.h"

@implementation Content

@synthesize iconURL     = _iconURL;
@synthesize calloutView = _calloutView;
@synthesize values      = _values;
@synthesize coordinate  = _coordinate;

-(void) dealloc {
    self.iconURL = nil;
    self.values = nil;
    [super dealloc];
}

@end
