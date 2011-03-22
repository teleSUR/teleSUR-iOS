//
//  TSProgramaListadoViewController.m
//  teleSUR
//
//  Created by David Regla on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipListadoMenuProgranasViewController.h"

#define kMENU_ALTURA 80 // Altura extra aplicada a menuScrollView

@implementation TSClipListadoMenuProgranasViewController


- (void)viewDidLoad
{
    // Configurar para mostrar programas
    self.entidadMenu = @"programa";
    self.diccionarioConfiguracionFiltros = [NSMutableDictionary dictionaryWithObject:@"programa" forKey:@"tipo"];
    
    [super viewDidLoad];
    
    // Agrandar menú
    CGRect frame;
    frame = self.menuScrollView.frame; 
    frame.size.height += kMENU_ALTURA;
    self.menuScrollView.frame = frame;
    
    // Achicar y recorrer tabla
    frame = self.tableViewController.tableView.frame;
    frame.origin.y += kMENU_ALTURA;
    frame.size.height -= kMENU_ALTURA;
    self.tableViewController.tableView.frame = frame;
    
    // Configuración de scrollview
    self.menuScrollView.pagingEnabled = YES;
    self.menuScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Fondo1.png"]];
    
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
    NSOperationQueue *queue = [NSOperationQueue new];
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
    
    NSString *url = [filtro valueForKey:@"imagen_url"];
    if (![url isEqual:[NSNull null]])
        [boton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] forState:UIControlStateNormal];
}



- (NSString *)nombreNibParaIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.clips count])
        return @"ProgramaTableCellView";
    else
        return [super nombreNibParaIndexPath:indexPath];
}


@end
