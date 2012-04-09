
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseCalloutView.h"

#define CalloutMapAnnotationViewBottomShadowBufferSize 6.0f
#define CalloutMapAnnotationViewContentHeightBuffer 8.0f
#define CalloutMapAnnotationViewHeightAboveParent 13.0f
#define CalloutMapAnnotationViewInset 4.0f


@interface BaseCalloutView()

@property (nonatomic, readonly) CGFloat yShadowOffset;
@property (nonatomic) BOOL animateOnNextDrawRect;
@property (nonatomic) CGRect endFrame;

- (void)prepareFrameSize;
- (void)prepareOffset;
- (CGFloat)relativeParentXPosition;
- (void)adjustMapRegionIfNeeded;

@end


@implementation BaseCalloutView

@synthesize parentAnnotationView = _parentAnnotationView;
@synthesize mapView = _mapView;
@synthesize contentView = _contentView;
@synthesize animateOnNextDrawRect = _animateOnNextDrawRect;
@synthesize endFrame = _endFrame;
@synthesize yShadowOffset = _yShadowOffset;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;
{
    [NSException raise:NSInternalInconsistencyException 
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
		self.enabled = NO;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation {
	[super setAnnotation:annotation];
	[self prepareFrameSize];
	[self prepareOffset];
	[self setNeedsDisplay];
}

- (void)setAnnotationAndAdjustMap:(id <MKAnnotation>)annotation {
	[super setAnnotation:annotation];
	[self prepareFrameSize];
	[self prepareOffset];
	[self adjustMapRegionIfNeeded];
	[self setNeedsDisplay];
}
 
- (void)prepareFrameSize {
	CGRect frame = self.frame;
	CGFloat height = self.contentView.frame.size.height +
	CalloutMapAnnotationViewContentHeightBuffer +
	CalloutMapAnnotationViewBottomShadowBufferSize + 14 + (2*CalloutMapAnnotationViewInset);
	
	frame.size = CGSizeMake(self.contentView.frame.size.width + 14 + (2*CalloutMapAnnotationViewInset), height);
	self.frame = frame;
}

- (void)prepareOffset {
	CGFloat xOffset = 0;
	
	//Add half our height plus half of the height of the annotation we are tied to so that our bottom lines up to its top
	//Then take into account its offset and the extra space needed for our drop shadow
	CGFloat yOffset = -(self.frame.size.height / 2 + 
						self.parentAnnotationView.frame.size.height / 2) - CalloutMapAnnotationViewHeightAboveParent;
	
	self.centerOffset = CGPointMake(xOffset, yOffset);
}

//if the pin is too close to the edge of the map view we need to shift the map view so the callout will fit.
- (void)adjustMapRegionIfNeeded {
	//Longitude
	CGFloat xPixelShift = 0;
	if ([self relativeParentXPosition] < 38) {
		xPixelShift = 38 - [self relativeParentXPosition];
	} else if ([self relativeParentXPosition] > self.frame.size.width - 38) {
		xPixelShift = (self.frame.size.width - 38) - [self relativeParentXPosition];
	}
	
	
	//Latitude
	CGPoint mapViewOriginRelativeToParent = [self.mapView convertPoint:self.mapView.frame.origin toView:self.parentAnnotationView];
	CGFloat yPixelShift = 0;
	CGFloat pixelsFromTopOfMapView = -(mapViewOriginRelativeToParent.y + self.frame.size.height - CalloutMapAnnotationViewBottomShadowBufferSize);
	CGFloat pixelsFromBottomOfMapView = self.mapView.frame.size.height + mapViewOriginRelativeToParent.y - self.parentAnnotationView.frame.size.height;
	if (pixelsFromTopOfMapView < 7) {
		yPixelShift = 7 - pixelsFromTopOfMapView;
	} else if (pixelsFromBottomOfMapView < 10) {
		yPixelShift = -(10 - pixelsFromBottomOfMapView);
	}
	
	//Calculate new center point, if needed
	if (xPixelShift || yPixelShift) {
		CGFloat pixelsPerDegreeLongitude = self.mapView.frame.size.width / self.mapView.region.span.longitudeDelta;
		CGFloat pixelsPerDegreeLatitude = self.mapView.frame.size.height / self.mapView.region.span.latitudeDelta;
		
		CLLocationDegrees longitudinalShift = -(xPixelShift / pixelsPerDegreeLongitude);
		CLLocationDegrees latitudinalShift = yPixelShift / pixelsPerDegreeLatitude;
		
		CLLocationCoordinate2D newCenterCoordinate = {self.mapView.region.center.latitude + latitudinalShift, 
			self.mapView.region.center.longitude + longitudinalShift};
		
		[self.mapView setCenterCoordinate:newCenterCoordinate animated:YES];
		
		//fix for now
		self.frame = CGRectMake(self.frame.origin.x - xPixelShift,
								self.frame.origin.y - yPixelShift,
								self.frame.size.width, 
								self.frame.size.height);
		//fix for later (after zoom or other action that resets the frame)
		self.centerOffset = CGPointMake(self.centerOffset.x - xPixelShift, self.centerOffset.y);
	}
}

- (CGFloat)xTransformForScale:(CGFloat)scale {
	CGFloat xDistanceFromCenterToParent = self.endFrame.size.width / 2 - [self relativeParentXPosition];
	return (xDistanceFromCenterToParent * scale) - xDistanceFromCenterToParent;
}

- (CGFloat)yTransformForScale:(CGFloat)scale {
	CGFloat yDistanceFromCenterToParent = (((self.endFrame.size.height) / 2) + CalloutMapAnnotationViewBottomShadowBufferSize + CalloutMapAnnotationViewHeightAboveParent);
	return yDistanceFromCenterToParent - yDistanceFromCenterToParent * scale;
}

- (void)animateIn {
	self.endFrame = self.frame;
	CGFloat scale = 0.001f;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	[UIView beginAnimations:@"animateIn" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.075];
	[UIView setAnimationDidStopSelector:@selector(animateInStepTwo)];
	[UIView setAnimationDelegate:self];
	scale = 1.1;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	[UIView commitAnimations];
}

- (void)animateInStepTwo {
	[UIView beginAnimations:@"animateInStepTwo" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDidStopSelector:@selector(animateInStepThree)];
	[UIView setAnimationDelegate:self];
	
	CGFloat scale = 0.95;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	
	[UIView commitAnimations];
}

- (void)animateInStepThree {
	[UIView beginAnimations:@"animateInStepThree" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.075];
	
	CGFloat scale = 1.0;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
	
	[UIView commitAnimations];
}


- (void)didMoveToSuperview {
	[self adjustMapRegionIfNeeded];
	[self animateIn];
}

- (void)drawRect:(CGRect)rect {
	CGFloat stroke = 1.0;
	CGFloat radius = 7.0;
	CGMutablePathRef path = CGPathCreateMutable();
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat parentX = [self relativeParentXPosition];
	
	//Determine Size
	rect = self.bounds;
	rect.size.width -= stroke + 14;
	rect.size.height -= stroke + 14 + CalloutMapAnnotationViewHeightAboveParent;
	rect.origin.x += stroke / 2.0 + 7;
	rect.origin.y += stroke / 2.0 + 7;
    
	//Create Path For Callout Bubble
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 15, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 15);
	CGPathAddLineToPoint(path, NULL, parentX + 15, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(path);
	
	//Fill Callout Bubble & Add Shadow
	color = [[UIColor blackColor] colorWithAlphaComponent:.6];
	[color setFill];
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	//Stroke Callout Bubble
	color = [[UIColor darkGrayColor] colorWithAlphaComponent:.9];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	
	//Determine Size for Gloss
	CGRect glossRect = self.bounds;
	glossRect.size.width = rect.size.width - stroke;
	glossRect.size.height = (rect.size.height - stroke) / 2;
	glossRect.origin.x = rect.origin.x + stroke / 2;
	glossRect.origin.y += rect.origin.y + stroke / 2;
	
	CGFloat glossTopRadius = radius - stroke / 2;
	CGFloat glossBottomRadius = radius / 1.5;
	
	//Create Path For Gloss
	CGMutablePathRef glossPath = CGPathCreateMutable();
	CGPathMoveToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossTopRadius);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossRect.size.height - glossBottomRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI, M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, glossRect.origin.y + glossRect.size.height);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI / 2, 0.0f, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width, glossRect.origin.y + glossTopRadius);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius, 0.0f, -M_PI / 2, 1);
	CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y);
	CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius, -M_PI / 2, M_PI, 1);
	CGPathCloseSubpath(glossPath);
	
	//Fill Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	CGFloat colors[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
	};
	CGFloat locations[] = { 0, 1.0 };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, 2);
	CGPoint startPoint = glossRect.origin;
	CGPoint endPoint = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	
	//Gradient Stroke Gloss Path	
	CGContextAddPath(context, glossPath);
	CGContextSetLineWidth(context, 2);
	CGContextReplacePathWithStrokedPath(context);
	CGContextClip(context);
	CGFloat colors2[] =
	{
		1, 1, 1, .3,
		1, 1, 1, .1,
		1, 1, 1, .0,
	};
	CGFloat locations2[] = { 0, .1, 1.0 };
	CGGradientRef gradient2 = CGGradientCreateWithColorComponents(space, colors2, locations2, 3);
	CGPoint startPoint2 = glossRect.origin;
	CGPoint endPoint2 = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
	CGContextDrawLinearGradient(context, gradient2, startPoint2, endPoint2, 0);
	
	//Cleanup
	CGPathRelease(path);
	CGPathRelease(glossPath);
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
	CGGradientRelease(gradient2);
}

- (CGFloat)yShadowOffset {
	if (!_yShadowOffset) {
		float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (osVersion >= 3.2) {
			_yShadowOffset = 6;
		} else {
			_yShadowOffset = -6;
		}
		
	}
	return _yShadowOffset;
}

- (CGFloat)relativeParentXPosition {
	return self.bounds.size.width / 2;
}

- (void)dealloc {
    [_parentAnnotationView release];
    _parentAnnotationView = nil;
    [_mapView release];
    _mapView = nil;
	[_contentView release];
    _contentView = nil;
    [super dealloc];
}

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView
{
    
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView
{

}

- (void)setContentView:(UIView *)newContentView
{
    UIView* oldView = _contentView;
    [newContentView retain];
    _contentView = newContentView;

    [oldView removeFromSuperview];
    [oldView release];
    
    [self addSubview:newContentView];
    newContentView.transform = CGAffineTransformMakeTranslation(7 + CalloutMapAnnotationViewInset, 7 +CalloutMapAnnotationViewInset);
}

@end