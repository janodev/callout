
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "Content.h"
#import "MyCalloutView.h"


/** 
 * Util methods. 
 * Not related to the creation of a custom callout. 
 */
@interface MapUtil : NSObject

+(MKCoordinateRegion) regionForAnnotations:(NSArray*) annotations;

+(NSArray*) createAnnotationsForRegion:(MKCoordinateRegion) region
                                 number:(const int) number;

+ (NSArray*) createAnnotationsForVisibleMap:(MKMapView*) mapView
                                     number:(const int) number;

@end
