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
#import <MediaPlayer/MediaPlayer.h>
#import "GANTracker.h"


#define kMARGEN_MENU 12
#define kTAMANO_PAGINA 10

#define kTITULO_LABEL_TAG 1
#define kTHUMBNAIL_IMAGE_VIEW_TAG 2
#define kDURACION_LABEL_TAG 3
#define kFIRMA_LBAEL_TAG 4


@implementation TSClipListadoViewController

@synthesize tableViewController;
@synthesize entidadMenu, rangoUltimo, diccionarioConfiguracionFiltros;
@synthesize clipsTableView, menuScrollView;
@synthesize clips, filtros;
@synthesize arregloClipsAsyncImageViews;
@synthesize indiceDeClipSeleccionado, indiceDeFiltroSeleccionado, slugDeFiltroSeleccionado;
@synthesize agregarAlFinal, omitirVerMas, conFiltroTodos;


#pragma mark -
#pragma mark Init

- (id)initWithEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
	if ((self = [super init]))
    {
		[self configurarConEntidad:entidad yFiltros:diccionario];
        self.clips = [NSMutableArray array];
        self.arregloClipsAsyncImageViews = [NSMutableArray array];
	}
	
	return self;
}


- (void)configurarConEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
    // Datos
    self.entidadMenu = (entidad != nil) ? entidad : @"categoria";
    self.diccionarioConfiguracionFiltros = diccionario ? [NSMutableDictionary dictionaryWithDictionary:diccionario] : [NSMutableDictionary dictionary];
    
    self.rangoUltimo = NSMakeRange(1, kTAMANO_PAGINA);
    
    //Auxialiares
    self.indiceDeFiltroSeleccionado = 0;
    self.agregarAlFinal = NO;
    
    // Clips
    //self.clips = [NSMutableArray array];
    
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
    for (int i=0; i < [self.filtros count]; i++)
    {
        // Crear nuevo bot√≥n para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acción del botón
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
        
        // Si el botón tiene un slug igual al que se indicó como seleccionado, actualizar índiceDeClipSeleccionado
        if ([self.slugDeFiltroSeleccionado isEqualToString:[[self.filtros objectAtIndex:i] valueForKey:@"slug"]])
            self.indiceDeFiltroSeleccionado = i;
        
        // Añadir botón a la jerarquón de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir área de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
    
    // Fingir presionar el botón del clip seleccionado
    [self filtroSeleccionadoConBoton:[[self.menuScrollView subviews] objectAtIndex:self.indiceDeFiltroSeleccionado]];
}

// Obtiene clips asincrónicamente, con base en propiedades del objeto
- (void)cargarClips
{
    static NSString *entidadClips = @"clip";
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:entidadClips // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioConfiguracionFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:self.rangoUltimo  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                       conDelegate:self];
}

// Obtiene filtros asincrónicamente, con base en propiedades del objeto
- (void)cargarFiltros
{
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:self.entidadMenu // otros ejemplos: programa, pais, categoria
                          conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                             enRango:NSMakeRange(1, 300)  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                         conDelegate:self];
}


