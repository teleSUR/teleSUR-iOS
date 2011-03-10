//
//  TSClipDetallesViewController.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 teleSUR. All rights reserved.
//


#import "TSClipDetallesViewController.h" 
#import <MediaPlayer/MediaPlayer.h>
#import "TSClipListadoViewController.h"
#import "NSDictionary_Datos.m"
#import "AsynchronousImageView.h"
#import "SHK.h"
#import "GANTracker.h"

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
@synthesize detallesTableView, detallesTableViewController;
@synthesize tituloCell, categoriaCell, firmaCell, descripcionCell;
@synthesize relacionadosTableViewController, relacionadosTableView;
@synthesize indexPathSeleccionado;

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
    [super viewDidLoad];
    
    UILabel *etiquetaDescripcion = (UILabel *)[self.descripcionCell viewWithTag:5];

    CGSize maximumLabelSize = CGSizeMake(262,9999);
    
    CGSize expectedLabelSize = [[self.clip valueForKey:@"descripcion"]
                                  sizeWithFont:etiquetaDescripcion.font 
                                      constrainedToSize:maximumLabelSize 
                                          lineBreakMode:etiquetaDescripcion.lineBreakMode];
    
    self.descripcionCell.frame = CGRectMake(self.descripcionCell.frame.origin.x, self.descripcionCell.frame.origin.y, self.descripcionCell.frame.size.width, expectedLabelSize.height+15);
    etiquetaDescripcion.frame = CGRectMake(etiquetaDescripcion.frame.origin.x, etiquetaDescripcion.frame.origin.y, etiquetaDescripcion.frame.size.width, expectedLabelSize.height);    
}


-(void)viewDidAppear:(BOOL)animated 
{
    [self.detallesTableView deselectRowAtIndexPath:self.indexPathSeleccionado animated:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.detallesTableView = nil;
    self.detallesTableViewController = nil;
    self.clip = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case kINFO_SECTION:
            
            // Tres filas: título, firma y descripción
            return 3;
            
        case kCLASIFICACION_SECTION:
            
            // Una fila para cada diccionario clasificador
            return [[self.clip arregloDiccionariosClasificadores] count];
            
        case kRELACIONADOS_SECTION:
            
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
            
            //TODO: relacionados
            
            return 0;
            
        default:
            
            NSLog(@"sección de tabla no reconocida: %d", indexPath.section);
            
            return 0;
    }
}


// Customize the appearance of table view cells.
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
                        CGRect frame = imageView.frame;
                        [imageView removeFromSuperview];
                        
                        imageView = [[AsynchronousImageView alloc] init];
                        [imageView loadImageFromURLString:[self.clip valueForKey:@"thumbnail_grande"]];
                        imageView.frame = frame;
                        [self.tituloCell addSubview:imageView];
                        [imageView release];	
                    }
                    
                    return tituloCell;
                    
                case kFIRMA_ROW:
                    
                    [(UILabel *)[self.firmaCell viewWithTag:4] setText: [self.clip obtenerTiempoDesdeParaEsteClip]];
                    
                    return firmaCell;   
                    
                case kDESCRIOCION_ROW:
                    
                    [(UILabel *)[self.descripcionCell viewWithTag:5] setText: [self.clip valueForKey:@"descripcion"]];
                    
                    return descripcionCell;
            }
            
        case kCLASIFICACION_SECTION:
            
            cell.textLabel.text = [[[self.clip arregloDiccionariosClasificadores] objectAtIndex:indexPath.row] valueForKey:@"valor"];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            return cell;
        
        case kRELACIONADOS_SECTION:
            
            // TODO: Videos relacionados
            // IDEA: proxy redirigir mensaje a datadelegate de tabla de clips, sólo para esta sección
            return cell;
        
        default:
            
            return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case kINFO_SECTION:
            
            return 0;
            
        case kCLASIFICACION_SECTION:
            
            return 20.0;
            
        case kRELACIONADOS_SECTION:
            
            return 20.0;
            
        default:
            
            NSLog(@"Sección de tabla no reconocida: %d", section);
            
            return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    
    switch (section)
    {
        case kINFO_SECTION:
            
            return nil;
            
        case kCLASIFICACION_SECTION:
            
            label.text = @"Más videos de...";
            
            break;
            
        case kRELACIONADOS_SECTION:
            
            label.text = @"Videos relacionados";
            
            break;
    }
    
    label.text = [NSString stringWithFormat:@"   %@", label.text];
    return label;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathSeleccionado = indexPath;
    
    switch (indexPath.section)
    {
        case kINFO_SECTION:
            
            if (indexPath.row == kTITULO_ROW)
            {
                NSString *stringURL = [NSString stringWithFormat:@"%@", [self.clip valueForKey:@"archivo_url"]];
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
            
            break;
            
        case kCLASIFICACION_SECTION:
            
            ;// Crear y mistrar controlador de vista de listado
            NSDictionary *categorizador = [[self.clip arregloDiccionariosClasificadores] objectAtIndex:indexPath.row];
            
            NSDictionary *filtros = [NSDictionary dictionaryWithObject:[categorizador valueForKey:@"slug"] forKey:[categorizador valueForKey:@"nombre"]];
            
            TSClipListadoViewController *listadoView = [[TSClipListadoViewController alloc] initWithEntidad:[categorizador valueForKey:@"nombre"] yFiltros:filtros];
            listadoView.slugDeFiltroSeleccionado = [categorizador valueForKey:@"slug"];
            [self.navigationController pushViewController:listadoView animated:YES];
            [listadoView release];
            
            break;
        
        case kRELACIONADOS_SECTION:
            
            break;
    }
}

#pragma mark -
#pragma mark Acciones

- (IBAction)botonRedesSocialesPresionado:(id)boton
{
    // Crear item para compartir en redes sociales
	NSURL *url = [NSURL URLWithString:@"http://multimedia.telesurtv.net/"];
	SHKItem *item = [SHKItem URL:url title:@"Awesome!"];
    
	// Crear Action Sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // Mostrar Action Sheet
    // TODO: OJO, puede cambiar en iPad, damos por hecho que window de appdelegate tiene un rootViewController
    //       de clase UITabBarController. qué otra forma habrá de referenciar al TabBar? o de insertar el action sheet?
    teleSURAppDelegate *appDelegate= (teleSURAppDelegate *)[[UIApplication sharedApplication] delegate];
    [actionSheet showFromTabBar:[(UITabBarController *)[[appDelegate window] rootViewController] tabBar]];
}


- (void)playerFinalizado:(NSNotification *)notification
{
    // Crear y presentar vista de detalles para el video que acaba de finalizar (índice guardado en tag de view)
    // ENviar notificación a Google Analytics
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"iPhone"
                                         action:@"Video reproducido"
                                          label:[self.clip valueForKey:@"archivo"]
                                          value:-1
                                      withError:&error])
    {
        NSLog(@"Error");
    }
    
    //
    // Un posible momento para insertar publicidad
    //
}


@end
