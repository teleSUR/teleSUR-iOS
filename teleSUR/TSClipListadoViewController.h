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
	
	// Datos de entrada para configurar peticiones al API
	NSString *entidadMenu;
	NSRange rango;
	NSDictionary *diccionarioConfiguracionFiltros;
	
    // Resultados de consultas a API
	NSArray *clips;
	NSArray *filtros;
    NSMutableArray *arregloClipsAsyncImageViews;
    
    // Auxiliares
    CGFloat celdaEstandarHeight;
    CGFloat celdaPrincipalHeight;
    int indiceDeBotonSeleccionado;
    
}


// Sub-Vistas:
@property (nonatomic, retain) IBOutlet UITableView *clipsTableView;
@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;

// Datos de entrada para configurar peticiones al API
@property (nonatomic, retain) NSString *entidadMenu;
@property (nonatomic, retain) NSDictionary *diccionarioConfiguracionFiltros;
@property (nonatomic, assign) NSRange rango;

// Resultados de consultas a API
@property (nonatomic, retain) NSArray *clips;
@property (nonatomic, retain) NSArray *filtros;
@property (nonatomic, retain) NSMutableArray *arregloClipsAsyncImageViews;

// Auxiliares
@property (nonatomic, assign) int indiceDeBotonSeleccionado;

// Init
- (id)initWithEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
- (void)configurarConEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;

// Operaciones
- (void)cargarDatos;
- (void)construirMenu;

// Eventos
- (void)filtroSeleccionadoConBoton: (UIButton *)boton;
- (void)playerFinalizado:(NSNotification *)notification;

@end
