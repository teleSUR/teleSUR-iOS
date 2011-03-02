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
#import "ClipEstandarTableCellView.h"
#import <MediaPlayer/MediaPlayer.h>


#define kMARGEN_MENU 15
#define kTAMANO_PAGINA 6
#define kTagBotonesMenu 1024

@implementation TSClipListadoViewController

@synthesize entidadMenu, rango, diccionarioFiltros;
@synthesize clipsTableView, menuScrollView;
@synthesize clips, filtros;
@synthesize indiceDeBotonSeleccionado;
@synthesize arregloClipsAsyncImageViews;



#pragma mark -
#pragma mark Init

- (id)initWithEntidadMenu:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
	if ((self = [super init]))
    {
		self.entidadMenu = entidad;
		self.diccionarioFiltros = diccionario;
		self.rango = NSMakeRange(1, kTAMANO_PAGINA);
		self.indiceDeBotonSeleccionado = -1;
	}
	
	return self;
}


#pragma mark -

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
	 
    // Obtener slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton] - 1;
	
	// Actualizamos el boton que debe "seleccionarse"
	 
	self.indiceDeBotonSeleccionado = indice;
	
	// Mantener el boton seleccionado
	[boton setSelected:YES];
	
	NSString *slug;
	
	if (indice==-1) slug = @"";
		
    else slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Configurar nuevo diccionario de filtros
    // TODO: Todav抋 hardcoded
    self.diccionarioFiltros = [NSDictionary dictionaryWithObject:slug forKey:@"categoria"];
    
    // Re-cargar datos
    [self cargarDatos];
}


- (void)construirMenu 
{
    // Retirar todos los botones del men煤, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + kMARGEN_MENU;

	// OJO: Revisar BUG esta expresi梟:
	//	for (int i = -1; i < [self.filtros count]; i++)
    // Recorrer filtros
    for (float i = -1; i < [self.filtros count]; i++)
    {
        // Crear nuevo bot贸n para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acci贸n del bot梟n
        [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];

		boton.tag = kTagBotonesMenu;

        // Configurar label de bot梟
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];
        
        // Texto del bot梟
        NSString *nombre = (i > 0) ? [[self.filtros objectAtIndex:i] valueForKey:@"nombre"] : @"Todos";
        [boton setTitle:nombre forState:UIControlStateNormal];
        boton.titleLabel.text = nombre;
		
		// Configurar 2 colores para denotar un boton seleccionado
		[boton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
		[boton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];		
		[boton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];		// boton en estado normal
		
		if (i == self.indiceDeBotonSeleccionado) [boton setSelected:YES];
		else [boton setSelected:NO];
        
        // Ajustar tama帽o de frame del bot贸n con base en el volumen del texto
		CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
		boton.frame = CGRectMake(offsetX, boton.frame.origin.y, textoSize.width, self.menuScrollView.frame.size.height);
        
        // Actualizar offset
        offsetX += boton.frame.size.width + kMARGEN_MENU;
        
        // A帽adir bot贸n a la jerarqu铆a de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir 噐ea de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
}


- (void)cargarDatos
{
    // Inicializar arreglos
    self.clips = nil;
    self.filtros = nil;
    
    // Mostrar vista de loading
    [self mostrarLoadingViewConAnimacion:NO];

	// Regresar el scroll de la tabla a la parte superior
	[self.clipsTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	
	
    // Obtener clips
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:@"clip" // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -s贸lo uno-
                       conDelegate:self];

    
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:@"categoria" // otros ejemplos: programa, pais, categoria
                        conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -s贸lo uno-
                       conDelegate:self];
}


