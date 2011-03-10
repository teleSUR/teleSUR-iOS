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
    // Provisional
   // [(UILabel *)[self.view viewWithTag:1] setText:[clip valueForKey:@"descripcion"]];
    //[(UIImageView *)[self.view viewWithTag:2] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [clip valueForKey:@"thumbnail_grande"]]]]]];
    [super viewDidLoad];

    UILabel *etiquetaDescripcion = (UILabel *)[self.descripcionCell viewWithTag:5] ;

    CGSize maximumLabelSize = CGSizeMake(262,9999);
    
    CGSize expectedLabelSize = [[self.clip valueForKey:@"descripcion"]
                                  sizeWithFont:etiquetaDescripcion.font 
                                      constrainedToSize:maximumLabelSize 
                                          lineBreakMode:etiquetaDescripcion.lineBreakMode]; 



    self.descripcionCell.frame = CGRectMake(self.descripcionCell.frame.origin.x, self.descripcionCell.frame.origin.y, self.descripcionCell.frame.size.width, expectedLabelSize.height+15);
    
    
    etiquetaDescripcion.frame = CGRectMake(etiquetaDescripcion.frame.origin.x, etiquetaDescripcion.frame.origin.y, etiquetaDescripcion.frame.size.width, expectedLabelSize.height);    
    
    NSLog(@"%@", [self.clip arregloDiccionariosClasificadores]);
}


-(void)viewDidAppear:(BOOL)animated 
{
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section)
    {
        case kINFO_SECTION:
            return 3;
        case kCLASIFICACION_SECTION:
            return [[self.clip arregloDiccionariosClasificadores] count];
        default:
            return 0;
    } 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return self.tituloCell.frame.size.height;
                    break;
                case 1:
                    return self.firmaCell.frame.size.height;
                    break;
                case 2:
            
                    
                    
                    return self.descripcionCell.frame.size.height;                    
                    break;
                
            }   
            
            break;
            
        default:
            return 45.0;
            break;
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
                    
                    [(UILabel *)[self.tituloCell viewWithTag:1] setText: [self.clip valueForKey:@"titulo"]];
                    
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            ;
            
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
            
            [self.detallesTableView deselectRowAtIndexPath:indexPath animated:NO];
            break;
            
        case 1:
            
            ;
            
            TSClipListadoViewController *listadoView =[[TSClipListadoViewController alloc] init];
            
            [self.navigationController pushViewController:listadoView animated:YES];
            
            [listadoView release];

            
            
            break;
            
        default:
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


#pragma mark -
#pragma mark TSMultimediaDataDelegate

// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    
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