#pragma mark -
#pragma mark Acicones

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
    // Obtener índice y slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Apagar todos los botones y prender el botón en cuestión
    for (UIButton *btn in [self.menuScrollView subviews]) [btn setSelected:NO];
	[boton setSelected:YES];
    
    // Autoscroll de menú, sólo si el contenido es más grande que el frame visible
    if (self.menuScrollView.contentSize.width > self.menuScrollView.frame.size.width)
    {
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
    }
    
    // Si se presionó el mismo que estaba seleccionado, no hacer nada
    if (self.indiceDeFiltroSeleccionado != indice)
    {
        // Configurar nuevo diccionario de filtros, no filtrar si se usó botón "todos"
        [self.diccionarioConfiguracionFiltros setValue:((indice > 0) ? slug : nil) forKey:self.entidadMenu];
        
        // Reinicializar datos, con misma entidad de menú pero nuevo diccionario de confgiruación de filtros 
        [self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
        
        // Actualizamos el boton que debe "seleccionarse"
        self.indiceDeFiltroSeleccionado = indice;
        
        // Re-cargar datos
        // Mostrar vista de loading
        [self mostrarLoadingViewConAnimacion:YES];
        [self cargarClips];
    }
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
    self.clipsTableView.scrollsToTop = YES;
    self.menuScrollView.scrollsToTop = NO;
    
    self.indiceDeClipSeleccionado = -1;
    
    self.conFiltroTodos = YES;
    
    self.clips = [NSMutableArray array];
    self.arregloClipsAsyncImageViews = [NSMutableArray array];
    
    
    if (!self.diccionarioConfiguracionFiltros) // Sólo si no se llamó ya a initWith... 
    {
        // Detemrinar datos de entrada: filtros a aplicar, y filtros a mostrar
        NSMutableDictionary *dict = [NSMutableDictionary dictionary]; 
        NSString *filtro;
        NSString *tab = [[self navigationItem] title];
        
        NSLog(@"Titulo tab: %@", tab);
        
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
    }
    
    
    // Mostrar vista de loading y cargar datos
    
    [self mostrarLoadingViewConAnimacion:YES];
    [self cargarFiltros];
    [self cargarClips];
	
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Si ya había un clip seleccionado, asegurar que esté marcado 
    if (self.indiceDeClipSeleccionado != -1 && animated)
        [self.clipsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.indiceDeClipSeleccionado inSection:0] animated:NO scrollPosition: UITableViewScrollPositionNone];
}


- (void)viewDidAppear:(BOOL)animated
{
    // Si ya había un clip seleccionado, desmarcarlo con animación
    if (self.indiceDeClipSeleccionado != -1 && animated)
        [self.clipsTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.indiceDeClipSeleccionado inSection:0] animated:animated];
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
    // Número de clips más uno para celda "Ver Más"
    if ([self.clips count] == 0 || self.omitirVerMas)
        return [self.clips count];
    else
        return [self.clips count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nombreNib = [self nombreNibParaIndexPath:indexPath];
    
    // Si estamos en la última fila, entonces devolver celda para "Ver más"
    if ([nombreNib isEqualToString:@"VerMasClipsTableCellView"])
        return (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:nombreNib owner:self options:nil] lastObject];
    
    // Reutilizar o bien crear nueva celda, tipo Grande o Estándar  
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nombreNib];
    if (cell == nil)
        cell = (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:nombreNib owner:self options:nil] lastObject];
    
    // Si estamos en medio una cosnulta, devolver la celda tal cual está en el NIB,
    // por ejemplo, si la tabla sigue con inercia después de empezar a cargar datos
    if ([self.clips count] == 0)
        return cell;
    
    // Elementos de celda
    UILabel *tituloLabel = (UILabel *)[cell viewWithTag:kTITULO_LABEL_TAG];
    UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:kTHUMBNAIL_IMAGE_VIEW_TAG];
    UILabel *duracionLabel = (UILabel *)[cell viewWithTag:kDURACION_LABEL_TAG];
    UILabel *firmaLabel = (UILabel *)[cell viewWithTag:kFIRMA_LBAEL_TAG];
    
    // Copiar propiedades de thumbnailView (definidas en NIB) y sustitirlo por AsyncImageView correspondiente
    CGRect frame = thumbnailImageView.frame;
    [thumbnailImageView removeFromSuperview];
    thumbnailImageView = [self.arregloClipsAsyncImageViews objectAtIndex:indexPath.row];
    thumbnailImageView.frame = frame;
    [cell addSubview:thumbnailImageView];
 
    // Establecer texto de etiquetas
    tituloLabel.text = [[self.clips objectAtIndex:indexPath.row] valueForKey:@"titulo"];
    duracionLabel.text = [[self.clips objectAtIndex:indexPath.row] valueForKey:@"duracion"];	
    firmaLabel.text = [[self.clips objectAtIndex:indexPath.row] obtenerTiempoDesdeParaEsteClip];
    
    return cell;        
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat *cacheVar;
    
    // Determinar variable auxiliar cache para cargar NIB una sola vez
         if (indexPath.row == 0)                  cacheVar = &celdaEstandarHeight;
    else if (indexPath.row < [self.clips count])  cacheVar = &celdaGrandeHeight;
    else if (indexPath.row == [self.clips count]) cacheVar = &celdaVerMasHeight;
    
    // Si existe, devolver altura en cache
    if (*cacheVar) return *cacheVar;
    
    // Si la altura no ha sido guardada en variable de instancia, cargar NIB
    UITableViewCell *celda = (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:[self nombreNibParaIndexPath:indexPath] owner:self options:nil] lastObject];
   
    // Leer altura de celda, guardarla en cache y devolverla
    *cacheVar = celda.frame.size.height;
    
    return *cacheVar;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Guardar referencia a índice
    self.indiceDeClipSeleccionado = indexPath.row;
    
    if (self.indiceDeClipSeleccionado < [self.clips count]) // Se trata de un video
    {
        // Obtener NSURL del video
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
    }
    else // Se trata de la celda "Ver Más"
    {
        // Actualizar rango y cargar datos
        self.rangoUltimo = NSMakeRange(self.rangoUltimo.location + self.rangoUltimo.length, kTAMANO_PAGINA);
        
        // Bandera para no reemplazar la lista de clips, sino agregar los elementos al final
        self.agregarAlFinal = YES;
        
        // Animar Activity Indicator
        [(UIActivityIndicatorView *)[self.view viewWithTag:2] startAnimating];
        
        // Cargar datos
        [self cargarClips];
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // Guardar feferencia a clip seleccionado
    self.indiceDeClipSeleccionado = indexPath.row;
    
    // Crear y presentar vista de detalles
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detalleView animated:YES];
    [detalleView release];
}

