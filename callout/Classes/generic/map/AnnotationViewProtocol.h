
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>

/**
 * Handles (de)selection of the view.
 *
 * Called from the map delegate at methods
 * mapView:didSelectAnnotationView: and mapView:didDeselectAnnotationView:.
 */
@protocol AnnotationViewProtocol <NSObject>

/** Called from the map delegate when the annotation is selected. */
- (void) didSelectAnnotationViewInMap:(MKMapView*) mapView;

/** Called from the map delegate when the annotation is deselected. */
- (void) didDeselectAnnotationViewInMap:(MKMapView*) mapView;

@end
