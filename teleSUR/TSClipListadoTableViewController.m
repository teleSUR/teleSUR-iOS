//
//  TSClipListadoTableViewController.m
//  teleSUR
//
//  Created by David Regla on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipListadoTableViewController.h"
#import "TSClipPlayerViewController.h"
#import "TSClipDetallesViewController.h"
#import "NSDate_Utilidad.h"
#import "NSDictionary_Datos.m"
#import "UIViewController_Configuracion.h"
#import "AsynchronousImageView.h"

#define kTITULO_LABEL_TAG 1
#define kTHUMBNAIL_IMAGE_VIEW_TAG 2
#define kDURACION_LABEL_TAG 3
#define kFIRMA_LBAEL_TAG 4


#define kLOADING_VIEW_TAG 100

@implementation TSClipListadoTableViewController

@synthesize tableViewController;
@synthesize omitirVerMas, actualizarAlMostrarVista;
@synthesize indexPathSeleccionado;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.tableViewController = nil;
    self.indexPathSeleccionado = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self agregarBotonEnVivo];
    }
    [self.view addSubview:self.tableViewController.tableView];
    self.tableViewController.tableView.scrollsToTop = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Registrar notificación para recargar tabla después de regresar del background
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cargarClips)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object:nil];

    // Si ya había un clip seleccionado, asegurar que esté marcado 
    if (self.indexPathSeleccionado && animated)
        [self.tableViewController.tableView selectRowAtIndexPath:self.indexPathSeleccionado animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Si ya había un clip seleccionado, desmarcarlo con animación
    if (self.indexPathSeleccionado && animated)
        [self.tableViewController.tableView deselectRowAtIndexPath:self.indexPathSeleccionado animated:animated];
    
    if (self.actualizarAlMostrarVista)
    {
        [self cargarClips];
        self.actualizarAlMostrarVista = NO;
    }
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
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}



- (void)playerFinalizado:(NSNotification *)notification
{
    // Crear y presentar vista de detalles para el video que acaba de finalizar (índice guardado en tag de view)
    
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:self.indiceDeClipSeleccionado]];
    [self.navigationController pushViewController:detalleView animated:NO];
    [detalleView release];
    
    //
    // Un posible momento para insertar publicidad
    //
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
    UILabel *duracionLabel = (UILabel *)[cell viewWithTag:kDURACION_LABEL_TAG];
    UILabel *firmaLabel = (UILabel *)[cell viewWithTag:kFIRMA_LBAEL_TAG];
    
    // Establecer texto de etiquetas
    tituloLabel.text = [[self.clips objectAtIndex:indexPath.row] valueForKey:@"titulo"];
    duracionLabel.text = [[self.clips objectAtIndex:indexPath.row] valueForKey:@"duracion"];	
    if ([[self.clips lastObject] esPrograma]) {
        firmaLabel.text = [[self.clips objectAtIndex:indexPath.row] obtenerFechaConDia];
    } else {
        firmaLabel.text = [[self.clips objectAtIndex:indexPath.row] obtenerTiempoDesdeParaEsteClip];
    }
    
    return cell;        
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.clips count] || self.omitirVerMas)
    {
        
        AsynchronousImageView *thumbnailImageView = (AsynchronousImageView *)[cell viewWithTag:kTHUMBNAIL_IMAGE_VIEW_TAG];
        
        if (indexPath.row >= [self.arregloClipsAsyncImageViews count])
        {
            [self.arregloClipsAsyncImageViews addObject:thumbnailImageView];
            thumbnailImageView.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.clips objectAtIndex:indexPath.row] valueForKey:@"thumbnail_mediano"]]];
            [thumbnailImageView cargarImagenSiNecesario];
        }
        else
        {
            [[thumbnailImageView superview] addSubview:[self.arregloClipsAsyncImageViews objectAtIndex:indexPath.row]];
            
            [thumbnailImageView removeFromSuperview];            
        }
    }
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat *cacheVar;
    
    // Determinar variable auxiliar cache para cargar NIB una sola vez
    if (indexPath.row == 0)                       cacheVar = &celdaEstandarHeight;
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
    self.indexPathSeleccionado = indexPath;
    self.indiceDeClipSeleccionado = indexPath.row;
    
    if (self.indiceDeClipSeleccionado < [self.clips count] || self.omitirVerMas) // Se trata de un video
    {
        // Crear y configurar player
        TSClipPlayerViewController *playerController = [[TSClipPlayerViewController alloc] initConClip:[self.clips objectAtIndex:indexPath.row]];
        
        // Reproducir video
        [playerController playEnViewController:self
                          finalizarConSelector:@selector(playerFinalizado:)
                             registrandoAccion:YES];
        
    }
    else // Se trata de la celda "Ver Más"
    {
        // Actualizar rango y cargar datos
        self.rangoUltimo = NSMakeRange(self.rangoUltimo.location + self.rangoUltimo.length, TSNumeroClipsPorPagina);
        
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
    self.indexPathSeleccionado = indexPath;
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
    //////[self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
    self.rangoUltimo = NSMakeRange(1, TSNumeroClipsPorPagina);
    
    [self cargarClips];
}


#pragma mark -
#pragma mark Métodos redirigidos a PullToReloadTableViewController

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView { [self.tableViewController scrollViewWillBeginDragging:scrollView]; }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView { [self.tableViewController scrollViewDidScroll:scrollView]; }

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate { [self.tableViewController scrollViewDidEndDragging:scrollView willDecelerate:decelerate]; }



// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    [super TSMultimediaData:data entidadesRecibidas:array paraEntidad:entidad];
    
    if (entidad == TSEntidadClip)
    {
        // Si parece que no hay más elementos, no mostrar celda "ver más"
        self.omitirVerMas = [array count] < TSNumeroClipsPorPagina;
        
        // Recargar tabla
        [self.tableViewController.tableView reloadData];
        
        // Si la bandera para agregar al final está apagada, hacer scroll hasta arriba
        if (!self.agregarAlFinal && [self.clips count])
        {
            [self.tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        self.agregarAlFinal = NO;
        
        // Actualizar datos para la vista de pull-to-refresh
        [self.tableViewController setLastUpdate:[NSDate date]];
        [self.tableViewController dataSourceDidFinishLoadingNewData];
    }
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    //UIView *vistaLoading =  [self.view viewWithTag:kLOADING_VIEW_TAG];
    //vistaLoading.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.00];
    //[(UIActivityIndicatorView *) [vistaLoading viewWithTag:9] stopAnimating];
    //[(UILabel *) [vistaLoading viewWithTag:10] setText:@"Error de Conexión"];
    [self cargarClips];
    
}

- (void)ocultarLoadingViewConAnimacion:(BOOL)animacion
{
    if (animacion)
    {
        [UIView beginAnimations:@"mostrarTableView" context:nil];
        self.tableViewController.tableView.alpha = 1.0;
        [UIView commitAnimations];
    }
    else
    {
        self.tableViewController.tableView.alpha = 1.0;
    }
    
    [super ocultarLoadingViewConAnimacion:animacion];
}

- (void)mostrarLoadingViewConAnimacion:(BOOL)animacion
{
    if (animacion)
    {
        [UIView beginAnimations:@"opacarTableView" context:nil];
        self.tableViewController.tableView.alpha = 0.3;
        [UIView commitAnimations];
    }
    else
    {
        self.tableViewController.tableView.alpha = 0.3;
    }
    
    [super mostrarLoadingViewConAnimacion:animacion];
}



@end