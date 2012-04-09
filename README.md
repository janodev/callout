# Annotations with custom callouts

Based on code by Asynchrony Solutions and several authors.  
See http://stackoverflow.com/questions/8018841/customize-the-mkannotationview-callout/8019308#8019308

![XIB based annotation](https://github.com/j4n0/callout/raw/master/callout/pages/screenshot.png)

## Strategy

We can't create a XIB backed callout, but we can create an annotation with a completely customized view.
So the trick is to add a second annotation when the first is selected, and make the 2nd annotation view
look like a callout bubble.
 
![Class diagram](https://github.com/j4n0/callout/raw/master/callout/pages/class-diagram.png)

What we see in this image is:

  - AnnotationProtocol: protocol to implement by annotations who wish to handle view creation themselves.
  - AnnotationViewProtocol: protocol to implement by annotations who wish to handle view selection themselves.
  - Annotation & AnnotationView: the real annotation.
  - CalloutAnnotation & CalloutAnnotationView: the fake callout bubble.
  - BaseCalloutView: MKAnnotationView.
  - Content: This class is passed along with the final data to create the callout.

To add an annotation to the map:

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(0.,0.);
    Annotation *ann = [[Annotation alloc]initWithCoordinate:coord]
    [self.mapView addAnnotation:ann];

After adding an annotation, the MKMapViewDelegate is invoked,
which in turn delegates the view creation to the annotation itself.

    -[MKMapViewDelegate mapView:viewForAnnotation:]
      -[Annotation annotationViewInMap] // view creation is delegated to the annotation
        -[AnnotationView initWithAnnotation:reuseIdentifier:] // the view is initialized with the annotation

Now we have a map with a Annotation and AnnotationView on it.
Touching the annotation view calls MKMapViewDelegate, which in turn delegates the selection to the view.
The view creates a CalloutAnnotation and adds it to the map.

    -[MKMapViewDelegate mapView:didSelectAnnotationView:]
      -[AnnotationView didSelectAnnotationViewInMap:]
        -[CalloutAnnotation initWithLat:lon:]


Now we have the same thing, the view creation is delegated to CalloutAnnotation,
which creates a CalloutAnnotationView, which uses Core Graphics to create a callout bubble.

CalloutView has a CalloutView.XIB. The code to paint the bubble around the XIB is in the 
superclass BaseCalloutView.


## Classes

    AnnotationProtocol
      annotationViewInMap:
    
    AnnotationViewProtocol
      didSelectAnnotationViewInMap:
      didDeselectAnnotationViewInMap:
    
    Annotation        : NSObject         <MKAnnotation, AnnotationProtocol>
    AnnotationView    : MKAnnotationView <AnnotationViewProtocol>
    BaseCalloutView   : MKAnnotationView <AnnotationViewProtocol>
    CalloutAnnotation : NSObject         <MKAnnotation, AnnotationProtocol>
    CalloutView       : BaseCalloutView 


### Behavior

![Sequence diagram](https://github.com/j4n0/callout/raw/master/callout/pages/class-sequence.png)

    Annotation        --(added)creates-->    AnnotationView      (the pin)
    AnnotationView    --(selected)creates--> CalloutAnnotation   (the annotation acting as delegate to create the bubble)
    CalloutAnnotation --(added)creates-->    CalloutView         (the bubble)
    CalloutView       --paints-->            <fake callout>      (the bubble painting code)


## Usage

To create an annotation:

    Content *content = [Content new];
    content.iconURL = [[NSBundle mainBundle] URLForResource:@"emoji-ghost" withExtension:@"png"];
    content.calloutView = [MyCalloutView class];
    content.coordinate = coord;
    content.values = [NSDictionary dictionaryWithObjectsAndKeys:@"Booo!",@"title", nil];
    Annotation *anno = [[Annotation alloc] initWithContent:content];

Then on MyCalloutView:

    #import "CalloutView.h"
    #import "CalloutAnnotation.h"
    @interface MyCalloutView : CalloutView
    @property (nonatomic, retain) IBOutlet UILabel* title;
    -(IBAction) handleTouch:(id)sender;
    - (id) initWithAnnotation:(CalloutAnnotation*)annotation;
    @end
    
    #import "MyCalloutView.h"
    @implementation MyCalloutView
    @synthesize title = _title;
    -(IBAction) handleTouch:(id)sender {
        debug(@"touch %@", sender);
    }
    - (id)initWithAnnotation:(CalloutAnnotation*)annotation {
        self = [super initWithAnnotation:annotation];
        self.title.text = [annotation.content.values objectForKey:@"title"];
        return self;
    }
    - (void)dealloc {
        self.title = nil;
        [super dealloc];
    }
    @end
