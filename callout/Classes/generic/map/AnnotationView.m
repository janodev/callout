
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "AnnotationView.h"
#import "Annotation.h"


@implementation AnnotationView

@synthesize calloutAnnotation = _calloutAnnotation;


// MKAnnotationView's initWithAnnotation:reuseIdentifier:
- (id)initWithAnnotation:(Annotation*)annotation 
         reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self!=nil){
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(10, -16);
        self.draggable = NO;
        //self.image = [UIImage imageNamed:@"emoji-ghost.png"];
        
        NSData *data = [NSData dataWithContentsOfURL:annotation.content.iconURL];
        self.image = [UIImage imageWithData:data];
        
    }
    return self;
}


// Calls initWithAnnotation:reuseIdentifier: with a default identifier.
- (id)initWithAnnotation:(Annotation*)annotation
{
    return [self initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
}


// MKAnnotationView's annotation property
- (void)setAnnotation:(id<MKAnnotation>)annotation
{
    if(self.calloutAnnotation) {
        [self.calloutAnnotation setCoordinate:annotation.coordinate];
    }    
    [super setAnnotation:annotation];
}


#pragma mark - AnnotationViewProtocol


/** Create and show the CalloutAnnotation that emulates the callout. */
- (void)didSelectAnnotationViewInMap:(MKMapView*) mapView;
{
    // hack that fixes bug in iOS 6 where an animation interrupts other animations
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        Annotation *annotation = (Annotation*)self.annotation;
        self.calloutAnnotation = [[CalloutAnnotation alloc] initWithContent:annotation.content];
        self.calloutAnnotation.parentAnnotationView = self;
        [mapView addAnnotation:self.calloutAnnotation];
        [self.calloutAnnotation release];
    });
}


/** Remove the CalloutAnnotation. */
- (void)didDeselectAnnotationViewInMap:(MKMapView*) mapView;
{
    [mapView removeAnnotation:self.calloutAnnotation];
    self.calloutAnnotation = nil;
}


@end
