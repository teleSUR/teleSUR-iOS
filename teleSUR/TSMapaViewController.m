//
//  TSMapaViewController.m
//  teleSUR
//
//  Created by Hector Zarate on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSMapaViewController.h"
#import "TSClipListadoViewController.h"
#import "TSMultimediaDataDelegate.h"
#import "TSAnotacionEnMapa.h"

@implementation TSMapaViewController

@synthesize vistaMapa, listado, anotacionesDelMapa;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.anotacionesDelMapa = [[NSMutableArray alloc] init];

        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.listado = [[TSClipListadoViewController alloc] init];        
    [self.listado prepararListado];
    self.listado.rangoUltimo = NSMakeRange(1, 30);
    [self.listado cargarClips];
    
    self.listado.delegate = self;
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma - MKMapViewDelegate
/*
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
	/*
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[TSAnotacionEnMapa class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView
                                                              dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotation"];
		
        if (!pinView)
        {
            // If an existing pin view was not available, create one
			pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
													   reuseIdentifier:@"CustomPinAnnotation"];
                       
        }

    
}

*/

#pragma - TSMultimediaDataDelegate

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    NSLog(@"Mapa");
    for (NSDictionary *unDiccionario in array)
    {
        TSAnotacionEnMapa *anotacion = [[TSAnotacionEnMapa alloc] initWithDiccionarioNoticia:unDiccionario];
        
        
        [self.vistaMapa addAnnotation:anotacion];
        
        [anotacion release];
        
        
    }

    
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}

@end
