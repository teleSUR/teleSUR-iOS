//
//  TSProgramaListadoViewController.m
//  teleSUR
//
//  Created by David Regla on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipListadoMenuProgranasViewController.h"
#import "UIViewWrapUIScrollView.h"

#define kMENU_ALTURA 80 // Altura extra aplicada a menuScrollView

@implementation TSClipListadoMenuProgranasViewController

- (void)construirMenu 
{
    // Retirar todos los botones del men√∫, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 6;
    
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
    
    // Ajustes para Scroll personalizado
    //    [self.menuScrollView setPagingEnabled:NO];
    
    // Fingir presionar el botón del clip seleccionado
    [self filtroSeleccionadoConBoton:[[self.menuScrollView subviews] objectAtIndex:self.indiceDeFiltroSeleccionado]];
}


- (void)configurarDiccionarioConfiguracionFiltrosParaSlug:(NSString *)slug
{
    if ([slug isEqualToString:@"documental"] || [slug isEqualToString:@"reportaje"])
    {
        [self.diccionarioConfiguracionFiltros removeObjectForKey:self.entidadMenu];
        [self.diccionarioConfiguracionFiltros setValue:slug forKey:@"tipo"];
    }
    else
    {
        [self.diccionarioConfiguracionFiltros setValue:@"programa" forKey:@"tipo"];
        [self.diccionarioConfiguracionFiltros setValue:([slug isEqualToString:@"todos"] ? nil : slug) forKey:self.entidadMenu];
    }
}




- (void)viewDidLoad
{
    // Configurar para mostrar programas
    self.conFiltroTodos = NO;
    self.entidadMenu = @"programa";
    self.diccionarioConfiguracionFiltros = [NSMutableDictionary dictionaryWithObject:@"programa" forKey:@"tipo"];
    
    // Poner fondo.
//    CGRect frame;
//    frame = self.menuScrollView.frame; 
    UIView *vistaFondo = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kMENU_ALTURA +(kMENU_ALTURA/2))] autorelease];

    // Configurar menuScrollView
    vistaFondo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Fondo1.png"]];    
    [self.view addSubview:vistaFondo];
    
    


    
    
    [super viewDidLoad];
    
    // Agrandar menú
    CGRect frame;
    frame = self.menuScrollView.frame; 
    frame.origin.x = (self.tableViewController.tableView.frame.size.width - 212) / 2;
    frame.size.height += kMENU_ALTURA;
    frame.size.width = 200+12;
    
    self.menuScrollView.frame = frame;
    
    UIViewWrapUIScrollView *vistaFrente = [[[UIViewWrapUIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.menuScrollView.frame.size.height)] autorelease];
    vistaFrente.scrollEnCuestion = self.menuScrollView;
    // Configurar vistaFrente
    vistaFrente.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:vistaFrente];

    
    
    // Achicar y recorrer tabla
    frame = self.tableViewController.tableView.frame;
    frame.origin.y += kMENU_ALTURA;
    frame.size.height -= kMENU_ALTURA;
    self.tableViewController.tableView.frame = frame;
    
    // Configuración de scrollview
    self.menuScrollView.pagingEnabled = YES;

    self.menuScrollView.scrollEnabled = YES;
    self.menuScrollView.backgroundColor = [UIColor clearColor];
    
    // No mostrar primer filtro "Todos"
    self.conFiltroTodos = NO;
}

#pragma mark -
#pragma mark Internos

- (UIButton *)botonParaFiltro:(NSDictionary *)filtro
{
    UIButton *boton = [super botonParaFiltro:filtro];
    
    CGRect frame = boton.frame;
    frame.size.width = 200.0;
    frame.size.height = 100.0;
    boton.frame = frame;
    
    // Mostrar imagen en vez de nombre
    NSArray *arreglo = [NSArray arrayWithObjects:boton, filtro, nil]; 
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]  
                                        initWithTarget:self
                                        selector:@selector(cargarImagen:)
                                        object:arreglo];
    [queue addOperation:operation]; 
    [operation release];
    
    
    [boton setTitle:[filtro valueForKey:@"nombre"] forState:UIControlStateNormal];
    boton.titleLabel.text = [filtro valueForKey:@"nombre"];
    
    
    return boton;
}


- (void)cargarImagen:(NSArray *)arregloBotonFiltro
{
    UIButton *boton = (UIButton *)[arregloBotonFiltro objectAtIndex:0];
    NSDictionary *filtro = (NSDictionary *)[arregloBotonFiltro objectAtIndex:1];
    
    // Buscar imagen en sistema de archivos, si no se encuentra descargarla
    UIImage *programaImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [filtro valueForKey:@"slug"]]];
    if (!programaImage)
    {
        NSString *url = [filtro valueForKey:@"imagen_url"];
        if (![url isEqual:[NSNull null]])
            programaImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    }

    [boton setImage:programaImage forState:UIControlStateNormal];
}



- (NSString *)nombreNibParaIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.clips count])
        return @"ProgramaTableCellView";
    else
        return [super nombreNibParaIndexPath:indexPath];
}


- (void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    if (entidad != TSEntidadClip)
    {
        self.filtros = [NSMutableArray arrayWithArray:array];
        [self.filtros addObjectsFromArray:[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"Configuración"] valueForKey:@"Filtros Extra Menú Programas"]];
        
        [self construirMenu]; 
    }
    else
    {
        [super TSMultimediaData:data entidadesRecibidas:array paraEntidad:entidad];
    }
    
    //[self ocultarLoadingViewConAnimacion:YES];
}


#pragma - Scroll
/*
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // Autoscroll de menœ, s—lo si el contenido es m‡s grande que el frame visible
    
        // Calcular nuevo offset para que el bot—n estŽ centrado
        CGFloat offset = + scrollView.contentOffset.x + 180 - self.menuScrollView.frame.size.width/2.0;
        
        // Si el offset es negativo o m‡s grande que la barra completa, no centrar el bot—n
        CGFloat maxOffset = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
        if (offset < 0) offset = 0;
        else if (offset > maxOffset) offset = maxOffset;
        
        // Aplicar nuevo offset
        [scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
}
 */
@end
