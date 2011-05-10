//
//  TSClipDetallesViewController.h
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSClipListadoTableViewController.h"


@interface TSClipDetallesViewController : TSClipListadoTableViewController {
    
    // Celdas
    UITableViewCell *tituloCell;
    UITableViewCell *firmaCell;
    UITableViewCell *descripcionCell;
    UITableViewCell *categoriaCell;
    
    // Datos
    NSDictionary *clip;
    
    // Auxiliares
    NSMutableData *descargaData;
}

- (void)botonCompartirPresionado:(UIButton *)boton;
- (void)botonDescargarPresionado:(UIButton *)boton;

- (void)marcarPadreParaRecargar;

// Celdas
@property (nonatomic, retain) IBOutlet UITableViewCell *tituloCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *firmaCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *descripcionCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *categoriaCell;
@property (nonatomic, retain) IBOutlet NSMutableData *descargaData;

@property (nonatomic, retain) NSDictionary *clip;

// Init
- (id)initWithClip:(NSDictionary *)diccionarioClip;



@end

