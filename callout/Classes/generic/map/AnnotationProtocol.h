
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>

@protocol AnnotationProtocol <MKAnnotation>

/** Returns a view for the annotation. */
-(MKAnnotationView*) annotationViewInMap:(MKMapView*)mapView;

@end
