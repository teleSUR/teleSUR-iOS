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
#import "TSTabMenuiPad_UIViewController.h"
#import "teleSuriPadTabMenu.h"
#import "TSClipPlayerViewController.h"
#import "AsynchronousImageViewButton.h"

@implementation TSMapaViewController

@synthesize vistaMapa, listado, anotacionesDelMapa;
@synthesize noticiaSeleccionada;
@synthesize controlSegmentadoTitulo;
@synthesize menu;

@synthesize barraNavegacion;

@synthesize vistaReproduccionVideoTiempoReal;

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
-(void)viewWillAppear:(BOOL)animated
{

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.menu colocarSelectorEnPosicionOriginal];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    

    self.listado = [[TSClipListadoViewController alloc] init];        
    [self.listado prepararListado];

    [self.listado cargarClips];
    
    self.listado.delegate = self;
    
    self.menu = [self cargarMenu];

    // Poner imagen teleSur en la barra
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Header.png"]];
    
    self.barraNavegacion.topItem.titleView = imageView;
    
    [imageView release];    

    
    
    
    
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
        // Sin filtrar, todo el contenido
        self.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:@"noticia" forKey:@"tipo"];
    } else if (self.controlSegmentadoTitulo.selectedSegmentIndex==1)
    {
        // Corresponsales
        self.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:@"no_es_nulo" forKey:@"corresponsal"];
    }
    else
    {
        self.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:@"entrevista" forKey:@"tipo"];
    }
    
    [self.listado cargarClips];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void) reproducirVideoEnPantalla
{
    TSAnotacionEnMapa *seleccion = [[self.vistaMapa selectedAnnotations] objectAtIndex:0];
    
    TSClipPlayerViewController *playerController = [[TSClipPlayerViewController alloc] initConClip:seleccion.noticia];
    
    // Reproducir video
    [playerController playEnViewController:self
                      finalizarConSelector:@selector(playerFinalizado:)
                         registrandoAccion:YES];
    
}

- (void)playerFinalizado:(NSNotification *)notification
{
    // Si se terminó de reproducir el video principal, no crear vista de detalles, ya se está en ella
 //   if (self.indexPathSeleccionado.section == kINFO_SECTION) return;
    
//    [super playerFinalizado:notification];
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
    
    if (self.controlSegmentadoTitulo.selectedSegmentIndex==0)
    {
        pin.pinColor = MKPinAnnotationColorRed;
    }
    else if (self.controlSegmentadoTitulo.selectedSegmentIndex==1)
    {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    else
    {
        pin.pinColor = MKPinAnnotationColorGreen;
    }
    /*
    pin.leftCalloutAccessoryView = [[AsynchronousImageViewButton alloc] init];    
    pin.leftCalloutAccessoryView.frame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    AsynchronousImageViewButton *imageView;
    pin.leftCalloutAccessoryView.backgroundColor = [UIColor blueColor];
    
    
    if ((imageView = (AsynchronousImageViewButton *)pin.leftCalloutAccessoryView ))
    {
        imageView.delegado = self;
        imageView.selector = @selector(reproducirVideoEnPantalla);    
        imageView.url = [NSURL URLWithString:[[(TSAnotacionEnMapa *)annotation noticia] valueForKey:@"thumbnail_mediano"]];
        imageView.image = [UIImage imageNamed:@"SinImagen.png"];
        [imageView cargarImagenSiNecesario];
    }
    */
    
    pin.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
    [(UIButton *)pin.leftCalloutAccessoryView addTarget:self 
                                               action:@selector(reproducirVideoEnPantalla)
                                     forControlEvents:UIControlEventTouchDown];                                    
    pin.leftCalloutAccessoryView.frame = CGRectMake(0.0, 0.0, 40.0, 30.0);    
                                    
    
    

    AsynchronousImageView *imageView = [[AsynchronousImageView alloc] init];

    
    if (imageView)
    {
        imageView.url = [NSURL URLWithString:[[(TSAnotacionEnMapa *)annotation noticia] valueForKey:@"thumbnail_mediano"]];
        imageView.image = [UIImage imageNamed:@"SinImagen.png"];
        [imageView cargarImagenSiNecesario];
        [(UIButton *)pin.leftCalloutAccessoryView setImage:imageView.image forState:UIControlStateNormal];
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

//    [self.vistaMapa setCenterCoordinate:anotacionFinal.coordinate animated:YES];
    
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}

@end
