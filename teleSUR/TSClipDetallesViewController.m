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

#define kDETALLES_SECTION 0
#define kCLASIFICACION_SECTION 1


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
    // Do any additional setup after loading the view from its nib.
    
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
        case kDETALLES_SECTION:
            return 1;
        case kCLASIFICACION_SECTION:
            return [[self.clip arregloDiccionariosClasificadores] count];
        default:
            return 0;
    } 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return self.descripcionCell.frame.size.height;
            }
            break;
            
        default:
            return 45.0;
            break;
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ACell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section)
    {
        case 0:
            if (indexPath.row == 0)
            {
                [(UILabel *)[self.descripcionCell viewWithTag:1] setText: [self.clip valueForKey:@"titulo"]];
              //  [(UILabel *)[self.descripcionCell viewWithTag:4] setText: [self.clip obtenerTiempoDesdeParaEsteClip]];
                [(UILabel *)[self.descripcionCell viewWithTag:5] setText: [self.clip valueForKey:@"descripcion"]];
                
                AsynchronousImageView *imageView = (AsynchronousImageView *)[self.descripcionCell viewWithTag:2];
                
                // Copiar propiedades de thumbnailView (definidas en NIB) y sustitirlo por AsyncImageView correspondiente
                CGRect frame = imageView.frame;
                [imageView removeFromSuperview];
                
                AsynchronousImageView *aiv = [[AsynchronousImageView alloc] init];
                
                [aiv loadImageFromURLString:[self.clip valueForKey:@"thumbnail_grande"]];
                aiv.frame = frame;
                [self.descripcionCell addSubview:aiv];
                
                [aiv release];
                
                return descripcionCell;
            }
            
        default:
            cell.textLabel.text = [[[self.clip arregloDiccionariosClasificadores] objectAtIndex:indexPath.row] valueForKey:@"valor"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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




@end
