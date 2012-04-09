
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>
#import "AnnotationViewProtocol.h"
#import "CalloutAnnotation.h"

@class Annotation;

/**
 * Annotation conforming to AnnotationViewProtocol.
 *
 * An annotation implementing AnnotationViewProtocol may act as a 
 * delegate for annotation selection/deselection. The implementation
 * in this class creates/removes an annotation that emulates a callout 
 * bubble.
 */
@interface AnnotationView : MKAnnotationView <AnnotationViewProtocol>

// A CalloutAnnotation is a MKAnnotationView that emulates the aspect
// of a callout bubble.
@property (nonatomic,retain) CalloutAnnotation *calloutAnnotation;

// MKAnnotationView's initWithAnnotation:reuseIdentifier:
- (id)initWithAnnotation:(Annotation*)annotation;

@end
