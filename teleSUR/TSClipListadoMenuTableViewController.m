//
//  TSClipListadoMenuTableViewController.m
//  teleSUR
//
//  Created by David Regla on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipListadoMenuTableViewController.h"
#import "TSMultimediaData.h"
#import "UIViewController_Configuracion.h"

#define kMENU_ALTURA 40

NSInteger const TSMargenMenu = 12;

@implementation TSClipListadoMenuTableViewController

@synthesize menuScrollView, filtros, entidadMenu, conFiltroTodos;
@synthesize indiceDeFiltroSeleccionado, slugDeFiltroSeleccionado;

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
    self.filtros = nil;
    self.entidadMenu = nil;
    self.menuScrollView = nil;
    self.slugDeFiltroSeleccionado = nil;
    
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
    // Si no se ha configurado, entonces se creó desde NIB,
    // por lo tanto hay que configurar dependiendo de la sección a mostrar
    if (!self.diccionarioConfiguracionFiltros) 
    {
        // Detemrinar datos de entrada: filtros a aplicar, y filtros a mostrar
        NSMutableDictionary *dict = [NSMutableDictionary dictionary]; 
        NSString *filtro;
        NSString *tab = [[self navigationItem] title];
        
        if ([tab isEqualToString:@"Noticias"])
        {
            filtro = @"categoria";
            [dict setValue:@"noticia" forKey:@"tipo"];
        }
        else if ([tab isEqualToString:@"Entrevistas"])
        {
            filtro = @"categoria";
            [dict setValue:@"entrevista" forKey:@"tipo"];
        }
        else if ([tab isEqualToString:@"Programas"])
        {
            filtro = @"programa";
            [dict setValue:@"programa" forKey:@"tipo"];
        }
        else {
            NSLog(@"Nombre de tab no reconocido: %@", tab);
        }
        
        // Configurar variables internas
        self.diccionarioConfiguracionFiltros = dict;
    }
    
    if (!self.entidadMenu)
    {
        self.entidadMenu = @"categoria";
    }
    
    
    [super viewDidLoad];
    
    // Auxiliares
    self.indiceDeFiltroSeleccionado = 0;
    self.conFiltroTodos = YES;
        
    // Aumentar altura
    CGRect tableFrame = self.tableViewController.tableView.frame;
    tableFrame.origin.y += kMENU_ALTURA;
    tableFrame.size.height -= kMENU_ALTURA;
    self.tableViewController.tableView.frame = tableFrame;
    
    // Crear y añadir menuScrollView
    self.menuScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kMENU_ALTURA)] autorelease];
    [self.view addSubview:self.menuScrollView];
    
    // Configurar menuScrollView
    self.menuScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BarraRoja.png"]];
    self.menuScrollView.scrollsToTop = NO; // Para que no compita con el listado
    
    // Cargar filtros
    [self cargarFiltros];    
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


#pragma mark -
#pragma mark Internos

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


