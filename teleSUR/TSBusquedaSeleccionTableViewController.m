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

@synthesize opciones, entidad, seleccion, controladorBusqueda, indicadorActividad;

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
    // Indices:
    indices = [[NSMutableArray alloc] init];
    nombrePaises = [[NSMutableArray alloc] init];
    
    if (!self.seleccion)
        self.seleccion = [NSMutableArray array];
    
    self.opciones = [NSMutableArray array];
    
    if ([self.entidad isEqualToString:@"ubicacion"])
    {
        self.opciones = [[[[NSBundle mainBundle] infoDictionary] valueForKey:@"Configuración"] valueForKey:@"Ubicaciones"];
    }
    else
    {
        NSMutableDictionary *filtros = [NSMutableDictionary dictionary];
        if ([self.entidad isEqualToString:@"pais"])
        {
            [filtros setObject:[self.controladorBusqueda.selecciones valueForKey:@"ubicacion"] forKey:@"ubicacion"];
        }
        
        self.indicadorActividad = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150.0, 174.0, 20, 20)];
        [self.indicadorActividad startAnimating];
        [self.view addSubview: self.indicadorActividad];
        
        TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
        [dataFiltros getDatosParaEntidad:self.entidad // otros ejemplos: programa, pais, categoria
                              conFiltros:filtros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                                 enRango:NSMakeRange(1, 300)  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                             conDelegate:self];
    }
    
    self.title = self.entidad;

    // Indices
    
    
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
    
    
    [self.controladorBusqueda.tableView reloadData];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    
	if ([self.entidad isEqualToString:@"pais"]) {
        
        if (section != 0) {
            
            return [indices objectAtIndex:section-1];
        } else return @"";
        
    }
    else return @"";
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([self.entidad isEqualToString:@"pais"]) return indices;
    else return nil;
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([self.entidad isEqualToString:@"pais"]) return index+1;
    else return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self.entidad isEqualToString:@"pais"]) return [indices count]+1;
    else return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return ([self.opciones count]) ? 1 : 0;
    
    if ([self.entidad isEqualToString:@"pais"]) {
        
        //---get the letter in each section; e.g., A, B, C, etc.---
        NSString *alphabet = [indices objectAtIndex:section-1];
        
        //---get all states beginning with the letter---
        NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        NSArray *paises = [nombrePaises filteredArrayUsingPredicate:predicate];
        
        //---return the number of states beginning with the letter---
        return [paises count];   
    }
    
    else return [self.opciones count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section > 0 ? 38.0 : 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"Todos", @"Todos");
        
        cell.accessoryType = ([self.seleccion count]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        
        return cell;
    }
    
    if ([self.entidad isEqualToString:@"pais"]) {
        
        //---get the letter in the current section---
        NSString *alphabet = [indices objectAtIndex:[indexPath section]-1];
        
        //---get all states beginning with the letter---
        NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        NSArray *paisesFiltrado = [nombrePaises filteredArrayUsingPredicate:predicate];
        
        //---extract the relevant state from the states object---
        NSString *cellValue = [paisesFiltrado objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
        
        /*
        cell.textLabel.text = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
                           objectAtIndex:indexPath.row];*/
    }
    else {
        cell.textLabel.text = [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"nombre"];    
        
        if ([self.seleccion containsObject: [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]] ) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;        
        }
        
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
    if (indexPath.section == 0)
    {
        [self.seleccion removeAllObjects];
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        for (int i=0; i<[self.opciones count]; i++)
        {
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]] setAccessoryType:UITableViewCellAccessoryNone];                
        }
    }
    else
    {
        // Navigation logic may go here. Create and push another view controller.
        if ([self.seleccion containsObject: [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]])
        {
            [self.seleccion removeObject:[[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]];
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];   
            
            if ([self.seleccion count] == 0)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [self.seleccion addObject:[[self.opciones objectAtIndex:indexPath.row] valueForKey:@"slug"]];
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
            
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
            
            if ([self.seleccion count] == [self.opciones count]) {
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [self.seleccion removeAllObjects];
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark TSMultimediaDataDelegate

// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{


    
    [self.indicadorActividad stopAnimating];   
    
    //[self.opciones addObject:[NSDictionary dictionaryWithObject:@"Todos" forKey:@"nombre" ]];
    
    [self.opciones addObjectsFromArray:array];
    

    
    for (NSDictionary *diccionario in self.opciones) {
        [nombrePaises addObject: [diccionario valueForKey:@"nombre"] ];
    }
    
    for (int i=0; i<[nombrePaises count]-1; i++){
        //---get the first char of each state---
        char alphabet = [[nombrePaises objectAtIndex:i] characterAtIndex:0];
        NSString *uniChar = [NSString stringWithFormat:@"%C", alphabet];
        
        //---add each letter to the index array---
        if (![indices containsObject:uniChar])
        {            
            [indices addObject:uniChar];
        }        
    }

    
    
    //NSLog(@":::: %@", self.opciones);
    
    [self.tableView reloadData];
     
    
    // Liberar objeto de datos
    [data release];
}


- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    [self.indicadorActividad stopAnimating];    
    
    // TODO: Informar al usuario sobre error
	NSLog(@"Error: %@", error);
    
    // Quitar vista de loading
    //[self ocultarLoadingViewConAnimacion:YES];
    
    // Liberar objeto de datos
    [data release];
}


@end
