//
//  TSClipDetallesViewController.h
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSClipDetallesViewController : UIViewController {
    
    // Tabla de detalles
	UITableViewController *detallesTableViewController;
	UITableView *detallesTableView;
    
    // Celdas
    UITableViewCell *tituloCell;
    UITableViewCell *firmaCell;
    UITableViewCell *descripcionCell;
    UITableViewCell *categoriaCell;
    
    // Tabla de relacionados
	UITableViewController *relacionadosTableViewController;
	UITableView *relacionadosTableView;
    
    // Datos
    NSDictionary *clip;
    
    // Auxiliares
    NSIndexPath *indexPathSeleccionado;
    
}

- (void)botonCompartirPresionado:(UIButton *)boton;
- (void)botonDescargarPresionado:(UIButton *)boton;

// Tabla de detalles
@property (nonatomic, retain) UITableViewController *detallesTableViewController;
@property (nonatomic, retain) IBOutlet UITableView *detallesTableView;

// Celdas
@property (nonatomic, retain) IBOutlet UITableViewCell *tituloCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *firmaCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *descripcionCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *categoriaCell;

// Tabla de relacionados
@property (nonatomic, retain) UITableViewController *relacionadosTableViewController;
@property (nonatomic, retain) IBOutlet UITableView *relacionadosTableView;

@property (nonatomic, retain) NSDictionary *clip;

// Auxiliares
@property (nonatomic, retain) NSIndexPath *indexPathSeleccionado;

// Init
- (id)initWithClip:(NSDictionary *)diccionarioClip;



@end

