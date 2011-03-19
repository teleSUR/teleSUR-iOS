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
    
    BOOL conFilltroTodos;
    UIScrollView *menuScrollView;
	NSString *entidadMenu;
    int indiceDeFiltroSeleccionado;
    NSString *slugDeFiltroSeleccionado;
    
}

- (void)cargarFiltros;
- (void)construirMenu;
- (void)filtroSeleccionadoConBoton: (UIButton *)boton;


@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;
@property (nonatomic, retain) NSString *entidadMenu;
@property (nonatomic, retain) NSArray *filtros;
@property (nonatomic, assign) BOOL conFiltroTodos;
@property (nonatomic, assign) int indiceDeFiltroSeleccionado;
@property (nonatomic, retain) NSString *slugDeFiltroSeleccionado;

@end
