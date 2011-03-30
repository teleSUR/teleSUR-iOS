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
#import "UIViewController_Configuracion.h"


@implementation TSBusquedaSeleccionTableViewController

@synthesize opciones, entidad, seleccion, controladorBusqueda, indicadorActividad;
@synthesize indices;

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
    [self personalizarNavigationBar];
    // Indices:
    self.indices = [[NSMutableArray alloc] init];
    nombrePaises = [[NSMutableArray alloc] init];
    
    // Arreglo de elementos elegidos
    if (!self.seleccion) self.seleccion = [NSMutableArray array];
    
    // Obtener arreglo de opciones
    self.opciones = [NSMutableArray array];
    
    if ([self.entidad isEqualToString:@"ubicacion"]) // Si se trata de ubicación, obtener opciones de infoDictionary
    {
        self.opciones = [[[[NSBundle mainBundle] infoDictionary] valueForKey:@"Configuración"] valueForKey:@"Ubicaciones"];
    }
    else // De otro modo obtener opciones de servicio web
    {
        // Inicializar diccionario para filtrar resultado
        NSMutableDictionary *filtros = [NSMutableDictionary dictionary];
        if ([self.entidad isEqualToString:@"pais"])
        {
            // Filtrar sólo 
            if ([self.controladorBusqueda.selecciones valueForKey:@"ubicacion"])
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
    if ([self.entidad isEqualToString:@"ubicacion"] && ![[self.controladorBusqueda.selecciones valueForKey:@"ubicacion"] isEqual:self.seleccion])
    {
        [self.controladorBusqueda.selecciones setObject:[NSMutableArray array] forKey:@"pais"];
    }
    
    
    [self.controladorBusqueda.selecciones setValue:self.seleccion forKey:self.entidad];
    
    [self.controladorBusqueda.tableView reloadData];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    
	if ([self.entidad isEqualToString:@"pais"]) {
        
        if (section != 0) {
            
            return [self.indices objectAtIndex:section-1];
        } else return @"";
        
    }
    else return @"";
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([self.entidad isEqualToString:@"pais"]) return self.indices;
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
    if ([self.entidad isEqualToString:@"pais"]) return [self.indices count]+1;
    else return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return ([self.opciones count]) ? 1 : 0;
    
    if ([self.entidad isEqualToString:@"pais"]) {
        
        //---get the letter in each section; e.g., A, B, C, etc.---
        NSString *alphabet = [self.indices objectAtIndex:section-1];
        
        //---get all states beginning with the letter---
        NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
        NSArray *paises = [nombrePaises filteredArrayUsingPredicate:predicate];
        
        //---return the number of states beginning with the letter---
        return [paises count];   
    }
    
    else return [self.opciones count];
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section > 0 ? 38.0 : 40.0;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    // Para sección "Todos"
    if (indexPath.section == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"Todos", @"Todos");
        
        cell.accessoryType = ([self.seleccion count]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        
        return cell;
    }
    
    if ([self.entidad isEqualToString:@"pais"]) {
        
        //---get the letter in the current section---
        NSString *alphabet = [self.indices objectAtIndex:[indexPath section]-1];
        
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
    else
    {
        cell.textLabel.text = [[self.opciones objectAtIndex:indexPath.row] valueForKey:@"nombre"];    
    }
    
    if ([self.seleccion containsObject: [[self.opciones objectAtIndex:[self indexPathAbsolutoDesdeIndexPath:indexPath].row] valueForKey:@"slug"]] )
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
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
    if (indexPath.section == 0) // Celda "Todos"
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
        if ([self.seleccion containsObject: [[self.opciones objectAtIndex:[[self indexPathAbsolutoDesdeIndexPath:indexPath] row]] valueForKey:@"slug"]]) // Elemento dentro de la selección
        {
            [self.seleccion removeObject:[(NSDictionary *)[self.opciones objectAtIndex:[[self indexPathAbsolutoDesdeIndexPath:indexPath] row]] valueForKey:@"slug"]];
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];   
            
            // Ningún elemento seleccionado
            if ([self.seleccion count] == 0)
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else // Elemento no está seleccionado
        {
            [self.seleccion addObject:[[self.opciones objectAtIndex:[[self indexPathAbsolutoDesdeIndexPath:indexPath] row]] valueForKey:@"slug"]];
            NSLog(@"%@", [[self.opciones objectAtIndex:[[self indexPathAbsolutoDesdeIndexPath:indexPath] row]] valueForKey:@"slug"]);
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
            
            [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
            
            // Todos seleccionados, sólo marcar celda para "Todos"
            if ([self.seleccion count] == [self.opciones count]) {
                [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [self.seleccion removeAllObjects];
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)indexPathAbsolutoDesdeIndexPath:(NSIndexPath *)indexPath
{
    if ([self.entidad isEqualToString:@"pais"])
    {
        int suma=0;
        
        for (int i =1; i<indexPath.section; i++)
        {
            suma += [self tableView:self.tableView numberOfRowsInSection:i];
        }
        
        suma += indexPath.row;
        
        return [NSIndexPath indexPathForRow:suma inSection:1];
        
        
        
    }
    else return indexPath;
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
        if (![self.indices containsObject:uniChar])
        {            
            [self.indices addObject:uniChar];
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
