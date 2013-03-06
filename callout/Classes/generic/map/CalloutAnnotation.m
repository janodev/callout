
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>
#import "AnnotationView.h"


@implementation CalloutAnnotation

@synthesize parentAnnotationView = _parentAnnotationView;
@synthesize mapView = _mapView;
@synthesize content = _content;
@synthesize coordinate = _coordinate;
@synthesize calloutView = _calloutView;
@synthesize centerMapWhenSelected = _centerMapWhenSelected;


- (MKAnnotationView*)annotationViewInMap:(MKMapView *)mapView;
{
    Class calloutViewClass = self.content.calloutView;
    
    // dequeue or create a MKAnnotationView
    if (self.calloutView==nil) {
        NSString *identifier = NSStringFromClass(calloutViewClass);
        self.calloutView = [(BaseCalloutView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier] retain];
        if (self.calloutView==nil)
            self.calloutView = [[calloutViewClass alloc] initWithAnnotation:self];
    } else {
        self.calloutView.annotation = self;
    }
    self.calloutView.parentAnnotationView = self.parentAnnotationView;

    if (_centerMapWhenSelected) {
        [mapView setCenterCoordinate:self.coordinate animated:YES];
    }

    return self.calloutView;
}


#pragma mark - accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
    if (self.calloutView) {
        [self.calloutView setAnnotation:self];
    }
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}


#pragma mark - NSObject

/** Init with a coordinate. */
- (id) initWithContent:(Content*)content {
    self = [super init];
    if (self){
        self.content = content;
        self.coordinate = content.coordinate;
        self.calloutView = nil;
        self.centerMapWhenSelected = NO;
    }
    return self;
}


- (void)dealloc {
    self.calloutView = nil;
    self.content = nil;
    [super dealloc];
}

@end
