//
//  TSClipListadoMenuTableViewController.h
//  teleSUR
//
//  Created by David Regla on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSClipListadoTableViewController.h"

extern const NSInteger TSMargenMenu;

@interface TSClipListadoMenuTableViewController : TSClipListadoTableViewController {
    
    // Vista para scroll
    UIScrollView *menuScrollView;
    
    // Arreglo de elementos para el menú
    NSMutableArray *filtros;
    
    // Configuración del menú
    NSString *entidadMenu;
    BOOL conFilltroTodos;
	
    // Auxiliares
    int indiceDeFiltroSeleccionado;
    NSString *slugDeFiltroSeleccionado;
}

@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;
@property (nonatomic, retain) NSMutableArray *filtros;
@property (nonatomic, retain) NSString *entidadMenu;
@property (nonatomic, assign) BOOL conFiltroTodos;
@property (nonatomic, assign) int indiceDeFiltroSeleccionado;
@property (nonatomic, retain) NSString *slugDeFiltroSeleccionado;

- (void)cargarFiltros;
- (void)construirMenu;
- (UIButton *)botonParaFiltro:(NSDictionary *)filtro;
- (void)filtroSeleccionadoConBoton: (UIButton *)boton;
- (void)configurarDiccionarioConfiguracionFiltrosParaSlug:(NSString *)slug;

@end
