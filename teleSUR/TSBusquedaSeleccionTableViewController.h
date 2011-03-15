//
//  TSBusquedaSeleccion.h
//  teleSUR
//
//  Created by David Regla on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"

@class TSClipBusquedaViewController;

@interface TSBusquedaSeleccionTableViewController : UITableViewController <TSMultimediaDataDelegate> {
    
    TSClipBusquedaViewController *controladorBusqueda;
    
    NSArray *opciones;
    NSString *entidad;
    NSMutableArray *seleccion;
}


@property (nonatomic, assign) TSClipBusquedaViewController *controladorBusqueda;
@property (nonatomic, retain) NSArray *opciones;
@property (nonatomic, retain) NSString *entidad;
@property (nonatomic, retain) NSMutableArray *seleccion;


@end
