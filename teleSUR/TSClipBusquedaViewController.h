//
//  TSClipBusquedaViewController.h
//  teleSUR
//
//  Created by David Regla on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSClipBusquedaViewController : UITableViewController
{
    NSMutableDictionary *selecciones;
    NSArray *configuracionSeccionesBusqueda;
}

@property (nonatomic, retain) NSMutableDictionary *selecciones;
@property (nonatomic, assign) NSArray *configuracionSeccionesBusqueda;

- (void)botonBuscarPresionado:(UIBarButtonItem *)boton;

@end
