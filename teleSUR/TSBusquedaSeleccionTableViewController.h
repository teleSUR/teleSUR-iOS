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
    
    UIActivityIndicatorView *indicadorActividad;
    
    NSMutableArray *opciones;
    NSString *entidad;
    NSMutableArray *seleccion;
    
    //Indices
    NSArray *content;
    NSMutableArray *indices;
    NSMutableArray *nombrePaises;
}


@property (nonatomic, assign) TSClipBusquedaViewController *controladorBusqueda;
@property (nonatomic, retain) UIActivityIndicatorView *indicadorActividad;
@property (nonatomic, retain) NSMutableArray *opciones;
@property (nonatomic, retain) NSString *entidad;
@property (nonatomic, retain) NSMutableArray *seleccion;
@property (nonatomic, retain) NSMutableArray *indices;

@end
