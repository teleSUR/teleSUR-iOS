//
//  TSMenuViewController.h
//  teleSUR
//
//  Created by David Regla on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSMenuViewController : UIViewController {
    
    id delegate;
    
    UIScrollView *menuScrollView;
    
    BOOL conFiltroTodos;
    
    NSArray *filtros;
    
    NSString *entidadMenu;
    
    int indiceDeFiltroSeleccionado;
    NSString *slugDeFiltroSeleccionado;
    
    
    
    
    
    
}

- (void)cargarFiltros;

- (void)construirMenu;

- (void)filtroSeleccionadoConBoton: (UIButton *)boton;


@property (nonatomic, retain) NSArray *filtros;

@property (nonatomic, assign) BOOL conFiltroTodos;

@property (nonatomic, retain) NSString *entidadMenu;

@property (nonatomic, retain) UIScrollView *menuScrollView;

@property (nonatomic, retain) id delegate;


@property (nonatomic, assign) int indiceDeFiltroSeleccionado;

@property (nonatomic, retain) NSString *slugDeFiltroSeleccionado;

@end
