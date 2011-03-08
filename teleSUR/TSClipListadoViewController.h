//
//  TSClipListadoViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"
#import "PullToRefreshTableViewController.h"

@interface TSClipListadoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TSMultimediaDataDelegate> {
	
    //Controladores
    PullToRefreshTableViewController *tableViewController;
    
    // Sub-Vistas:
	UITableView *clipsTableView;
	UIScrollView *menuScrollView;
	
	// Datos de entrada para configurar peticiones al API
	NSString *entidadMenu;
    NSRange rangoUltimo;
    
	NSMutableDictionary *diccionarioConfiguracionFiltros;
	
    // Resultados de consultas a API
	NSMutableArray *clips;
	NSArray *filtros;
    NSMutableArray *arregloClipsAsyncImageViews;
    
    // Auxiliares
    CGFloat celdaEstandarHeight;
    CGFloat celdaGrandeHeight;
    CGFloat celdaVerMasHeight;
    
    int indiceDeFiltroSeleccionado;
    int indiceDeClipSeleccionado;
    
    BOOL agregarAlFinal;
    BOOL omitirVerMas;
    
}


// Controladores:
@property (nonatomic, retain) IBOutlet PullToRefreshTableViewController *tableViewController;

// Sub-Vistas:
@property (nonatomic, retain) IBOutlet UITableView *clipsTableView;
@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;

// Datos de entrada para configurar peticiones al API
@property (nonatomic, retain) NSString *entidadMenu;
@property (nonatomic, retain) NSMutableDictionary *diccionarioConfiguracionFiltros;
@property (nonatomic, assign) NSRange rangoUltimo;

// Resultados de consultas a API
@property (nonatomic, retain) NSMutableArray *clips;
@property (nonatomic, retain) NSArray *filtros;
@property (nonatomic, retain) NSMutableArray *arregloClipsAsyncImageViews;

// Auxiliares
@property (nonatomic, assign) int indiceDeFiltroSeleccionado;
@property (nonatomic, assign) int indiceDeClipSeleccionado;

@property (nonatomic, assign) BOOL agregarAlFinal;
@property (nonatomic, assign) BOOL omitirVerMas;

// Init
- (id)initWithEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;
- (void)configurarConEntidad:(NSString *)entidad yFiltros:(NSDictionary *)diccionario;

// Operaciones
- (void)cargarClips;
- (void)cargarFiltros;

- (void)construirMenu;
- (void)reloadTableViewDataSource; // Para pull-to-refresh

// Eventos
- (void)filtroSeleccionadoConBoton: (UIButton *)boton;
- (void)playerFinalizado:(NSNotification *)notification;


@end
