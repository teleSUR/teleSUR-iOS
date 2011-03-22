//
//  TSClipBusquedaViewController.m
//  teleSUR
//
//  Created by David Regla on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipBusquedaViewController.h"
#import "TSBusquedaSeleccionTableViewController.h"
#import "TSClipListadoTableViewController.h"
#import "TSBusquedaSeleccionFechaViewController.h"
#import "TSBusquedaSeleccionTextoViewController.h"
#import "UIViewController_Configuracion.h"


#define kALTURA_CELDA 40.0


@implementation TSClipBusquedaViewController

@synthesize selecciones, configuracionSeccionesBusqueda;


#pragma mark - Memoria

- (void)dealloc
{
    self.selecciones = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self personalizarNavigationBar];
    // Cargar arreglo de configuración
    self.configuracionSeccionesBusqueda = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuración"] objectForKey:@"Secciones de Búsqueda"];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Fondo2.png"]];
    
    // Inicializar diccionario para selecciones
    self.selecciones = [NSMutableDictionary dictionary];
    
    // Crear y asignar botón para ejecutar la búsqueda como rightBarButtonItem en la barra de navegación
    UIBarButtonItem *boton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(botonBuscarPresionado:)];
    self.navigationItem.rightBarButtonItem = boton;
    [boton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.configuracionSeccionesBusqueda count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.configuracionSeccionesBusqueda objectAtIndex:section] valueForKey:@"Filas"] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kALTURA_CELDA;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [[self.configuracionSeccionesBusqueda objectAtIndex:section] valueForKey:@"Header"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    // Crear o reutilizar celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"busquedaCell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"busquedaCell"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Obtener datos de configuración para la fila actual
    NSDictionary *fila = [[[self.configuracionSeccionesBusqueda objectAtIndex:indexPath.section] valueForKey:@"Filas"] objectAtIndex:indexPath.row];
    
    // Obtener arreglo de elementos seleccionados para la fila actual
    NSArray *seleccion = [self.selecciones objectForKey:[fila valueForKey:@"Entidad"]];
    
    // Establecer texto de la celda
    cell.textLabel.text = [fila valueForKey:@"Nombre"];
    
    // Establecer detalles de la celda 
    switch ([seleccion count])
    {
        case 0:
            // Texto default para "Todos"
            cell.detailTextLabel.text = [fila valueForKey:@"Todos"];
            break;
            
        case 1:
            // Sólo uno seleccionado, mostrar
            cell.detailTextLabel.text = [seleccion objectAtIndex:0];
            break;
            
        default:
            // Más de uno seleccionado, mostrar número
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [seleccion count]];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *entidad = [[[[self.configuracionSeccionesBusqueda objectAtIndex:indexPath.section] valueForKey:@"Filas"] objectAtIndex:indexPath.row] valueForKey:@"Entidad"];
    
    if ([entidad isEqualToString:@"fecha"])
    {
        TSBusquedaSeleccionFechaViewController *controladorSeleccionFecha = [[TSBusquedaSeleccionFechaViewController alloc] init];
        [self.navigationController pushViewController:controladorSeleccionFecha animated:YES];
        [controladorSeleccionFecha release];
    }
    else if ([entidad isEqualToString:@"texto"])
    {
        TSBusquedaSeleccionTextoViewController *controladorSeleccionTexto = [[TSBusquedaSeleccionTextoViewController alloc] init];
        [self.navigationController pushViewController:controladorSeleccionTexto animated:YES];
        [controladorSeleccionTexto release];
    }
    else
    {
        TSBusquedaSeleccionTableViewController *controladorSeleccion = [[TSBusquedaSeleccionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        controladorSeleccion.entidad = entidad;
        controladorSeleccion.controladorBusqueda = self;
        controladorSeleccion.seleccion = [self.selecciones valueForKey:entidad];
        [self.navigationController pushViewController:controladorSeleccion animated:YES];
        [controladorSeleccion release];
    }
}


#pragma mark - Acciones

- (void)botonBuscarPresionado:(UIBarButtonItem *)boton
{
    // Crear y mostrar controlador de listado con los filtros elegidos
    TSClipListadoTableViewController *controladorResultado  = [[TSClipListadoTableViewController alloc] init];
    controladorResultado.diccionarioConfiguracionFiltros = self.selecciones;
    [self.navigationController pushViewController:controladorResultado animated:YES];
    [controladorResultado release];
}


@end
