//
//  TSClipsListadoViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"

#define kEntidadTipoListado 0
#define kEntidadTipoMenu 1

@interface TSClipsListadoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TSMultimediaDataDelegate> {
	
	// Controladores:
	UITableViewController *clipsTableViewController;
	
	// Sub-Vistas:
	UITableView *clipsTableView;
	UIScrollView *menuScrollView;
	
	// Datos:
	NSString *entidadMenu;
	NSRange rango;
	NSDictionary *diccionarioFiltros;
	
	NSArray *clips;
	NSArray *filtros;
	
	@private char entidadSolicitada;

}


// Controladores:
@property (nonatomic, retain) UITableViewController *clipsTableViewController;

// Sub-Vistas:
@property (nonatomic, retain) IBOutlet UITableView *clipsTableView;
@property (nonatomic, retain) IBOutlet UIScrollView *menuScrollView;

// Datos:
@property (nonatomic, retain) NSString *entidadMenu;
@property (nonatomic, assign) NSRange rango;
@property (nonatomic, retain) NSDictionary *diccionarioFiltros;

@property (nonatomic, retain) NSArray *clips;
@property (nonatomic, retain) NSArray *filtros;



-(id) initWithEntidadMenu: (NSString *)entidad yFiltros: (NSDictionary *)diccionario;

- (void) construirBarraMenu;

@end
