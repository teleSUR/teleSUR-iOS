//
//  UIViewController_Configuracion.m
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController_Configuracion.h"

#define kLOADING_VIEW_TAG 100


@implementation UIViewController (UIViewController_Configuracion)

- (void)personalizarNavigationBar
{
    // Perosnalizar navigation bar
	[self setTitle:@"teleSUR"];
	[self.navigationController.navigationBar setTintColor:[UIColor redColor]];
}

- (void)mostrarLoadingViewConAnimacion: (BOOL)animacion
{
    // Cargar NIB con vista para loading, asignarle un tag para hacer referenciar después
	UIView *vistaLoading = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] lastObject];					
    [vistaLoading setTag:kLOADING_VIEW_TAG];
    
    // Agregar como subvista
	[self.view addSubview:vistaLoading];
}

- (void)ocultarLoadingViewConAnimacion: (BOOL)animacion
{
    // Retirar vista de loading 
	[[self.view viewWithTag:kLOADING_VIEW_TAG] removeFromSuperview];
}


@end
