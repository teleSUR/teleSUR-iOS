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
#import "PullToRefreshTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>


#define kMARGEN_MENU 12
#define kTAMANO_PAGINA 10


@implementation TSClipListadoViewController

@synthesize tableViewController;
@synthesize entidadMenu, rango, diccionarioConfiguracionFiltros;
@synthesize clipsTableView, menuScrollView;
@synthesize clips, filtros;
@synthesize arregloClipsAsyncImageViews;
@synthesize indiceDeClipSeleccionado, indiceDeFiltroSeleccionado;


#pragma mark -
#pragma mark Init

- (id)initWithEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
	if ((self = [super init]))
    {
		[self configurarConEntidad:entidad yFiltros:diccionario];
	}
	
	return self;
}

- (void)awakeFromNib
{
    [self configurarConEntidad:nil yFiltros:nil];
}

- (void)configurarConEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
    self.entidadMenu = (entidad != nil) ? entidad : @"categoria";
    self.diccionarioConfiguracionFiltros = diccionario ? diccionario : [NSDictionary dictionary];
    self.rango = NSMakeRange(1, kTAMANO_PAGINA);
    self.indiceDeFiltroSeleccionado = 0;
    self.arregloClipsAsyncImageViews = [NSMutableArray array];
}


#pragma mark -

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
    // Mantener el boton seleccionado
	[boton setSelected:YES];
    
    // Obtener índice y slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    	
	// Actualizamos el boton que debe "seleccionarse"
	self.indiceDeFiltroSeleccionado = indice;
	
    // Configurar nuevo diccionario de filtros, si se usó botón "todos", establecer diccionario vacío
    self.diccionarioConfiguracionFiltros = (indice > 0) ? [NSDictionary dictionaryWithObject:slug forKey:self.entidadMenu] : [NSDictionary dictionary];
    
    // Re-cargar datos
    [self cargarDatos];
}   

- (void)construirMenu 
{
    // Retirar todos los botones del men√∫, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + kMARGEN_MENU;

    // Recorrer filtros
    for (float i=0; i < [self.filtros count]; i++)
    {
        // Crear nuevo bot√≥n para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acci√≥n del botónn
        [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // Configurar label de botón
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];
        
        // Configurar colores para denotar un boton seleccionado
		[boton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [boton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[boton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // Texto del botón
        NSString *nombre = [[self.filtros objectAtIndex:i] valueForKey:@"nombre"];
        [boton setTitle:nombre forState:UIControlStateNormal];
        boton.titleLabel.text = nombre;
		
        // Marcar sólo botón seleciconado
        [boton setSelected:(self.indiceDeFiltroSeleccionado == i)];
        
        // Ajustar tamaño de frame del botón con base en el volumen del texto
		CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
		boton.frame = CGRectMake(offsetX, boton.frame.origin.y, textoSize.width, self.menuScrollView.frame.size.height);
        
        // Actualizar offset
        offsetX += boton.frame.size.width + kMARGEN_MENU;
        
        // A√±adir bot√≥n a la jerarqu√≠a de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir área de scroll
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
    static NSString *entidadClips = @"clip";
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:entidadClips // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioConfiguracionFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:self.rango  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                       conDelegate:self];

    
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:self.entidadMenu // otros ejemplos: programa, pais, categoria
                        conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(0, 0)  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                       conDelegate:self];
}


- (void)playerFinalizado:(NSNotification *)notification
{
    // Crear y presentar vista de detalles para el video que acaba de finalizar (índice guardado en tag de view)
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:indiceDeClipSeleccionado]];
    [self.navigationController pushViewController:detalleView animated:NO];
    [detalleView release];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [self.view addSubview:tableViewController.view];
    
    //PullToRefreshTableViewController *tbc = [[PullToRefreshTableViewController alloc] init];
    //self.tableViewController = tbc;
    //[tbc release];
    
    
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
	[cell.firma setText:[[self.clips objectAtIndex:indexPath.row] obtenerTiempoDesdeParaEsteClip]];
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{		
    // Leer y devolver si hay altura guardada
    if (celdaEstandarHeight)
        return celdaEstandarHeight;
    
    // Leer en NIB altura de celda y asignarlo a variable auxiliar para sólo cargar NIB una sóla vez
    UITableViewCell *celda = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];
    celdaEstandarHeight = celda.frame.size.height;
    
	return celdaEstandarHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Guardar referencia a índice, notificación del player lo necesita
    self.indiceDeClipSeleccionado = indexPath.row;
    
    // Obtener NSURL del video
    NSString *stringURL = [NSString stringWithFormat:@"http://stg.multimedia.tlsur.net/media/%@", [[self.clips objectAtIndex:indexPath.row] valueForKey:@"archivo"]];
    NSURL *urlVideo = [NSURL URLWithString: stringURL];
    
    // Crear y configurar player
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:urlVideo];
    [movieController.view setBackgroundColor: [UIColor blackColor]];
    
    // Presentar player y reproducir video
    [self presentMoviePlayerViewControllerAnimated:movieController];
    [movieController.moviePlayer play];  
    
    // Agregar observer al finalizar reproducción
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.tableViewController scrollViewWillBeginDragging:scrollView];
} 


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.tableViewController scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.tableViewController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)reloadTableViewDataSource
{
    [self cargarDatos];
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
        //[super dataSourceDidFinishLoadingNewData];
    }
    else
    {
        // En caso de haber recibido cualquier otro tipo de entidad, es para filtros
        
        // Crear diccionario para primer filtro "todos"
        NSMutableDictionary *filtroTodos = [NSMutableDictionary dictionary];
        [filtroTodos setValue:@"todos" forKey:@"slug"];
        [filtroTodos setValue:@"Todos" forKey:@"nombre"];
        [filtroTodos setValue:@"Mostrar todos" forKey:@"descripcion"];
        
        // Insertar filtro como primer elemento del arreglo recibido
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
        [tmpArray insertObject:filtroTodos atIndex:0];
        
        // Actualizar arreglo interno
        self.filtros = tmpArray;
        
        // Reconstruir menú con nuevos fitros
        [self construirMenu];
        
        
    }
    
    // Ocultar vista de loading sólo cuando ya se han cargado los datos tanto para clips como para filtros
    if (self.clips != nil && self.filtros != nil)
    {
      [self ocultarLoadingViewConAnimacion:NO];
      [self.tableViewController dataSourceDidFinishLoadingNewData];  
    }
    
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


#pragma mark -
#pragma mark TSMultimediaDataDelegate
    
- (void)synchingDone:(NSNotification *)notification
{
    NSLog(@"bbbb");
	//refreshHeaderView.lastUpdatedDate = myApp.lastReviewRefresh;
}



@end