- (void)playerFinalizado:(NSNotification *)notification
{
    // Crear y presentar vista de detalles para el video que acaba de finalizar (抧dice guardado en tag de view)
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:[[[notification object] view] tag]]];
    [self.navigationController pushViewController:detalleView animated:NO];
    [detalleView release];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{	

	
	self.indiceDeBotonSeleccionado = -1;	

    // Inicializar arreglo de im噂enes
    self.arregloClipsAsyncImageViews = [NSMutableArray array];
    

	[self personalizarNavigationBar];
    [self cargarDatos];
	
    [super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.clips count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Reutilizar o bien crear nueva celda
    static NSString *CellIdentifier = @"CeldaEstandar";
    ClipEstandarTableCellView *cell = (ClipEstandarTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];
        
    // Copiar propiedades de thumbnailView (definidas en NIB) y sustitirlo por AsyncImageView correspondiente
    CGRect frame = cell.thumbnailView.frame;
    [cell.thumbnailView removeFromSuperview];
    cell.thumbnailView = [self.arregloClipsAsyncImageViews objectAtIndex:indexPath.row];
    cell.thumbnailView.frame = frame;
    [cell addSubview:cell.thumbnailView];
    
    // Establecer texto de etiquetas
	[cell.titulo setText: [[self.clips objectAtIndex:indexPath.row] valueForKey:@"titulo"]];
	[cell.duracion setText: [[self.clips objectAtIndex:indexPath.row] valueForKey:@"duracion"]];	
	[cell.firma setText:[[self.clips objectAtIndex:indexPath.row] obtenerFirmaParaEsteClip]];
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{		
    // Leer y devolver si hay altura guardada
    if (celdaEstandarHeight)
        return celdaEstandarHeight;
    
    // Leer en NIB altura de celda y asignarlo a variable auxiliar para s條o cargar NIB una s條a vez
    UITableViewCell *celda = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];
    celdaEstandarHeight = celda.frame.size.height;
    
	return celdaEstandarHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Obtener NSURL del video
    NSString *stringURL = [NSString stringWithFormat:@"http://stg.multimedia.tlsur.net/media/%@", [[self.clips objectAtIndex:indexPath.row]  valueForKey:@"archivo"]];
    NSURL *urlVideo = [NSURL URLWithString: stringURL];
    
    // Crear y configurar player
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:urlVideo];
    [movieController.view setBackgroundColor: [UIColor blackColor]];
    
    // Establecer tag para guardar referencia al 抧dice en self.clip
    [[movieController.moviePlayer view] setTag:indexPath.row];
    
    // Presentar player y reproducir video
    [self presentMoviePlayerViewControllerAnimated:movieController];
    [movieController.moviePlayer play];  
    
    // Agregar observer al finalizar reproducci梟
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(playerFinalizado:)                                                 
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:movieController.moviePlayer];
    
    // Des-seleccionar fila en tabla
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // Crear y presentar vista de detalles
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detalleView animated:YES];
    [detalleView release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    self.clips = nil;
    self.filtros = nil;
    self.arregloClipsAsyncImageViews = nil;
}


- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark TSMultimediaDataDelegate

- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    if ([entidad isEqualToString:@"clip"])
    {
        // En caso de haber recibido entidades de tipo clip, asignar arreglo de clips
        self.clips = array;
        
        // Para cada clip obtenido agregar un AsynchronousImageView al arregloClipsAsyncImageViews
        [self.arregloClipsAsyncImageViews removeAllObjects];
        for (int i=0; i<[self.clips count]; i++)
        {
            AsynchronousImageView *aiv = [[AsynchronousImageView alloc] init];
            [aiv loadImageFromURLString:[NSString stringWithFormat:@"%@", [[array objectAtIndex:i] valueForKey:@"thumbnail_mediano"]]];
            [self.arregloClipsAsyncImageViews addObject:aiv];
            [aiv release];
        }
        
        // Recargar tabla
        [self.clipsTableView reloadData];
    }
    else
    {
        // En caso de haber recibido cualquier otro tipo de entidad, es para filtros
        self.filtros = array;
        
        // Reconstruir men煤 con nuevos fitros
        [self construirMenu];
    }
    
    // Ocultar vista de loading s贸lo cuando ya se han cargado los datos tanto para clips como para filtros
    if (self.clips != nil && self.filtros != nil) [self ocultarLoadingViewConAnimacion:NO];
    
    // Liberar objeto de datos
    [data release];
}

    
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    // TODO: Informar al usuario sobre error
	NSLog(@"Error: %@", error);
    
    // Liberar objeto de datos
    [data release];
}

@end
