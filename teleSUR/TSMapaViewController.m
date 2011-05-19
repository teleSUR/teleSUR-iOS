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
#import "AsynchronousImageView.h"



@implementation TSMapaViewController

@synthesize vistaMapa, listado, anotacionesDelMapa;
@synthesize noticiaSeleccionada;
@synthesize controlSegmentadoTitulo;


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
    [controlSegmentadoTitulo release];
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
    [controlSegmentadoTitulo release];
    controlSegmentadoTitulo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction) recargarPines: (id) sender
{
    [self.vistaMapa removeAnnotations:self.vistaMapa.annotations];
    
    if (self.controlSegmentadoTitulo.selectedSegmentIndex==0)
    {
        self.listado.diccionarioConfiguracionFiltros = NULL;
    } else
    {

        self.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:@"cultura" forKey:@"categoria"];
    }
    
    [self.listado cargarClips];
    
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
    
    if (self.controlSegmentadoTitulo.selectedSegmentIndex==0){
        pin.pinColor = MKPinAnnotationColorRed;
    } else 
    {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    
    pin.leftCalloutAccessoryView = [[AsynchronousImageView alloc] init];    
    pin.leftCalloutAccessoryView.frame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    AsynchronousImageView *imageView;
    pin.leftCalloutAccessoryView.backgroundColor = [UIColor blueColor];		


    
    if ((imageView = (AsynchronousImageView *)pin.leftCalloutAccessoryView ))
    {
        imageView.url = [NSURL URLWithString:[[(TSAnotacionEnMapa *)annotation noticia] valueForKey:@"thumbnail_mediano"]];
        imageView.image = [UIImage imageNamed:@"SinImagen.png"];
        [imageView cargarImagenSiNecesario];
    }

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
