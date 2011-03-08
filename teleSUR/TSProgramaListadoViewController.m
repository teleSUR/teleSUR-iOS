//
//  TSProgramaListadoViewController.m
//  teleSUR
//
//  Created by David Regla on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSProgramaListadoViewController.h"

#define kMENU_ALTURA_EXTRA 80

@implementation TSProgramaListadoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame;
    
    // Agrandar menú
    frame = self.menuScrollView.frame; 
    frame.size.height += kMENU_ALTURA_EXTRA;
    self.menuScrollView.frame = frame;
    
    // Achicar y recorrer tabla
    frame = self.clipsTableView.frame;
    frame.origin.y += kMENU_ALTURA_EXTRA;
    frame.size.height -= kMENU_ALTURA_EXTRA;
    self.clipsTableView.frame = frame;
    
    // Configuración de scrollview
    self.menuScrollView.pagingEnabled = YES;
    self.menuScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // No mostrar primer filtro "Todos"
    self.conFiltroTodos = NO;
}

#pragma mark -
#pragma mark Internos

- (void)construirMenu 
{
    // Retirar todos los botones del menú, si es que hay
    for (UIButton *boton in self.menuScrollView.subviews) [boton removeFromSuperview];
    
    // Inicializar offset horizontal
    int offsetX = 0;
    
    // Recorrer filtros
    for (float i=0; i < [self.filtros count]; i++)
    {
        // Crear nuevo bot√≥n para filtro
        UIButton *boton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Asignar acción del botón
        [boton addTarget:self action:@selector(filtroSeleccionadoConBoton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        // Imagen
        NSString *url = [[self.filtros objectAtIndex:i] valueForKey:@"imagen_url"];
        if (![url isEqual:[NSNull null]])
            [boton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] forState:UIControlStateNormal];
        
        // Marcar sólo botón seleciconado
        [boton setSelected:(self.indiceDeFiltroSeleccionado == i)];
        [boton setFrame:CGRectMake(offsetX, 15, 200, 100)];
        
        NSString *nombre = [[self.filtros objectAtIndex:i] valueForKey:@"nombre"];
        [boton setTitle:nombre forState:UIControlStateNormal];
        boton.titleLabel.text = nombre;
        
        offsetX += boton.frame.size.width;
        
        // Añadir botón a la jerarquón de vistas
        [self.menuScrollView addSubview:boton];
    }
    
    // Deifnir área de scroll
    [self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];
}


- (NSString *)nombreNibParaIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.clips count])
        return @"ProgramaTableCellView";
    else
        return [super nombreNibParaIndexPath:indexPath];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
