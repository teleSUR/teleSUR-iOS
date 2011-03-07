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
#import "GANTracker.h"


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


- (void)configurarConEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
    // Datos
    self.entidadMenu = (entidad != nil) ? entidad : @"categoria";
    self.diccionarioConfiguracionFiltros = diccionario ? diccionario : [NSMutableDictionary dictionary];
    self.rango = NSMakeRange(1, kTAMANO_PAGINA);
    
    //Auxialiares
    self.indiceDeFiltroSeleccionado = 0;
    self.arregloClipsAsyncImageViews = [NSMutableArray array];
}


#pragma mark -
#pragma mark Internos

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
        
        // Asignar acción del botón
        if (self.indiceDeFiltroSeleccionado != i)
            [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // Configurar label de botón
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];
        
        // Configurar colores para denotar un boton seleccionado
		[boton setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:UIControlStateNormal];
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


#pragma mark -
#pragma mark Acicones

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
    // Apagar todos los botones y prender el botón en cuestión
    for (UIButton *btn in [self.menuScrollView subviews]) [btn setSelected:NO];
	[boton setSelected:YES];

    // Calcular nuevo offset para que el botón esté centrado
    CGFloat offset = + boton.frame.origin.x
                     + boton.frame.size.width/2.0
                     - self.menuScrollView.frame.size.width/2.0;
    
    // Si el offset es negativo o más grande que la barra completa, no centrar el botón
    CGFloat maxOffset = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
    if (offset < 0) offset = 0;
    else if (offset > maxOffset) offset = maxOffset;
    
    // Aplicar nuevo offset
    [[self menuScrollView] setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    // Obtener índice y slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    	
	// Actualizamos el boton que debe "seleccionarse"
	self.indiceDeFiltroSeleccionado = indice;
	
    // Configurar nuevo diccionario de filtros, no filtrar si se usó botón "todos"
    [self.diccionarioConfiguracionFiltros setValue:((indice > 0) ? slug : nil) forKey:self.entidadMenu];
    
    // Re-cargar datos
    // Mostrar vista de loading
    [self.tableViewController mostrarLoadingViewConAnimacion:YES];
    [self cargarDatos];
}   

