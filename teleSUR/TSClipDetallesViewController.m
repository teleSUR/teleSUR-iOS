//
//  TSClipDetallesViewController.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 teleSUR. All rights reserved.
//


#import "TSClipDetallesViewController.h" 
#import "TSClipListadoTableViewController.h"
#import "NSDictionary_Datos.m"
#import "AsynchronousImageView.h"
#import "SHK.h"
#import "GANTracker.h"
#import "TSClipPlayerViewController.h"
#import "teleSURAppDelegate.h"

// TODO: Integrar estas constantes mejor a configuración, quizá plist principal
// Orden de secciones
#define kINFO_SECTION          0
#define kCLASIFICACION_SECTION 1
#define kRELACIONADOS_SECTION  2

// Sección INFO
#define kTITULO_ROW        0
#define kFIRMA_ROW         1
#define kDESCRIOCION_ROW   2


@implementation TSClipDetallesViewController

@synthesize clip;
@synthesize tituloCell, categoriaCell, firmaCell, descripcionCell;
@synthesize descargaData;

@class teleSURAppDelegate;

#pragma mark -
#pragma mark Init

- (id)initWithClip:(NSDictionary *)diccionarioClip
{
    if ((self = [super init]))
    {
        self.clip = diccionarioClip;
    }
    
    return self;
}

#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{   
    self.diccionarioConfiguracionFiltros = [NSMutableDictionary dictionaryWithObject:[self.clip objectForKey:@"slug"] forKey:@"relacionados"];
    self.rangoUltimo = NSMakeRange(1, 5);
    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.omitirVerMas = YES;
    self.agregarAlFinal = YES;
    
    //self.tableViewController.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Fondo2.png"]];
    self.tableViewController.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Ajustar tamanno de celda para descripción
    UILabel *etiquetaDescripcion = (UILabel *)[self.descripcionCell viewWithTag:5];
    CGSize maximumLabelSize = CGSizeMake(262,9999);
    CGSize expectedLabelSize = [[self.clip obtenerDescripcion]
                                   sizeWithFont:etiquetaDescripcion.font 
                              constrainedToSize:maximumLabelSize 
                                  lineBreakMode:etiquetaDescripcion.lineBreakMode];
    self.descripcionCell.frame = CGRectMake(self.descripcionCell.frame.origin.x, self.descripcionCell.frame.origin.y, self.descripcionCell.frame.size.width, expectedLabelSize.height+15);
    self.descripcionCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    etiquetaDescripcion.frame = CGRectMake(etiquetaDescripcion.frame.origin.x, etiquetaDescripcion.frame.origin.y, etiquetaDescripcion.frame.size.width, expectedLabelSize.height);
    
    // Deshabilitar Pull-to-reload
    self.tableViewController.refreshDisabled = YES;
    [self.tableViewController.refreshHeaderView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(marcarPadreParaRecargar)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
    
    self.clip = nil;
    self.tituloCell = nil;
    self.categoriaCell = nil;
    self.firmaCell = nil;
    self.descripcionCell = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Si es un programa, no están definidos sus categorizadores ni sus videos relacionados
    // TODO: mover lógica a NSDictionary,  ej:  (BOOL)[self.clip esPrograma]
    if ([self.clip esPrograma])
        return 2;
    else
        return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case kINFO_SECTION:
            
            ;// Tres filas: título, firma y descripción
            return 3;
            
        case kCLASIFICACION_SECTION:
            
            // Una fila para cada diccionario clasificador
            return [[self.clip arregloDiccionariosClasificadores] count];
            
        case kRELACIONADOS_SECTION:
            
            return [self.clips count];
            
        default:
            
            NSLog(@"sección de tabla no reconocida: %d", section);
            
            return 0;
    } 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case kINFO_SECTION:
            
            switch (indexPath.row)
            {
                case kTITULO_ROW:
                    
                    return self.tituloCell.frame.size.height;
                    
                case kFIRMA_ROW:
                    
                    return self.firmaCell.frame.size.height;

                case kDESCRIOCION_ROW:
                    
                    return self.descripcionCell.frame.size.height;                    
            }
            
        case kCLASIFICACION_SECTION:
            
            return 40.0;
        
        case kRELACIONADOS_SECTION:
            
            ;// TODO: Tomar en cuenta diferentes tamaños de celda
            UITableViewCell *celdaListado = [[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] objectAtIndex:0];
            
            return celdaListado.frame.size.height;
            
        default:
            
            NSLog(@"sección de tabla no reconocida: %d", indexPath.section);
            
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section)
    {
        case kINFO_SECTION:
            
            switch (indexPath.row)
            {
                case kTITULO_ROW:
                    
                    ;// Configurar label para título
                    UILabel *tituloLabel = (UILabel *)[self.tituloCell viewWithTag:1];
                    
                    tituloLabel.text  = [self.clip valueForKey:@"titulo"];
                    
                    CGRect tituloFrame = tituloLabel.frame;
                    CGSize tituloSize = [tituloLabel.text sizeWithFont:tituloLabel.font 
                                                     constrainedToSize:CGSizeMake(tituloFrame.size.width, 9999) 
                                                         lineBreakMode:tituloLabel.lineBreakMode];
                    
                    tituloLabel.frame = CGRectMake(tituloFrame.origin.x, tituloFrame.origin.y, tituloFrame.size.width, tituloSize.height);
                    
                    // Imagen
                    AsynchronousImageView *imageView;
                    if ((imageView = (AsynchronousImageView *)[self.tituloCell viewWithTag:2]))
                    {
                        imageView.url = [NSURL URLWithString:[self.clip valueForKey:@"thumbnail_grande"]];
                        [imageView cargarImagenSiNecesario];
                    }
                    
                    return tituloCell;
                    
                case kFIRMA_ROW:
                    
                    [(UILabel *)[self.firmaCell viewWithTag:4] setText: [self.clip obtenerFirmaParaEsteClip]];
                    
                    return firmaCell;   
                    
                case kDESCRIOCION_ROW:
                    
                    [(UILabel *)[self.descripcionCell viewWithTag:5] setText: [self.clip obtenerDescripcion]];
                    
                    return descripcionCell;
            }
            
        case kCLASIFICACION_SECTION:
            
            ;// Obtener datos de clasificador
            NSDictionary *clasificador = [[self.clip arregloDiccionariosClasificadores] objectAtIndex:indexPath.row];
            
            // Si es corresponsal, anteponer "Corresponsal: " para diferenciarlos de los perosnajes
            // TODO: [clasificador esCorresponsal]
            if ([[clasificador valueForKey:@"nombre"] isEqualToString:@"corresponsal"])
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Corresponsal:", @"Corresponsal:"),[clasificador valueForKey:@"valor"]];
            else
                cell.textLabel.text = [clasificador valueForKey:@"valor"];
            
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            return cell;
        
        case kRELACIONADOS_SECTION:
            
            ;// Celda para video relacionado
            UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            
            return cell;
        
        default:
            
            return cell;
    }
}


