
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import "MapUtil.h"

@implementation MapUtil


/** 
 * Attempts to return a region covering all the annotations in the given array.
 * The region has the minimum size to cover the annotations, so zooming may result.
 * Note that because the map is bigger than the display, the region may not cover all annotions.
 * 
 * @param annotations Array of objects conforming to the <MKAnnotation> protocol. Must not be nil or empty.
 */
+(MKCoordinateRegion) regionForAnnotations:(NSArray*) annotations 
{
    NSAssert(annotations!=nil, @"annotations was nil");
    NSAssert([annotations count]!=0, @"annotations was empty");
        
    double minLat=360.0f, maxLat=-360.0f;
    double minLon=360.0f, maxLon=-360.0f;
    
    for (id<MKAnnotation> vu in annotations) {
        if ( vu.coordinate.latitude  < minLat ) minLat = vu.coordinate.latitude;
        if ( vu.coordinate.latitude  > maxLat ) maxLat = vu.coordinate.latitude;
        if ( vu.coordinate.longitude < minLon ) minLon = vu.coordinate.longitude;
        if ( vu.coordinate.longitude > maxLon ) maxLon = vu.coordinate.longitude;
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0, (minLon+maxLon)/2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat-minLat, maxLon-minLon);
    MKCoordinateRegion region = MKCoordinateRegionMake (center, span);
    
    return region;
}


+ (NSArray*) createAnnotationsForVisibleMap:(MKMapView*) mapView
                                     number:(const int) number 
{
    NSMutableArray *randomAnnotations = [[[NSMutableArray alloc] init] autorelease];    
    
    CGRect rect = [mapView convertRegion:mapView.region toRectToView:mapView];
    for(int i=0; i < number; i++) {
        int x = arc4random()%(int)rect.size.width;
        int y = arc4random()%(int)rect.size.height;
        CGPoint point = CGPointMake(x,y); 
        CLLocationCoordinate2D coord = [mapView convertPoint:point toCoordinateFromView:mapView];
        
        Content *content = [Content new];
        content.iconURL = [[NSBundle mainBundle] URLForResource:@"emoji-ghost" withExtension:@"png"];
        //content.calloutView = [CalloutView class];
        content.calloutView = [MyCalloutView class];
        content.coordinate = coord;
        content.values = [NSDictionary dictionaryWithObjectsAndKeys:@"Booo!",@"title", nil];
        
        Annotation *anno = [[Annotation alloc] initWithContent:content];

        //anno.title = [NSString stringWithFormat:@"%d",i];
        anno.mapView = mapView;
        [randomAnnotations addObject:anno];
        [anno release];
    }
    debug(@"returning %d annotations", [randomAnnotations count]);
    return randomAnnotations;
}



/**
 * Return a number of annotations whose coordinates are random points inside the given region minus a 10% border.
 * 
 * @param region A region.
 * @param number The number of annotations to return.
 */
+ (NSArray*) createAnnotationsForRegion:(MKCoordinateRegion) region
                                 number:(const int) number
{
    NSAssert(false, @"for the time being use the other because we need to set mapview on the annotations");
	NSMutableArray *randomAnnotations = [[[NSMutableArray alloc] init] autorelease];    
	
    MKCoordinateSpan span = region.span;
    
	for(int i=0; i < number; i++) 
    {
        CLLocationCoordinate2D randomCoord = { 0,0 };
        
        // set the coordinate on a corner of the current region
        randomCoord.longitude = region.center.longitude - span.longitudeDelta/2; 
        randomCoord.latitude = region.center.latitude - span.latitudeDelta/2;
        
        // We leave a 10% border, 
        // so the pin height fits when placed at the highest,
        // and doesn't cover the Google logo when placed at the lowest.
        float lo = (arc4random()%800000)/1000000. + .1; // [.1, .899999] 
        float la = (arc4random()%800000)/1000000.; // [.0, .899999]
        
        // add the width/height of the current region
        randomCoord.longitude += span.longitudeDelta * lo;
        randomCoord.latitude  += span.latitudeDelta  * la;
        
        Content *content = [Content new];
        content.iconURL = [[NSBundle mainBundle] URLForResource:@"emoji-ghost" withExtension:@"png"];
        // content.calloutView = [CalloutView class];
        content.calloutView = [MyCalloutView class];
        content.coordinate = randomCoord;
        content.values = [NSDictionary dictionaryWithObjectsAndKeys:@"Booo!",@"title", nil];
        Annotation *anno = [[Annotation alloc] initWithContent:content];
        
		[randomAnnotations addObject:anno];
		[anno release];
	}

 	return randomAnnotations;
}


@end
