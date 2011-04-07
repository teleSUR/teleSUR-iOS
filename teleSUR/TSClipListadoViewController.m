//
//  TSClipListadoViewController.m
//  teleSUR
//
//  Created by Hector Zarate / David Regla on 2/27/11.
//  Copyright 2011 teleSUR. All rights reserved.
//


#import "TSClipListadoViewController.h"
#import "TSMultimediaData.h"
#import "UIViewController_Configuracion.h"
#import "NSDictionary_Datos.h"
#import "TSClipDetallesViewController.h"
#import "PullToRefreshTableViewController.h"
#import "AsynchronousImageView.h"
#import "UIViewController_Preferencias.h"
#import "TSSeleccionIdioma.h"


NSInteger const TSNumeroClipsPorPagina = 10;
NSString* const TSEntidadClip = @"clip";


@implementation TSClipListadoViewController


@synthesize clips, indiceDeClipSeleccionado;
@synthesize rangoUltimo, arregloClipsAsyncImageViews;
@synthesize diccionarioConfiguracionFiltros, agregarAlFinal;


#pragma mark -
#pragma mark Operaciones

- (void)configurarConEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
    // Defaults
    self.diccionarioConfiguracionFiltros = diccionario ? [NSMutableDictionary dictionaryWithDictionary:diccionario] : [NSMutableDictionary dictionary];
    if (!self.rangoUltimo.length) self.rangoUltimo = NSMakeRange(1, TSNumeroClipsPorPagina);
    self.agregarAlFinal = NO;
}


// Obtiene clips asincrónicamente, con base en propiedades del objeto
- (void)cargarClips
{
    [self mostrarLoadingViewConAnimacion:YES];
    
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:TSEntidadClip // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioConfiguracionFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:self.rangoUltimo  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                       conDelegate:self];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    // Personalizar
    [self personalizarNavigationBar];
    
    // Mostrar vista de loading
    //[self mostrarLoadingViewConAnimacion:YES];
    
    // Inicializar datos
    self.clips = [NSMutableArray array];
    self.indiceDeClipSeleccionado = -1;
    self.arregloClipsAsyncImageViews = [NSMutableArray array];
    
    if (!self.rangoUltimo.length)
    {
        self.rangoUltimo = NSMakeRange(1, TSNumeroClipsPorPagina);
    }
    
    if ([self numeroDeIdioma] == 0)
    {
        TSSeleccionIdioma *vistaSeleccionIdioma = [[TSSeleccionIdioma alloc] init];
        vistaSeleccionIdioma.vistaListado = self;
        [self presentModalViewController:vistaSeleccionIdioma animated:NO];
        [vistaSeleccionIdioma release];
        
        return;
    }
    
    // Cargar datos
    [self cargarClips];
	
    [super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    [self.arregloClipsAsyncImageViews removeAllObjects];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    self.clips = nil;
    self.arregloClipsAsyncImageViews = nil;
    self.diccionarioConfiguracionFiltros = nil;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark TSMultimediaDataDelegate

// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    if (entidad == TSEntidadClip)
    {
        // Agregar al final o sustuituir listado actual ?
        if (self.agregarAlFinal)
        {
            [self.clips addObjectsFromArray:array];
        }
        else
        {
            [self.clips setArray:array];
            self.arregloClipsAsyncImageViews = [NSMutableArray array];
        }
        
        [self ocultarLoadingViewConAnimacion:YES];
    }
    
    // Liberar objeto de datos
    [data release];
}


- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    // TODO: Informar al usuario sobre error
	NSLog(@"Error: %@", error);
    
    // Quitar vista de loading
    [self ocultarLoadingViewConAnimacion:YES];
    
    
    // Liberar objeto de datos
    [data release];
}


@end
