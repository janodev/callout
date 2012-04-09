
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "MyCalloutView.h"


@implementation MyCalloutView

@synthesize title = _title;


-(IBAction) handleTouch:(id)sender {
    debug(@"touch %@", sender);
}


- (id)initWithAnnotation:(CalloutAnnotation*)annotation {
    self = [super initWithAnnotation:annotation];
    self.title.text = [annotation.content.values objectForKey:@"title"];
    return self;
}
    
    
#pragma mark - NSObject

- (void)dealloc {
    self.title = nil;
    [super dealloc];
}


@end
