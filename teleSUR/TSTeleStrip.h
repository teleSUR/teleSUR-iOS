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
    
    TSClipListadoViewController *listado;
    
    int offsetX;
    int numeroCaracteres;
    NSMutableArray *noticias;
    UIView *vistaInterior;
    UIView *vistaMovimiento;
}
@property (nonatomic, retain) TSClipListadoViewController *listado;
@property (nonatomic, retain) IBOutlet UIView *vistaInterior;
@property (nonatomic, retain) IBOutlet UIView *vistaMovimiento;
@property (nonatomic, retain) NSMutableArray *noticias;
@property (nonatomic, assign) int numeroCaracteres;

-(void) obtenerDatosParaTeleStrip;

-(void) iniciarAnimacion;

-(void) animarNuevaNoticia;

-(void) reciclarNoticia;


@end
