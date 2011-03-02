//
//  TSClipListadoViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"

@interface TSClipListadoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TSMultimediaDataDelegate> {
	
    // Sub-Vistas:
	UITableView *clipsTableView;
	UIScrollView *menuScrollView;
	
	// Datos:
	NSString *entidadMenu;
	NSRange rango;
	NSDictionary *diccionarioFiltros;
	
	NSArray *clips;
	NSArray *filtros;
    NSMutableArray *arregloClipsAsyncImageViews;
    
    // Auxiliares
    CGFloat celdaEstandarHeight;
    CGFloat celdaPrincipalHeight;
    
    NSMutableArray *imageViews;
	
	int indiceDeBotonSeleccionado;
	
}


// Sub-Vistas:
@property (nonatomic, retain) IBOutlet UITableView *clipsTableView;
@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;

// Datos:
@property (nonatomic, retain) NSString *entidadMenu;
@property (nonatomic, assign) NSRange rango;
@property (nonatomic, retain) NSDictionary *diccionarioFiltros;

@property (nonatomic, retain) NSArray *clips;
@property (nonatomic, retain) NSArray *filtros;
@property (nonatomic, retain) NSMutableArray *arregloClipsAsyncImageViews;

@property (nonatomic, assign) int indiceDeBotonSeleccionado;

- (id)initWithEntidadMenu:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
- (void)construirMenu;
- (void)cargarDatos;
- (void)filtroSeleccionadoConBoton: (UIButton *)boton;
- (void)playerFinalizado:(NSNotification *)notification;

@end
