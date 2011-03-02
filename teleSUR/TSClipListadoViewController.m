//
//  TSClipListadoViewController.m
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "TSClipListadoViewController.h"
#import "TSMultimediaData.h"
#import "TSClipDetallesViewController.h"
#import "AsynchronousImageView.h"

#import "ClipEstandarTableCellView.h"
#import "NSDictionary_Datos.h"

#define kMARGEN_MENU 15
#define kTAMANO_PAGINA 6
#define kTagBotonesMenu 1024

@implementation TSClipListadoViewController

@synthesize entidadMenu, rango, diccionarioFiltros;
@synthesize clipsTableView, menuScrollView;
@synthesize clips, filtros;
@synthesize imageViews;
@synthesize indiceDeBotonSeleccionado;


#pragma mark -
#pragma mark Init

- (id)initWithEntidadMenu:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
{
	if ((self = [super init]))
    {
		self.entidadMenu = entidad;
		self.diccionarioFiltros = diccionario;
		self.rango = NSMakeRange(1, kTAMANO_PAGINA);
		self.indiceDeBotonSeleccionado = -1;
	}
	
	return self;
}

#pragma mark -

- (void)actualizarDatos:(UIButton *)boton
{
	 
    // Obtener slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton] - 1;
	
	// Actualizamos el boton que debe "seleccionarse"
	 
	self.indiceDeBotonSeleccionado = indice;
	
	// Mantener el boton seleccionado
	[boton setSelected:YES];
	
	NSString *slug;
	
	if (indice==-1) slug = @"";
		
    else slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Configurar nuevo diccionario de filtros
    self.diccionarioFiltros = [NSDictionary dictionaryWithObject:slug forKey:@"categoria"];
    
    // Cargar datos
    [self cargarDatos];
}

- (void)construirMenu 
{
    // Retirar todos los botones del men煤, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + kMARGEN_MENU;

	// OJO: Revisar BUG esta expresi梟:
	//	for (int i = -1; i < [self.filtros count]; i++)
    // Recorrer filtros
    for (float i = -1; i < [self.filtros count]; i++)
    {
        // Crear nuevo bot贸n para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acci贸n del bot贸n
        [boton addTarget:self action:@selector(actualizarDatos:) forControlEvents:(UIControlEventTouchUpInside)];

		boton.tag = kTagBotonesMenu;
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];        
		
        // Configurar label de bot贸n
		if (i==-1) {
			[boton setTitle:@"Todos" forState:UIControlStateNormal]; 

		}
		else { 
			[boton setTitle:[[self.filtros objectAtIndex:i] valueForKey:@"nombre"] forState:UIControlStateNormal];

		}
		
		// Configurar 2 colores para denotar un boton seleccionado
		[boton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
		[boton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];		
		[boton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];		// boton en estado normal
		
		if (i == self.indiceDeBotonSeleccionado) [boton setSelected:YES];
		else [boton setSelected:NO];
        
        // Ajustar tama帽o de frame del bot贸n con base en el volumen del texto
		CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
		boton.frame = CGRectMake(offsetX, boton.frame.origin.y, textoSize.width, self.menuScrollView.frame.size.height);
        
        // Actualizar offset
        offsetX += boton.frame.size.width + kMARGEN_MENU;
        
        // A帽adir bot贸n a la jerarqu铆a de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir 噐ea de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
}

- (void)cargarDatos
{
    // Inicializar arreglos
    self.clips = nil;
    self.filtros = nil;
    
    // Mostrar vista de loading
    [self mostrarLoadingViewConAnimacion:NO];

	// Regresar el scroll de la tabla a la parte superior
	[self.clipsTableView setContentOffset:CGPointMake(0, 0) animated:NO];
	
	
    // Obtener clips
	TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:@"clip" // otros ejemplos: programa, pais, categoria
                        conFiltros:self.diccionarioFiltros // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -s贸lo uno-
                       conDelegate:self];

    
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:@"categoria" // otros ejemplos: programa, pais, categoria
                        conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -s贸lo uno-
                       conDelegate:self];
    
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{	
	
	self.indiceDeBotonSeleccionado = -1;	
	[self personalizarNavigationBar];
    [self cargarDatos];
    self.imageViews = [NSMutableArray array];
	
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.clips count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"CeldaEstandar";
    
    ClipEstandarTableCellView *cell = (ClipEstandarTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
		cell = (ClipEstandarTableCellView *)[[[NSBundle mainBundle] loadNibNamed:@"ClipEstandarTableCellView" owner:self options:nil] lastObject];
	}
    
    // Copiar propiedades de thumbnailView (definidas en NIB) y sustitirlo por AsyncImageView correspondiente
    CGRect frame = cell.thumbnailView.frame;
    [cell.thumbnailView removeFromSuperview];
    cell.thumbnailView = [self.imageViews objectAtIndex:indexPath.row];
    cell.thumbnailView.frame = frame;
    [cell addSubview:cell.thumbnailView];
    
    // Establecer texto de etiquetas
	[cell.titulo setText: [[self.clips objectAtIndex:indexPath.row] valueForKey:@"titulo"]];
	[cell.duracion setText: [[self.clips objectAtIndex:indexPath.row] valueForKey:@"duracion"]];	
	[cell.firma setText:[[self.clips objectAtIndex:indexPath.row] obtenerFirmaParaEsteClip]];
	
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


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{		
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    self.clips = nil;
    self.filtros = nil;
    self.imageViews = nil;
}


- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark TSMultimediaDataDelegate

- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    if ([entidad isEqualToString:@"clip"])
    {
        // Agregar vistas para las im噂enes al arreglo imageViews
        AsynchronousImageView *iv;
        [imageViews removeAllObjects];
        for (int i=0; i<[array count]; i++)
        {
            iv = [[AsynchronousImageView alloc] init];
            [iv loadImageFromURLString:[NSString stringWithFormat:@"http://stg.multimedia.tlsur.net/media/%@", [[array objectAtIndex:i] valueForKey:@"imagen"]]];
            [self.imageViews addObject:iv];
            [iv release];
        }
        
        
        // En caso de haber recibido entidades de tipo clip, asignar arreglo clips
        self.clips = array;
		
        // Recargar tabla con nuevos datos
        [self.clipsTableView reloadData];
    }
    else
    {
        // En caso de haber recibido cualquier otro tipo de entidad, es para filtros
        self.filtros = array;
        
        // Reconstruir men煤 con nuevos fitros
        [self construirMenu];
    }
    
    // Ocultar vista de loading s贸lo cuando ya se han cargado los datos tanto para clips como para filtros
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