- (void)playerFinalizado:(NSNotification *)notification
{
    // Crear y presentar vista de detalles para el video que acaba de finalizar (índice guardado en tag de view)
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:indiceDeClipSeleccionado]];
    [self.navigationController pushViewController:detalleView animated:NO];
    [detalleView release];
    
    // ENviar notificación a Google Analytics
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"iPhone"
                                         action:@"Video reproducido"
                                          label:[[self.clips objectAtIndex:indiceDeClipSeleccionado] valueForKey:@"archivo"]
                                          value:-1
                                      withError:&error])
    {
        NSLog(@"Error");
    }
    
    //
    // Un posible momento para insertar publicidad
    //
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[self personalizarNavigationBar];
    
    
    // Detemrinar datos de entrada: filtros a aplicar, y filtros a mostrar
    NSMutableDictionary *dict = [NSMutableDictionary dictionary]; 
    NSString *filtro;
    NSString *tab = [[self navigationItem] title];
    
    if ([tab isEqualToString:@"Noticias"])
    {
        filtro = @"categoria";
        [dict setValue:@"noticia" forKey:@"tipo"];
    }
    else if ([tab isEqualToString:@"Entrevistas"])
    {
        filtro = @"categoria";
        [dict setValue:@"entrevista" forKey:@"tipo"];
    }
    else if ([tab isEqualToString:@"Programas"])
    {
        filtro = @"programa";
        [dict setValue:@"programa" forKey:@"tipo"];
    }
        
    // Configurar variables internas
    [self configurarConEntidad:filtro yFiltros:dict];
    
    
    // Mostrar vista de loading y cargar datos
    [self.tableViewController mostrarLoadingViewConAnimacion:YES];
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
    if ([self.clips count] == 0) return 0;
    else return [self.clips count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.row < [self.clips count]) {
        
        // Reutilizar o bien crear nueva celda
        static NSString *CellIdentifierEstandar = @"CeldaEstandar";
        ClipEstandarTableCellView *cell = (ClipEstandarTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierEstandar];
        if (cell == nil) {
            if (indexPath.row==0) {
                cell = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipGrandeTableCellView" owner:self options:nil] lastObject];   
            } else {
                cell = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];   
            }
                
         
        }
            
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
    } else {
        static NSString *CellIdentifierVerMas = @"CeldaVerMas";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierVerMas];
        if (cell == nil) cell = (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"VerMasClipsTableCellView" owner:self options:nil] lastObject];
        return cell;
        
    
    }

}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{		
    // Leer y devolver si hay altura guardada
//    if (celdaEstandarHeight)
//        return celdaEstandarHeight;
    
    // Leer en NIB altura de celda y asignarlo a variable auxiliar para sólo cargar NIB una sóla vez
    
    // Seleccionar que NIB cargar
    
    NSString *nombreNIB;
    
    if (indexPath.row == 0) nombreNIB = @"ClipGrandeTableCellView";
    
    else nombreNIB = @"ClipEstandarTableCellView";
    
    UITableViewCell *celda= (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:nombreNIB owner:self options:nil] lastObject];

    

    celdaEstandarHeight = celda.frame.size.height;
    
	return celdaEstandarHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Guardar referencia a índice, notificación del player lo necesita
    self.indiceDeClipSeleccionado = indexPath.row;
    
    if (self.indiceDeClipSeleccionado < [self.clips count]) {   // Se trata de un video
        
            // Obtener NSURL del video
            ;
            NSString *stringURL = [NSString stringWithFormat:@"%@", [[self.clips objectAtIndex:indexPath.row] valueForKey:@"archivo_url"]];
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
            
    } else {    // Se trata de la celda "Más Video"
    
        self.rango = NSMakeRange(0, self.rango.length+kTAMANO_PAGINA);
        // Aqui no se que metodo es el correcto para recargar. Lo vemos mañana.
//        [self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
        
    }
    


    
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
#pragma mark PullToReloadTableViewController

- (void)reloadTableViewDataSource
{
    [self cargarDatos];
}

#pragma mark -
#pragma mark Métodos redirigidos a PullToReloadTableViewController

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView { [self.tableViewController scrollViewWillBeginDragging:scrollView]; }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView { [self.tableViewController scrollViewDidScroll:scrollView]; }

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate { [self.tableViewController scrollViewDidEndDragging:scrollView willDecelerate:decelerate]; }


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

// Maneja los datos recibidos
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
        
        // Crear diccionario para representar "todos", un primer filtro fake
        NSMutableDictionary *filtroTodos = [NSMutableDictionary dictionary];
        [filtroTodos setValue:@"Todos" forKey:@"nombre"];
        [filtroTodos setValue:@"todos" forKey:@"slug"];
        [filtroTodos setValue:@"Mostrar todos" forKey:@"descripcion"];
        
        // Insertar filtro como primer elemento del arreglo recibido
        NSMutableArray *arregloAumentado = [NSMutableArray arrayWithArray:array];
        [arregloAumentado insertObject:filtroTodos atIndex:0];
        
        // Actualizar arreglo interno
        self.filtros = arregloAumentado;
        
        // Reconstruir menú con nuevos fitros
        [self construirMenu];
        
        
    }
    
    // Cuando ya se han cargado los datos tanto para clips como para filtros:
    if (self.clips != nil && self.filtros != nil)
    {
        // Actualizar datos para la vista de pull-to-refresh
        [self.tableViewController setLastUpdate:[NSDate date]];
        [self.tableViewController dataSourceDidFinishLoadingNewData];
        
        // Ocultar vista de loading
        [self.tableViewController ocultarLoadingViewConAnimacion:YES];
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
