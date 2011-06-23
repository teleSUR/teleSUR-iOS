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
#import "AsynchronousButtonView.h"
#import "TSAnotacionEnMapa.h"
#import "TwitterSobreMapa.h"
#import "DataDescargable.h"
#import "XMLParser.h"
#import "NSDate_Utilidad.h"


@implementation TSMapaViewController

@synthesize vistaCargandoEnVivo;
@synthesize vistaMapa, listado, anotacionesDelMapa;
@synthesize noticiaSeleccionada;
@synthesize controlSegmentadoTitulo;
@synthesize menu;

@synthesize switchVideoEnVivo;

@synthesize contenedorTwitter;

@synthesize vistaTwitter;

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
    
    NSArray* nibViewsTwitter =  [[NSBundle mainBundle] loadNibNamed:@"TwitterSobreMapa" owner:self options:nil];
    self.vistaTwitter = [nibViewsTwitter lastObject];    
    [self.contenedorTwitter addSubview:self.vistaTwitter];


    
    
    
    [imageView release];    

    
    
    
    
    [super viewDidLoad];
}

-(IBAction) mostrarVideoTiempoReal: (id) sender
{
    
    if (self.switchVideoEnVivo.on) {
        self.vistaCargandoEnVivo.alpha = 1.0;
        NSString *moviePath = @"http://streaming.tlsur.net:1935/live/vivo.stream/playlist.m3u8";
        NSURL *movieURL = [NSURL URLWithString:moviePath];
        
        
        self.vistaReproduccionVideoTiempoReal = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        [self.vistaReproduccionVideoTiempoReal.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
        self.vistaReproduccionVideoTiempoReal.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+44, self.view.frame.size.width, self.view.frame.size.height-44);
        
        [self.view addSubview:self.vistaReproduccionVideoTiempoReal.view];
        [self.vistaReproduccionVideoTiempoReal.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];        
        [self.vistaReproduccionVideoTiempoReal play];
        
        
        
    } else
    {
        self.vistaCargandoEnVivo.alpha = 0.0;        
        [self.vistaReproduccionVideoTiempoReal stop];
        [self.vistaReproduccionVideoTiempoReal.view removeFromSuperview];
        [self.vistaReproduccionVideoTiempoReal release];
    }
    
    
}


- (void)viewDidUnload
{
    [controlSegmentadoTitulo release];
    controlSegmentadoTitulo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) ocultarTwitter
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.contenedorTwitter.alpha = 0.0;
    
    
	[UIView commitAnimations];
    
}



-(void) mostrarTwitterDelUsuario: (NSString *) nombreUsuarioTwitter
{
    self.vistaTwitter.labelNombreTwitter.text = [NSString stringWithFormat:@"@%@", nombreUsuarioTwitter];
    [self.vistaTwitter.imagenTwitter reset];
    self.vistaTwitter.imagenTwitter.url = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image/%@?size=bigger", nombreUsuarioTwitter];
    [self.vistaTwitter.imagenTwitter cargarImagenSiNecesario];
    
    DataDescargable *twitterFeed = [[DataDescargable alloc] initWithURL: [NSString stringWithFormat: @"http://twitter.com/statuses/user_timeline/%@.rss?count=1",nombreUsuarioTwitter] 
                                                            andDelegate:self];
    
	[twitterFeed data];
	
	[twitterFeed release];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.contenedorTwitter.alpha = 1.0;
    
    
	[UIView commitAnimations];
	
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   // Corresponsales    
    if (self.controlSegmentadoTitulo.selectedSegmentIndex==1)
    {
        
        NSString *usuarioTwitter = /*@"hecktorzr";*/ [[[(TSAnotacionEnMapa *)view.annotation noticia] valueForKey:@"corresponsal"] valueForKey:@"twitter"];
        
        if (![usuarioTwitter isKindOfClass:[NSNull class]])
        {
            
            if ( [usuarioTwitter isEqualToString:@""])
            {
//                usuarioTwitter = @"hecktorzr";
                [self ocultarTwitter];            
                NSLog(@"Twitter: Sin Tuirer");
                
            } else 
            {
                [self mostrarTwitterDelUsuario:usuarioTwitter];
            }
        }
        else
        {
            [self ocultarTwitter];
        }
        
        
     
    }
}

-(void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Seleccionadas: %d", [mapView.selectedAnnotations count]);
    
    if ([mapView.selectedAnnotations count] == 0) 
    {
        [self ocultarTwitter];
    }
}

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

    
    AsynchronousButtonView *imageButtonView = [[AsynchronousButtonView alloc] init]; //[UIButton buttonWithType:UIButtonTypeCustom];
    
    [imageButtonView addTarget:self 
                                               action:@selector(reproducirVideoEnPantalla)
                                     forControlEvents:UIControlEventTouchDown];
    
    imageButtonView.frame = CGRectMake(0.0, 0.0, 40.0, 30.0);    
                                    


    if (imageButtonView)
    {
        imageButtonView.url = [NSURL URLWithString:[[(TSAnotacionEnMapa *)annotation noticia] valueForKey:@"thumbnail_mediano"]];
        imageButtonView.imageView.image = [UIImage imageNamed:@"SinImagen.png"];
        [imageButtonView cargarImagenSiNecesario];

    }
    pin.leftCalloutAccessoryView = imageButtonView;
    
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
        
        if (anotacion.sinCoordenadas == NO) [self.vistaMapa addAnnotation:anotacion];
        NSLog(@"Locacion: %f, %f", anotacion.coordinate.latitude, anotacion.coordinate.longitude);    
        
        anotacionFinal = anotacion;
        [anotacion release];
        
        
    }
    
    [self.vistaMapa selectAnnotation:[[self.vistaMapa annotations] lastObject] animated:NO];

//    [self.vistaMapa setCenterCoordinate:anotacionFinal.coordinate animated:YES];
    
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}

#pragma mark -
#pragma mark DataDescargable Delegate:

// Termino exitosamente la descarga de un archivo

- (void)downloadDidFinishDownloading: (DataDescargable *)download {
    
    
	
	// Parsear DATA
	
	NSString *xmlFile = [[NSString alloc] initWithData:download.data encoding:NSASCIIStringEncoding];
	
	// Parsing de Archivo
	XMLParser *parser = [[XMLParser alloc] init];
	[parser parseXMLFile:xmlFile];
	
	if (parser.error)
    {
        NSLog(@"Error al hacer el parsing");
	}
    
    self.vistaTwitter.labelTwit.text = [parser.ultimoTwit substringFromIndex:[self.vistaTwitter.labelNombreTwitter.text length]+ 1] ;
    self.vistaTwitter.labelFechaTwit.text = [parser.fechaTwit enTimerContraAhora];
	
	[xmlFile release];	
	[parser release];
}


// Se presento un error de conexion en la descarga.

- (void)download:(DataDescargable *)download didFailWithError:(NSError *)error
{
	
	
}

@end
