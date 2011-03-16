
//
//  TSClipBusquedaViewController.m
//  teleSUR
//
//  Created by David Regla on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipBusquedaViewController.h"
#import "TSBusquedaSeleccionTableViewController.h"
#import "TSClipListadoViewController.h"
#import "TSBusquedaSeleccionFechaViewController.h"
#import "TSBusquedaSeleccionTextoViewController.h"

// TODO: Integrar estas constantes mejor a configuración, quizá plist principal
// Orden de secciones
#define kTEXTO_SECTION         0
#define kCLASIFICACION_SECTION 1
#define kUBICACION_SECTION     2
#define kPERSONAS_SECTION      3
#define kFECHA_SECTION         4

// Sección PALABRAS
#define kTEXTO_ROW 0

// Sección CLASIFICACION
#define kTIPO_ROW      5
#define kCATEGORIA_ROW 0
#define kTEMA_ROW      1

// Sección UBICACION
#define kREGION_ROW   0
#define kPAIS_ROW     1

// Sección PERSONAS
#define kPERSONAJES_ROW   0
#define kCORRESPONSAL_ROW 1

// Sección FECHA
#define kDESDE_ROW   0
#define kHASTA_ROW   1



@implementation TSClipBusquedaViewController

@synthesize selecciones;


#pragma mark - Memoria

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


#pragma mark - Acciones

-(void) botonBuscarPresionado:(UIBarButtonItem *)sender
{
    NSLog(@"selecciones: %@", self.selecciones);
    
    TSClipListadoViewController *controladorResultado  = [[TSClipListadoViewController alloc] initWithEntidad:@"clip" yFiltros:self.selecciones];
    
    [self.navigationController pushViewController:controladorResultado animated:YES];
    
    [controladorResultado release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    self.selecciones = [NSMutableDictionary d
    
    UIBarButtonItem *boton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
                                                                           target:self 
                                                                           action:@selector(botonBuscarPresionado:)];
    
    self.navigationItem.rightBarButtonItem = boton;
    [boton release];
    
    self.selecciones = [NSMutableDictionary dictionaryWithCapacity:10];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case kTEXTO_SECTION:
            
            return 1; // texto
            
        case kCLASIFICACION_SECTION:
            
            return 2; // tipo, categoría, tema
        
        case kUBICACION_SECTION:
            
            return 2; // región, país
        
        case kPERSONAS_SECTION:
            
            return 2; // personajes, corresponsal
        
        case kFECHA_SECTION:
            
            return 2; // desde, hasta
            
        default:
            
            NSLog(@"sección de tabla no reconocida: %d", section);
            
            return 0;
    } 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *CellIdentifier = @"busquedaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *entidad = [self nombreEntidadParaIndexPath:indexPath];
    NSArray *seleccion = [self.selecciones objectForKey:entidad];
    
    switch ([seleccion count])
    {
            case 0:
                cell.detailTextLabel.text = @"Todos";
                break;
            
            case 1:
                cell.detailTextLabel.text = [seleccion objectAtIndex:0];
                break;
            
            default:
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [seleccion count]];
    }
    
    if ([entidad isEqualToString:@"Texto"])
    {
        cell.detailTextLabel.text = @"";
    }
    
    switch (indexPath.section)
    {
        case kTEXTO_SECTION:
            
            cell.textLabel.text = @"Búsqueda de Texto";
            
            break;
            
        case kCLASIFICACION_SECTION:
            
            switch (indexPath.row)
            {
                case kTIPO_ROW:
                    
                    cell.textLabel.text = @"Tipo";
                    
                    break;
                    
                case kCATEGORIA_ROW:
                    
                    cell.textLabel.text = @"Sección";
                    
                    break;
                    
                case kTEMA_ROW:
                    
                    cell.textLabel.text = @"Tema";
                    
                default:
                    
                    break;
            }
            
            break;
            
        case kUBICACION_SECTION:
            
            switch (indexPath.row)
            {
                case kREGION_ROW:
                    
                    cell.textLabel.text = @"Región";
                    
                    break;
                    
                case kPAIS_ROW:
                    
                    cell.textLabel.text = @"País";
                    
                default:
                    
                    break;
            }
            
            break;
            
        case kPERSONAS_SECTION:
            
            switch (indexPath.row)
            {
                case kCORRESPONSAL_ROW:
                    
                    cell.textLabel.text = @"Corresponsal";
                    
                    break;
                    
                case kPERSONAJES_ROW:
                    
                    cell.textLabel.text = @"Personajes";
                    
                default:
                    
                    break;
            }
            
            break;
            
        case kFECHA_SECTION:
            
            switch (indexPath.row)
            {
                case kDESDE_ROW:
                    cell.textLabel.text = @"Desde";
                    
                    break;
                    
                case kHASTA_ROW:
                    
                    cell.textLabel.text = @"Hasta";
                    
                default:
                    
                    break;
            }
            
            break;
            
        default:
            
            break;
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section)
    {
        case kTEXTO_SECTION:
            
            return @"Palabras clave";
            
        case kCLASIFICACION_SECTION:
            
            return @"Clasificación";
            
        case kUBICACION_SECTION:
            
            return @"Ubicación";
            
        case kPERSONAS_SECTION:
            
            return @"Personas";
            
        case kFECHA_SECTION:
            
            return @"Fecha";	
            
        default:
            NSLog(@"Advertencia: Sección Reconocida: %d!", section);
            return @"";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *entidad = [self nombreEntidadParaIndexPath:indexPath];
    
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


- (NSString *)nombreEntidadParaIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case kTEXTO_SECTION:
            
            return @"texto";
            
        case kCLASIFICACION_SECTION:
            
            switch (indexPath.row)
            {
                case kTIPO_ROW:
                    
                    return @"tipo_clip";
                    
                case kCATEGORIA_ROW:
                    
                    return @"categoria";
                    
                case kTEMA_ROW:
                    
                    return @"tema";
            }
            
            break;
            
        case kUBICACION_SECTION:
            
            switch (indexPath.row)
            {
                case kREGION_ROW:
                    
                    return @"ubicacion";
                    
                case kPAIS_ROW:
                    
                    return @"pais";
            }
            
            break;
            
        case kPERSONAS_SECTION:
            
            switch (indexPath.row)
            {
                case kCORRESPONSAL_ROW:
                    
                    return @"corresponsal";
                    
                case kPERSONAJES_ROW:
                    
                    return @"personaje";
            }
            
            break;
            
        case kFECHA_SECTION:
            
            switch (indexPath.row)
            {
                case kDESDE_ROW:
                    
                    return @"fecha";
                    
                case kHASTA_ROW:
                    
                    return @"fecha";
            }
    }
    
    return nil;
}


@end
