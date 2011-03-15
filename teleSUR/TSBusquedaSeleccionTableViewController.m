//
//  TSBusquedaSeleccion.m
//  teleSUR
//
//  Created by David Regla on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSBusquedaSeleccionTableViewController.h"
#import "TSMultimediaData.h"
#import "TSClipBusquedaViewController.h"


@implementation TSBusquedaSeleccionTableViewController

@synthesize opciones, entidad, seleccion, controladorBusqueda;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:self.entidad // otros ejemplos: programa, pais, categoria
                          conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                             enRango:NSMakeRange(1, 300)  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                         conDelegate:self];
    
    self.title = self.entidad;

    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.controladorBusqueda.selecciones setValue:self.seleccion forKey:self.entidad];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.opciones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    cell.textLabel.text = [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"nombre"];    
    
    
    if ([self.seleccion containsObject: [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]] ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;        
    }

    
    
    // Configure the cell...
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if ([self.seleccion containsObject: [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]])
    {
        [self.seleccion removeObject:[[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]];
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];                
    }
    else
    {
        [self.seleccion addObject:[[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]];
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark -
#pragma mark TSMultimediaDataDelegate

// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    self.opciones = array;
    
    if (!self.seleccion)
        self.seleccion = [NSMutableArray array];
    
    [self.tableView reloadData];
     
    
    // Liberar objeto de datos
    [data release];
}


- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    // TODO: Informar al usuario sobre error
	NSLog(@"Error: %@", error);
    
    // Quitar vista de loading
    //[self ocultarLoadingViewConAnimacion:YES];
    
    // Liberar objeto de datos
    [data release];
}


@end
