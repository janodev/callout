
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "CalloutView.h"
#import "CalloutAnnotation.h"


@implementation CalloutView

-(IBAction) handleTouch:(id)sender {
    debug(@"touch %@", sender);
}
                                    

- (id)initWithAnnotation:(CalloutAnnotation*)annotation
{
    NSString *identifier = NSStringFromClass([self class]);
    self = [super initWithAnnotation:annotation reuseIdentifier:identifier];
    if (self!=nil){    
        // prevent the tap and double tap from reaching views underneath
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        UITapGestureRecognizer *doubletapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch:)];
        doubletapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubletapGestureRecognizer];
    }
    
    return self;
}



- (void)dealloc {
    [super dealloc];
}


// fixes bug in iOS 6 that displays custom annotations behind map annotations
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.superview bringSubviewToFront:self];
}

@end
