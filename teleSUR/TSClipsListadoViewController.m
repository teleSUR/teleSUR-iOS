//
//  TSClipsListadoViewController.m
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "TSClipsListadoViewController.h"
#import "TSMultimediaData.h"
#import "TSClipDetallesViewController.h"

#import "ClipEstandarTableCellView.h"
#import "NSDictionary_Utilidad.h"

#define kMARGEN_MENU 20
#define kTAMANO_PAGINA 6


@implementation TSClipsListadoViewController

@synthesize entidadMenu, rango, diccionarioFiltros;
//@synthesize clipsTableViewController;  ???
@synthesize clipsTableView, menuScrollView;
@synthesize clips, filtros;

#pragma mark -
#pragma mark Init

- (id)initWithEntidadMenu: (NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
	if ((self = [super init]))
    {
		self.entidadMenu = entidad;
		self.diccionarioFiltros = diccionario;
		self.rango = NSMakeRange(1, kTAMANO_PAGINA);
	}
	
	return self;
}

#pragma mark -

- (void)actualizarDatos: (UIButton *)boton
{
    // Obtener slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Configurar nuevo diccionario de filtros
    self.diccionarioFiltros = [NSDictionary dictionaryWithObject:slug forKey:@"categoria"];
    
    // Cargar datos
    [self cargarDatos];
}

- (void)construirMenu 
{
    // Retirar todos los botones del menú, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + kMARGEN_MENU;
    
    // Recorrer filtros
    for (int i=0; i<[self.filtros count]; i++)
    {
        // Crear nuevo botón para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acción del botón
        [boton addTarget:self action:@selector(actualizarDatos:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // Configurar label de botón
        [boton setTitle:[[self.filtros objectAtIndex:i] valueForKey:@"nombre"] forState:UIControlStateNormal];
        boton.titleLabel.text = [[self.filtros objectAtIndex:i] valueForKey:@"nombre"];
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];
        boton.titleLabel.textColor = [UIColor whiteColor];
        
        // Ajustar tamaño de frame del botón con base en el volumen del texto
		CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
		boton.frame = CGRectMake(offsetX, boton.frame.origin.y, textoSize.width, self.menuScrollView.frame.size.height);
        
        // Actualizar offset
        offsetX += boton.frame.size.width + kMARGEN_MENU;
        
        // Añadir botón a la jerarquía de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir área de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
}

- (void)cargarDatos
{
    // Inicializar arreglos
    self.clips = nil;
    self.filtros = nil;
    
    // Mostrar vista de loading
    [self mostrarLoadingViewConAnimacion:NO];
    
    // Obtener clips
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:@"clip" // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -sólo uno-
                       conDelegate:self];

    
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:@"categoria" // otros ejemplos: programa, pais, categoria
                        conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -sólo uno-
                       conDelegate:self];
	
	
	
	
	
    
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{	
	imagenesTemp = [[NSMutableArray alloc] initWithCapacity:10];
	[self personalizarNavigationBar];
    [self cargarDatos];
	
    [super viewDidLoad];

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.clips count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CeldaEstandar";
    
    ClipEstandarTableCellView *cell = (ClipEstandarTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
		cell = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];
	}
     
    [cell.thumbnailView setImage: [imagenesTemp objectAtIndex:indexPath.row]];
	[cell.titulo setText: [[self.clips objectAtIndex:indexPath.row] valueForKey:@"titulo"]];
	[cell.duracion setText: [[self.clips objectAtIndex:indexPath.row] valueForKey:@"duracion"]];	
	[cell.firma setText:[[self.clips objectAtIndex:indexPath.row] obtenerFirmaParaEsteClip]];
	
	
	return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

		
	UITableViewCell *celda = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];
	
	return celda.frame.size.height;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[self.clips objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detalleView animated:YES];
    
    [detalleView release];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
    DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    self.clips = nil;
    self.filtros = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark TSMultimediaDataDelegate

- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    if ([entidad isEqualToString:@"clip"])
    {
        // En caso de haber recibido entidades de tipo clip, asignar arreglo clips
        self.clips = array;
        
		// Cargar arreglo temporal de imagenes:
		for (int i = 0; i < [self.clips count]; i++) {
			
			[imagenesTemp addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://stg.multimedia.tlsur.net/media/%@", [[self.clips objectAtIndex:i] valueForKey:@"imagen"]]]]]];
			
		}
		
		
        // Recargar tabla con nuevos datos
        [self.clipsTableView reloadData];
    }
    else
    {
        // En caso de haber recibido cualquier otro tipo de entidad, es para filtros
        self.filtros = array;
        
        // Reconstruir menú con nuevos fitros
        [self construirMenu];
    }
    
    // Ocultar vista de loading sólo cuando ya se han cargado los datos tanto para clips como para filtros
    if (self.clips != nil && self.filtros != nil) [self ocultarLoadingViewConAnimacion:NO];
    
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

