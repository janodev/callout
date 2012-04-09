
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>
#import "AnnotationProtocol.h"
#import "AnnotationView.h"
#import "CalloutView.h"
#import "Content.h"


@interface Annotation : NSObject <MKAnnotation, AnnotationProtocol>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) AnnotationView *annotationView;
@property (nonatomic,retain) MKMapView* mapView;
@property (nonatomic,retain) Content* content;

-(id) initWithContent:(Content*)content;

@end
