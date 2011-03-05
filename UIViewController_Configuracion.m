//
//  UIViewController_Configuracion.m
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController_Configuracion.h"
#import <UIKit/UIkit.h>

#define kLOADING_VIEW_TAG 100


@implementation UIViewController (UIViewController_Configuracion)

- (void)personalizarNavigationBar
{
    // Perosnalizar navigation bar
	[self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
}

- (void)mostrarLoadingViewConAnimacion: (BOOL)animacion
{
    // Cargar NIB con vista para loading, asignarle un tag para hacer referenciar después
	UIView *vistaLoading = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] lastObject];					
    [vistaLoading setTag:kLOADING_VIEW_TAG];
    
    [vistaLoading setAlpha:0];
    [self.view addSubview:vistaLoading];
    
    // Agregar como subvista
    if (animacion)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.4];
        [vistaLoading setAlpha:1.0];
        [UIView commitAnimations];
    }
    else
    {
        [vistaLoading setAlpha:1.0];
    }
}

- (void)ocultarLoadingViewConAnimacion: (BOOL)animacion
{
    // Retirar vista de loading 
    if (animacion)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.4];
        [[self.view viewWithTag:kLOADING_VIEW_TAG] setAlpha:0];
        [[self.view viewWithTag:kLOADING_VIEW_TAG] removeFromSuperview];
        [UIView commitAnimations];
    }
    else
    {
        [[self.view viewWithTag:kLOADING_VIEW_TAG] removeFromSuperview];
    }
    
	
}


@end