- (UIButton *)botonParaFiltro:(NSDictionary *)filtro
{
    // Crear nuevo bot√≥n para filtro
    UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
    boton.backgroundColor = [UIColor clearColor];
    
    // Asignar acción del botón
    [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // Configurar label de botón
    boton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    boton.titleLabel.backgroundColor = [UIColor clearColor];
    
    // Configurar colores para denotar un boton seleccionado
    [boton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [boton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [boton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [boton setBackgroundImage:[UIImage imageNamed:@"BarraAzul.png"] forState:UIControlStateSelected];
    
    // Texto del botón
//    NSString *nombre = NSLocalizedString([filtro valueForKey:@"nombre"], @"Nombres de Secciones: Todos, Política, Economía, Medio ambiente, etc...");
    NSString *nombre = [filtro valueForKey:@"nombre"];
    [boton setTitle:nombre forState:UIControlStateNormal];
    boton.titleLabel.text = nombre;
    
    // Ajustar tamaño de frame del botón con base en el volumen del texto
    CGSize textoSize = [boton.titleLabel.text sizeWithFont: boton.titleLabel.font];
    boton.frame = CGRectMake(boton.frame.origin.x, 5.0, textoSize.width, 30.0);
    
    return boton;
}

- (void)construirMenu 
{
    // Retirar todos los botones del men√∫, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0 + TSMargenMenu;
    
    // Recorrer filtros
    for (int i=0; i < [self.filtros count]; i++)
    {
        NSDictionary *filtro = [self.filtros objectAtIndex:i];
        
        UIButton *boton = [self botonParaFiltro:filtro];
        
        // Actualizar frame de botón
        CGRect botonFrame = boton.frame;
        botonFrame.origin.x = offsetX;
        boton.frame = botonFrame;
        
        // Actualizar offset
        offsetX += botonFrame.size.width + TSMargenMenu;
        
        // Marcar sólo botón seleciconado
        [boton setSelected:(self.indiceDeFiltroSeleccionado == i)];
        
        // Si el botón tiene un slug igual al que se indicó como seleccionado, actualizar índiceDeClipSeleccionado
        if ([self.slugDeFiltroSeleccionado isEqualToString:[filtro valueForKey:@"slug"]])
            self.indiceDeFiltroSeleccionado = i;
        
        // Añadir botón a la jerarquón de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir área de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
    
    // Fingir presionar el botón del clip seleccionado
    [self filtroSeleccionadoConBoton:[[self.menuScrollView subviews] objectAtIndex:self.indiceDeFiltroSeleccionado]];
}


#pragma mark -
#pragma mark Acicones

- (void)filtroSeleccionadoConBoton:(UIButton *)boton
{
    // Obtener ’ndice y slug del filtro seleccionado
    NSInteger indice = [[self.menuScrollView subviews] indexOfObject:boton];
    NSString *slug = [[self.filtros objectAtIndex:indice] valueForKey:@"slug"];
    
    // Apagar todos los botones y prender el bot—n en cuesti—n
    for (id btn in [self.menuScrollView subviews]) if ([btn isKindOfClass:[UIButton class]]) [btn setSelected:NO];
	[boton setSelected:YES];
    
    // Autoscroll de menœ, s—lo si el contenido es m‡s grande que el frame visible
    if (self.menuScrollView.contentSize.width > self.menuScrollView.frame.size.width)
    {
        // Calcular nuevo offset para que el bot—n estŽ centrado
        CGFloat offset = + boton.frame.origin.x
        + boton.frame.size.width/2.0
        - self.menuScrollView.frame.size.width/2.0;
        
        // Si el offset es negativo o m‡s grande que la barra completa, no centrar el bot—n
        CGFloat maxOffset = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
        if (offset < 0) offset = 0;
        else if (offset > maxOffset) offset = maxOffset;
        
        // Aplicar nuevo offset
        [[self menuScrollView] setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
    // Si se presion— el mismo que estaba seleccionado, no hacer nada
    if (self.indiceDeFiltroSeleccionado != indice)
    {
        // Configurar nuevo diccionario de filtros, no filtrar si se us— bot—n "todos"
        [self.diccionarioConfiguracionFiltros setValue:([slug isEqualToString:@"todos"] ? nil : slug) forKey:self.entidadMenu];
        
        // Reinicializar datos, con misma entidad de menœ pero nuevo diccionario de confgiruaci—n de filtros 
        [self configurarConEntidad:self.entidadMenu yFiltros:self.diccionarioConfiguracionFiltros];
        
        // Actualizamos el boton que debe "seleccionarse"
        self.indiceDeFiltroSeleccionado = indice;
        
        // Re-cargar datos
        // Mostrar vista de loading
        [self.tableViewController mostrarLoadingViewConAnimacion:YES];
        [self cargarClips];
    }
}   



// Maneja los datos recibidos
- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    [super TSMultimediaData:data entidadesRecibidas:array paraEntidad:entidad];
    
    if (entidad != TSEntidadClip)
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
    }
    
    [self.tableViewController ocultarLoadingViewConAnimacion:YES];
}



@end
