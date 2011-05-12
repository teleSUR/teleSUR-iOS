//
//  TSTeleStrip.h
//  teleSUR
//
//  Created by Hector Zarate on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSMultimediaDataDelegate.h"

@class TSClipListadoViewController;

@interface TSTeleStrip : UIView <TSMultimediaDataDelegate> {
    
    UIPopoverController*  controlPopOver;
    
    TSClipListadoViewController *listado;
    
    BOOL detenerAnimacion;
    
    int offsetX;
    int numeroCaracteres;
    NSMutableArray *noticias;
    UIView *vistaInterior;
    UIView *vistaMovimiento;
}
@property (nonatomic, retain) UIPopoverController*  controlPopOver;
@property (nonatomic, assign) BOOL detenerAnimacion;
@property (nonatomic, retain) TSClipListadoViewController *listado;
@property (nonatomic, retain) IBOutlet UIView *vistaInterior;
@property (nonatomic, retain) IBOutlet UIView *vistaMovimiento;
@property (nonatomic, retain) NSMutableArray *noticias;
@property (nonatomic, assign) int numeroCaracteres;

-(IBAction) detenerAnimacionNoticias: (id) sender;

-(IBAction) reanudarAnimacionNoticias: (id) sender;

-(void) obtenerDatosParaTeleStrip;

-(void) iniciarAnimacion;

-(void) animarNuevaNoticiaDesdeInicio: (BOOL) banderaInicio;

-(void) reciclarNoticia;


@end
