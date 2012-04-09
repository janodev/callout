
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "BaseCalloutView.h"

@class CalloutAnnotation;

@interface CalloutView : BaseCalloutView 

-(IBAction) handleTouch:(id)sender;
- (id)initWithAnnotation:(CalloutAnnotation*)annotation;

@end
