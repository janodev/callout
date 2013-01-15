
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AnnotationViewProtocol.h"

@interface BaseCalloutView : MKAnnotationView <AnnotationViewProtocol>
{
	MKAnnotationView *_parentAnnotationView;
	MKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
}

@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *contentView;

- (void) animateIn;
- (void) animateInStepTwo;
- (void) animateInStepThree;
- (id)   initWithAnnotation:(id<MKAnnotation>)annotation;

@end
