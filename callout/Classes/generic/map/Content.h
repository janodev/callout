
// Several authors. Based on code by Asynchrony Solutions.
// See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

#import <MapKit/MapKit.h>

@interface Content : NSObject

@property (nonatomic,retain) NSURL *iconURL;       // local or remote URL of the icon
@property (nonatomic,assign) Class calloutView;    // callout view class
@property (nonatomic,retain) NSDictionary *values; // values to be applied on the calloutView instance
@property (nonatomic,assign) CLLocationCoordinate2D coordinate; // point of the annotation in the map

@end
