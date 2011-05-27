//
//  UIViewController_Configuracion.h
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (UIViewController_Configuracion)

-(void) presentarVideoEnVivo;

-(void) agregarBotonEnVivo;

- (void)personalizarNavigationBar;
- (void)mostrarLoadingViewConAnimacion: (BOOL)animacion;
- (void)ocultarLoadingViewConAnimacion: (BOOL)animacion;

@end
