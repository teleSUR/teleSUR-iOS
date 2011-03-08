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
@synthesize entidadMenu, rangoUltimo, diccionarioConfiguracionFiltros;
@synthesize clipsTableView, menuScrollView;
@synthesize clips, filtros;
@synthesize arregloClipsAsyncImageViews;
@synthesize indiceDeClipSeleccionado, indiceDeFiltroSeleccionado;
@synthesize agregarAlFinal, omitirVerMas;


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
    self.diccionarioConfiguracionFiltros = diccionario ? diccionario : [NSMutableDictionary dictionary];
    
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
    // Retirar todos los botones del menú, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + kMARGEN_MENU;
    
    // Recorrer filtros
    for (float i=0; i < [self.filtros count]; i++)
    {
        // Crear nuevo botón para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acci�n del bot�n
        [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // Configurar label de bot�n
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];
        
        // Configurar colores para denotar un boton seleccionado
		[boton setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:UIControlStateNormal];
        [boton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[boton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // Texto del bot�n
        NSString *nombre = [[self.filtros objectAtIndex:i] valueForKey:@"nombre"];
        [boton setTitle:nombre forState:UIControlStateNormal];
        boton.titleLabel.text = nombre;
		
        // Marcar s�lo bot�n seleciconado
        [boton setSelected:(self.indiceDeFiltroSeleccionado == i)];
        
        // Ajustar tama�o de frame del bot�n con base en el volumen del texto
		CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
		boton.frame = CGRectMake(offsetX, boton.frame.origin.y, textoSize.width, self.menuScrollView.frame.size.height);
        
        // Actualizar offset
        offsetX += boton.frame.size.width + kMARGEN_MENU;
        
        // Añadir botón a la jerarquía de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir �rea de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
}

// Obtiene clips asincr�nicamente, con base en propiedades del objeto
- (void)cargarClips
{
    static NSString *entidadClips = @"clip";
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:entidadClips // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioConfiguracionFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:self.rangoUltimo  // otro ejemplo: NSMakeRange(1, 1) -sólo uno-
                       conDelegate:self];
}

// Obtiene filtros asincr�nicamente, con base en propiedades del objeto
- (void)cargarFiltros
{
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:self.entidadMenu // otros ejemplos: programa, pais, categoria
                          conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                             enRango:NSMakeRange(1, 0)  // otro ejemplo: NSMakeRange(1, 1) -sólo uno-
                         conDelegate:self];
}


#pragma mark -
#pragma mark Acicones

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
    // Obtener �ndice y slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Si se presion� el mismo que estaba seleccionado, no hacer nada
    if (self.indiceDeFiltroSeleccionado == indice) return;
    
    // Apagar todos los botones y prender el bot�n en cuesti�n
    for (UIButton *btn in [self.menuScrollView subviews]) [btn setSelected:NO];
	[boton setSelected:YES];

    // Calcular nuevo offset para que el bot�n est� centrado
    CGFloat offset = + boton.frame.origin.x
                     + boton.frame.size.width/2.0
                     - self.menuScrollView.frame.size.width/2.0;
    
    // Si el offset es negativo o m�s grande que la barra completa, no centrar el bot�n
    CGFloat maxOffset = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
    if (offset < 0) offset = 0;
    else if (offset > maxOffset) offset = maxOffset;
    
    // Aplicar nuevo offset
    [[self menuScrollView] setContentOffset:CGPointMake(offset, 0) animated:YES];
	
    // Configurar nuevo diccionario de filtros, no filtrar si se us� bot�n "todos"
    [self.diccionarioConfiguracionFiltros setValue:((indice > 0) ? slug : nil) forKey:self.entidadMenu];
    
    // Reinicializar datos, con misma entidad de men� pero nuevo diccionario de confgiruaci�n de filtros 
    [self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
    
    // Actualizamos el boton que debe "seleccionarse"
	self.indiceDeFiltroSeleccionado = indice;
    
    // Re-cargar datos
    // Mostrar vista de loading
    [self mostrarLoadingViewConAnimacion:YES];
    [self cargarClips];
}   