- (NSString *)nombreNibParaIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.clips count])
    {
        return @"VerMasClipsTableCellView";
    }
    else if (indexPath.row == 0)
    {
         return @"ClipGrandeTableCellView";
    }
    else
    {
         return @"ClipEstandarTableCellView";
    }
}


#pragma mark -
#pragma mark PullToReloadTableViewController

// Llamado al actualizar desde pull-to-refresh
- (void)reloadTableViewDataSource
{
    // Se va a actualizar la lista, re-inicializar configuración
    [self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
    
    [self cargarClips];
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
    self.clipsTableView = nil;
    self.tableViewController = nil;
    self.diccionarioConfiguracionFiltros = nil;
    self.entidadMenu = nil;
    self.menuScrollView = nil;
    self.slugDeFiltroSeleccionado = nil;
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
        
        // Para cada clip obtenido agregar un AsynchronousImageView al arregloClipsAsyncImageViews
        for (int i=0; i < [self.clips count]; i++)
        {
            AsynchronousImageView *aiv = [[AsynchronousImageView alloc] init];
            [aiv loadImageFromURLString:[NSString stringWithFormat:@"%@", [[self.clips objectAtIndex:i] valueForKey:@"thumbnail_pequeno"]]];
            [self.arregloClipsAsyncImageViews insertObject:aiv atIndex:i];
            [aiv release];
        }
        
        self.omitirVerMas = [array count] < kTAMANO_PAGINA;
        
        // Recargar tabla
        [self.clipsTableView reloadData];
        
        // Si la bandera para agregar al final está apagada, hacer scrolla hasta arriba
        if (!self.agregarAlFinal && [self.clips count])
        {
            [self.clipsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        self.agregarAlFinal = NO;
        
        
        // Actualizar datos para la vista de pull-to-refresh
        [self.tableViewController setLastUpdate:[NSDate date]];
        [self.tableViewController dataSourceDidFinishLoadingNewData];
        
        // Ocultar vista de loading
        [self ocultarLoadingViewConAnimacion:YES];
    }
    else
    {
        // En caso de haber recibido cualquier otro tipo de entidad, es para filtros
        
        // Crear diccionario para representar "todos", un primer filtro fake
        if (self.conFiltroTodos)
        {
            NSMutableDictionary *filtroTodos = [NSMutableDictionary dictionary];
            [filtroTodos setValue:@"Todos" forKey:@"nombre"];
            [filtroTodos setValue:@"todos" forKey:@"slug"];
            [filtroTodos setValue:@"Mostrar todos" forKey:@"descripcion"];
            
            // Insertar filtro como primer elemento del arreglo recibido
            NSMutableArray *arregloAumentado = [NSMutableArray arrayWithArray:array];
            [arregloAumentado insertObject:filtroTodos atIndex:0];
            
            // Actualizar arreglo interno
            self.filtros = arregloAumentado;
        }
        else
        {
            self.filtros = array;
        }
        
        // Reconstruir menú con nuevos fitros
        [self construirMenu];
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