#pragma mark - Footers de sección

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case kCLASIFICACION_SECTION:
            
            // Altura de botón para redes sociales
            return 60.0;
            
        default:
            
            return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case kCLASIFICACION_SECTION:
            
            ;// Crear botones para compartir y/o descargar
            
            UIView *container = [[[UIView alloc] init] autorelease];
            
            const SEL compartirSelector = @selector(botonCompartirPresionado:);
            UIButton *botonCompartir = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [botonCompartir addTarget:self action:compartirSelector forControlEvents:UIControlEventTouchUpInside];
            [botonCompartir setTitle:NSLocalizedString(@"Compartir", @"Compartir") forState:UIControlStateNormal];
            [botonCompartir setBackgroundColor:[UIColor clearColor]];
            
            botonCompartir.frame = CGRectMake(30, 10, 120, 35);
            [container addSubview:botonCompartir];
            
            teleSURAppDelegate *appDelegate = (teleSURAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"mp4"]) && !appDelegate.conexionLimitada)
            {
                const SEL descargarSelector = @selector(botonDescargarPresionado:);
                UIButton *botonDescargar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [botonDescargar addTarget:self action:descargarSelector forControlEvents:UIControlEventTouchUpInside];
                [botonDescargar setTitle:NSLocalizedString(@"Descargar", @"Descargar") forState:UIControlStateNormal];
                [botonDescargar setBackgroundColor:[UIColor clearColor]];
                [botonDescargar setTag:110];
                if (self.descargaData)
                {
                    [botonDescargar setEnabled:NO];
                    [botonDescargar setAlpha:0.70];
                }
                
                
                botonDescargar.frame = CGRectMake(170, 10, 120, 35);
                [container addSubview:botonDescargar];
            }
            
            return container;
        
        default:
            
            return nil;
    }
}


