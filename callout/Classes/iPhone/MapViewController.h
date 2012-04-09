
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "MapUtil.h"
#import "AnnotationView.h"
#import "AnnotationViewProtocol.h"
#import "AnnotationProtocol.h"


@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic,retain) IBOutlet MKMapView *mapView;

-(IBAction) leftButton:(id)sender;

@end