- (void)playerFinalizado:(NSNotification *)notification
{
    // Crear y presentar vista de detalles para el video que acaba de finalizar (�ndice guardado en tag de view)
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:indiceDeClipSeleccionado]];
    [self.navigationController pushViewController:detalleView animated:NO];
    [detalleView release];
    
    // ENviar notificaci�n a Google Analytics
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
    
    self.clips = [NSMutableArray array];
    self.arregloClipsAsyncImageViews = [NSMutableArray array];
    
    
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
    [self mostrarLoadingViewConAnimacion:YES];
    [self cargarFiltros];
    [self cargarClips];
    
	
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
    // N�mero de clips m�s uno para celda "Ver M�s"
    if ([self.clips count] == 0 || self.omitirVerMas)
        return [self.clips count];
    else
        return [self.clips count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Si estamos en la �ltima fila, entonces devolver celda para "Ver m�s"
    if (indexPath.row == [self.clips count])
        return (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"VerMasClipsTableCellView" owner:self options:nil] lastObject];
    
    // Reutilizar o bien crear nueva celda, tipo Grande o Est�ndar
    NSString *nombreNIB = (indexPath.row == 0) ? @"ClipGrandeTableCellView" : @"ClipEstandarTableCellView";    
    ClipEstandarTableCellView *cell = (ClipEstandarTableCellView *)[tableView dequeueReusableCellWithIdentifier:nombreNIB];
    if (cell == nil)
        cell = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:nombreNIB owner:self options:nil] lastObject];
    
    // Si estamos en medio una cosnulta, devolver la celda tal cual est� en el NIB,
    // por ejemplo, si la tabla sigue con inercia despu�s de empezar a cargar datos
    if ([self.clips count] == 0)
        return cell;
    
    // Configurar celda
    
    // Copiar propiedades de thumbnailView (definidas en NIB) y sustitirlo por AsyncImageView correspondiente
    CGRect frame = cell.thumbnailView.frame;
    [cell.thumbnailView removeFromSuperview];
    cell.thumbnailView = [self.arregloClipsAsyncImageViews objectAtIndex:indexPath.row];
    cell.thumbnailView.frame = frame;
    [cell insertSubview:cell.thumbnailView atIndex:1];
 
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
    NSString *nombreNIB;
    CGFloat *cacheVar;
    
    // Determinar nombre de NIB y variable auxiliar de cache
    if (indexPath.row == [self.clips count])
    {
        cacheVar = &celdaVerMasHeight;
        nombreNIB = @"VerMasClipsTableCellView";
    }
    else if (indexPath.row == 0)
    {
        cacheVar = &celdaGrandeHeight;
        nombreNIB = @"ClipGrandeTableCellView";
    }
    else
    {
        cacheVar = &celdaEstandarHeight;
        nombreNIB = @"ClipEstandarTableCellView";
    }
    
    // Si existe, devolver altura en cache
    if (*cacheVar)
        return *cacheVar;
    
    // Si la altura no ha sido guardada en variable de instancia, obtenerla de NIB
    UITableViewCell *celda= (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:nombreNIB owner:self options:nil] lastObject];
    *cacheVar = celda.frame.size.height;
    
    return *cacheVar;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Guardar referencia a �ndice, notificaci�n del player lo necesita
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
        
        // Agregar observer al finalizar reproducci�n
        [[NSNotificationCenter defaultCenter] 
         addObserver:self
         selector:@selector(playerFinalizado:)                                                 
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:movieController.moviePlayer];
        
        [self.clipsTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else // Se trata de la celda "Ver M�s"
    {
        // Actualizar rango y cargar datos
        self.rangoUltimo = NSMakeRange(self.rangoUltimo.location + self.rangoUltimo.length, kTAMANO_PAGINA);
        
        // Bandera para no reemplazar la lista de clips, sino agregar los elementos al final
        self.agregarAlFinal = YES;
        
        [self cargarClips];
    }
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

// Llamado al actualizar desde pull-to-refresh
- (void)reloadTableViewDataSource
{
    // Se va a actualizar la lista, re-inicializar configuraci�n
    [self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
    
    [self cargarClips];
}


#pragma mark -
#pragma mark M�todos redirigidos a PullToReloadTableViewController

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
            [aiv loadImageFromURLString:[NSString stringWithFormat:@"%@", [[self.clips objectAtIndex:i] valueForKey:@"thumbnail_mediano"]]];
            [self.arregloClipsAsyncImageViews insertObject:aiv atIndex:i];
            [aiv release];
        }
        
        self.omitirVerMas = [array count] < kTAMANO_PAGINA;
        
        // Recargar tabla
        [self.clipsTableView reloadData];
        
        // Si la bandera para agregar al final est� apagada, hacer scrolla hasta arriba
        if (!self.agregarAlFinal)
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
        NSMutableDictionary *filtroTodos = [NSMutableDictionary dictionary];
        [filtroTodos setValue:@"Todos" forKey:@"nombre"];
        [filtroTodos setValue:@"todos" forKey:@"slug"];
        [filtroTodos setValue:@"Mostrar todos" forKey:@"descripcion"];
        
        // Insertar filtro como primer elemento del arreglo recibido
        NSMutableArray *arregloAumentado = [NSMutableArray arrayWithArray:array];
        [arregloAumentado insertObject:filtroTodos atIndex:0];
        
        // Actualizar arreglo interno
        self.filtros = arregloAumentado;
        
        // Reconstruir men� con nuevos fitros
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