#pragma mark - Headers de sección

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section)
    {
        case kINFO_SECTION:
            
            return @"";
            
        case kCLASIFICACION_SECTION:
            
            return @"";// NSLocalizedString(@"Más videos sobre...", @"Más videos sobre...") ;
                    
        case kRELACIONADOS_SECTION:
            
            return NSLocalizedString(@"Videos relacionados",@"Videos relacionados");
        
        default:
            
            NSLog(@"Advertencia: Sección no reconocida: %d", section);
            
            return nil;
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch (indexPath.section)
    {
        case kINFO_SECTION:
            
            if (indexPath.row == kTITULO_ROW)
            {
                ;// Crear y configurar player
                TSClipPlayerViewController *playerController = [[TSClipPlayerViewController alloc] initConClip:self.clip];
                
                // Reproducir video
                [playerController playEnViewController:self
                                  finalizarConSelector:@selector(playerFinalizado:)
                                     registrandoAccion:YES];
            }
            
            break;
            
        case kCLASIFICACION_SECTION:
            
            ;// Crear y mistrar controlador de vista de listado
            NSDictionary *categorizador = [[self.clip arregloDiccionariosClasificadores] objectAtIndex:indexPath.row];
            
            NSDictionary *filtros = [NSDictionary dictionaryWithObject:[categorizador valueForKey:@"slug"] forKey:[categorizador valueForKey:@"nombre"]];
            
            TSClipListadoTableViewController *listadoView = [[TSClipListadoTableViewController alloc] init];
            
            listadoView.diccionarioConfiguracionFiltros = [filtros mutableCopy];
            
            ////listadoView.slugDeFiltroSeleccionado = [categorizador valueForKey:@"slug"];
            [self.navigationController pushViewController:listadoView animated:YES];
            [listadoView release];
            
            break;
        
        case kRELACIONADOS_SECTION:
            
            [super tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }
    
    self.indexPathSeleccionado = indexPath;
}

#pragma mark -
#pragma mark Acciones

- (void)botonCompartirPresionado:(UIButton *)boton
{
    // Crear item para compartir en redes sociales
    NSString *urlBase = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuración"] objectForKey:@"API URL Base"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlBase, [self.clip valueForKey:@"navegador_url"]]];
	SHKItem *item = [SHKItem URL:url title:[self.clip valueForKey:@"titulo"]];
    
	// Crear Action Sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // Mostrar Action Sheet
    teleSURAppDelegate *appDelegate= (teleSURAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // iPad
        [actionSheet showInView:[[appDelegate.window subviews] objectAtIndex:0]];
    } else { // iPhone
        [actionSheet showFromTabBar:[(UITabBarController *)[[appDelegate window] rootViewController] tabBar]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kRELACIONADOS_SECTION)
    {    
        [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    }    
}

- (void)botonDescargarPresionado:(UIButton *)boton;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Descargar video", @"Descargar video") message:@"Se va a descargar este video, puede tardar unos minutos dependiendo de la velocidad de conexión, otro mensaje te avisará cuando la descarga haya finalizado."  delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Continuar", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1)
    {
        [(UIButton *)[self.view viewWithTag:110] setEnabled:NO];
        [(UIButton *)[self.view viewWithTag:110] setAlpha:0.75];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.clip valueForKey:@"archivo_url"]]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:60.0];
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (theConnection)
        {
            self.descargaData = [NSMutableData data];
        }
        else
        {
            // Error
        }
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.descargaData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.descargaData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    self.descargaData = nil;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error de descarga", @"Error de descarga") message:@"Falló la descarga, intenta nuevamente"  delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{  
    NSString *tempPath = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), [NSString stringWithFormat:@"%@.mp4", [self.clip valueForKey:@"titulo"]]];
    
    [self.descargaData writeToFile:tempPath atomically:NO];
    
    UISaveVideoAtPathToSavedPhotosAlbum([[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"mp4"], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    
    [connection release];
    self.descargaData = nil;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (id)contextInfo
{
    if (error == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Descarga finalizada", @"Descarga finalizada") message:@"Finalizó la descarga, el video se encuentra en el rollo de tu cámara."  delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        NSLog(@"Error guardando video: %@", error);
    }
}


- (void)marcarPadreParaRecargar
{
    for (id controller in [self.navigationController viewControllers])
    {
        if ([controller isKindOfClass:[TSClipListadoTableViewController class]])
            [controller setActualizarAlMostrarVista:YES];
    }
   // NSLog(@"aaaa: %@", padre.actualizarAlMostrarVista);
}

- (void)playerFinalizado:(NSNotification *)notification
{
    // Si se terminó de reproducir el video principal, no crear vista de detalles, ya se está en ella
    if (self.indexPathSeleccionado.section == kINFO_SECTION) return;
    
    [super playerFinalizado:notification];
}


- (void)ocultarLoadingViewConAnimacion:(BOOL)animacion
{
    //self.tableViewController.tableView.alpha = 1.0;
    
    //[super ocultarLoadingViewConAnimacion:animacion];
}

- (void)mostrarLoadingViewConAnimacion:(BOOL)animacion
{
    //[super mostrarLoadingViewConAnimacion:animacion];
    
    //self.tableViewController.tableView.alpha = 0.2;
}

@end
