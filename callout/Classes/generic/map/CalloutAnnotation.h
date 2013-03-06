
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>
#import "CalloutView.h"
#import "AnnotationProtocol.h"
#import "Content.h"

@class AnnotationView;

/**
 * This object is created and added to the map at AnnotationView's didSelectAnnotationViewInMap:.
 */
@interface CalloutAnnotation : NSObject <MKAnnotation, AnnotationProtocol>

@property (nonatomic, retain) BaseCalloutView* calloutView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) AnnotationView* parentAnnotationView;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) Content* content;
@property (nonatomic, assign) BOOL centerMapWhenSelected;

- (id) initWithContent:(Content*)content;

@end