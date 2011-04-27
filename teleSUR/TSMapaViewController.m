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
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TSClipDetallesViewController.h"
#import "TSClipStrip.h"

@implementation TSMapaViewController

@synthesize vistaMapa, listado, anotacionesDelMapa;
@synthesize noticiaSeleccionada;

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
-(void) retirarModalView 
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void) reproducirVideo: (TSAnotacionEnMapa *) anotacion 

{
    TSAnotacionEnMapa *seleccion = [[self.vistaMapa selectedAnnotations] objectAtIndex:0];
    
    UINavigationController *controlNavegacion = [[UINavigationController alloc] init];
    
    UIBarButtonItem *botonSalir = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStyleBordered target:self action:@selector(retirarModalView)];
        
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:seleccion.noticia];
    controlNavegacion.modalPresentationStyle = UIModalPresentationFormSheet;
    
    detalleView.navigationItem.leftBarButtonItem = botonSalir;    
    controlNavegacion.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [controlNavegacion pushViewController:detalleView animated:NO];
    
    [self presentModalViewController:controlNavegacion animated:YES  ];
    
    [detalleView release];
}

#pragma - MKMapViewDelegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.vistaMapa dequeueReusableAnnotationViewWithIdentifier: @"asdf"];
    if (pin == nil)
    {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"asdf"] autorelease];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(reproducirVideo:)
              forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = rightButton;
        
    }
    else
    {
        pin.annotation = annotation;
    }
    pin.canShowCallout = YES;
    pin.pinColor = MKPinAnnotationColorRed;
    pin.animatesDrop = YES;
    return pin;
}


#pragma - TSMultimediaDataDelegate

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    TSAnotacionEnMapa *anotacionFinal;
    NSLog(@"Mapa");
    for (NSDictionary *unDiccionario in array)
    {
        TSAnotacionEnMapa *anotacion = [[TSAnotacionEnMapa alloc] initWithDiccionarioNoticia:unDiccionario];
        
        
        [self.vistaMapa addAnnotation:anotacion];
        anotacionFinal = anotacion;
        [anotacion release];
        
        
    }
    [self.vistaMapa selectAnnotation:anotacionFinal animated:NO];

    
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}

@end
