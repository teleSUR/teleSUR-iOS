//
//  TSMenuViewController.m
//  teleSUR
//
//  Created by David Regla on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSMenuViewController.h"
#import "TSMultimediaData.h"

#define kMARGEN_MENU 12


@implementation TSMenuViewController

@synthesize delegate, conFiltroTodos, filtros, slugDeFiltroSeleccionado, indiceDeFiltroSeleccionado, menuScrollView, entidadMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    if (!self.entidadMenu)
        self.entidadMenu = @"categoria";// (entidad != nil) ? entidad : @"categoria";
    
    self.indiceDeFiltroSeleccionado = 0;
    
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

- (void)construirMenu 
{
    // Retirar todos los botones del men√∫, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + kMARGEN_MENU;
    
    // Recorrer filtros
    for (int i=0; i < [self.filtros count]; i++)
    {
        // Crear nuevo bot√≥n para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        boton.backgroundColor = [UIColor clearColor];
        
        // Asignar acción del botón
        [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // Configurar label de botón
        boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        boton.titleLabel.backgroundColor = [UIColor clearColor];
        
        // Configurar colores para denotar un boton seleccionado
		[boton setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.0] forState:UIControlStateNormal];
        [boton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[boton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // Texto del botón
        NSString *nombre = [[self.filtros objectAtIndex:i] valueForKey:@"nombre"];
        [boton setTitle:nombre forState:UIControlStateNormal];
        boton.titleLabel.text = nombre;
		
        // Marcar sólo botón seleciconado
        [boton setSelected:(self.indiceDeFiltroSeleccionado == i)];
        
        // Ajustar tamaño de frame del botón con base en el volumen del texto
		CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
		boton.frame = CGRectMake(offsetX, boton.frame.origin.y, textoSize.width, self.menuScrollView.frame.size.height);
        
        // Actualizar offset
        offsetX += boton.frame.size.width + kMARGEN_MENU;
        
        // Si el botón tiene un slug igual al que se indicó como seleccionado, actualizar índiceDeClipSeleccionado
        if ([self.slugDeFiltroSeleccionado isEqualToString:[[self.filtros objectAtIndex:i] valueForKey:@"slug"]])
            self.indiceDeFiltroSeleccionado = i;
        
        // Añadir botón a la jerarquón de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir área de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
    
    // Fingir presionar el botón del clip seleccionado
    [self filtroSeleccionadoConBoton:[[self.menuScrollView subviews] objectAtIndex:self.indiceDeFiltroSeleccionado]];
}


#pragma mark - TSMultimediaDataDelegate

// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{    
    // Crear diccionario para representar "todos", un primer filtro fake
    if (self.conFiltroTodos)
    {
        NSMutableDictionary *filtroTodos = [NSMutableDictionary dictionary];
        [filtroTodos setValue:@"Todos" forKey:@"nombre"];
        [filtroTodos setValue:@"todos" forKey:@"slug"];
        [filtroTodos setValue:@"Mostrar todos" forKey:@"descripcion"];
        
        // Insertar filtro como primer elemento del arreglo recibido
        NSMutableArray *arregloAumentado = [NSMutableArray arrayWithArray:array];
        [arregloAumentado insertObject:filtroTodos atIndex:0];
        
        // Actualizar arreglo interno
        self.filtros = arregloAumentado;
    }
    else
    {
        self.filtros = array;
    }
    
    // Reconstruir menú con nuevos fitros
    [self construirMenu];

    // Liberar objeto de datos
    [data release];
}

// Obtiene filtros asincrónicamente, con base en propiedades del objeto
- (void)cargarFiltros
{
    // Obtener filtros
	TSMultimediaData *dataFiltros = [[TSMultimediaData alloc] init];
    [dataFiltros getDatosParaEntidad:self.entidadMenu // otros ejemplos: programa, pais, categoria
                          conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                             enRango:NSMakeRange(1, 300)  // otro ejemplo: NSMakeRange(1, 1) -s√≥lo uno-
                         conDelegate:self];
}


#pragma mark -
#pragma mark Acicones

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
    // Obtener índice y slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Apagar todos los botones y prender el botón en cuestión
    for (UIButton *btn in [self.menuScrollView subviews]) [btn setSelected:NO];
	[boton setSelected:YES];
    
    // Autoscroll de menú, sólo si el contenido es más grande que el frame visible
    if (self.menuScrollView.contentSize.width > self.menuScrollView.frame.size.width)
    {
        // Calcular nuevo offset para que el botón esté centrado
        CGFloat offset = + boton.frame.origin.x
        + boton.frame.size.width/2.0
        - self.menuScrollView.frame.size.width/2.0;
        
        // Si el offset es negativo o más grande que la barra completa, no centrar el botón
        CGFloat maxOffset = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
        if (offset < 0) offset = 0;
        else if (offset > maxOffset) offset = maxOffset;
        
        // Aplicar nuevo offset
        [[self menuScrollView] setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
    // Si se presionó el mismo que estaba seleccionado, no hacer nada
    if (self.indiceDeFiltroSeleccionado != indice)
    {
        // Configurar nuevo diccionario de filtros, no filtrar si se usó botón "todos"
        ////[self.diccionarioConfiguracionFiltros setValue:((indice > 0) ? slug : nil) forKey:self.entidadMenu];
        
        // Reinicializar datos, con misma entidad de menú pero nuevo diccionario de confgiruación de filtros 
        ////[self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
        
        // Actualizamos el boton que debe "seleccionarse"
        self.indiceDeFiltroSeleccionado = indice;
        
        // Re-cargar datos
        // Mostrar vista de loading
        //[self mostrarLoadingViewConAnimacion:YES];
        //[self cargarClips];
    }
}   



@end
