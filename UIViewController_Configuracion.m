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
#define kLOADING_TRANSPARENCIA 0.70
#define kLOADING_TIEMPO_ANIMACION 0.4


@implementation UIViewController (UIViewController_Configuracion)

- (void)personalizarNavigationBar
{
    // Perosnalizar navigation bar
	[self.navigationController.navigationBar setTintColor: [UIColor colorWithRed:0.6 green:0.04 blue:0.039 alpha:1.0] ];

}

- (void)mostrarLoadingViewConAnimacion: (BOOL)animacion
{
    // Cargar NIB con vista para loading, asignarle un tag para hacer referenciar después
    UIView *vistaLoading = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] lastObject];					
    
    vistaLoading.tag = kLOADING_VIEW_TAG;
    vistaLoading.alpha = 0;
    [self.view setUserInteractionEnabled:NO];
    
    // Agregar como subvista
    [self.view addSubview:vistaLoading];
    if (!animacion)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:kLOADING_TIEMPO_ANIMACION];
        vistaLoading.alpha = kLOADING_TRANSPARENCIA;
        [UIView commitAnimations];
    }
    else
    {
        vistaLoading.alpha = kLOADING_TRANSPARENCIA;
    }
}

- (void)ocultarLoadingViewConAnimacion: (BOOL)animacion
{
    // Retirar vista de loading 
    if (animacion)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:kLOADING_TIEMPO_ANIMACION];
        [[self.view viewWithTag:kLOADING_VIEW_TAG] setAlpha:0];
        [[self.view viewWithTag:kLOADING_VIEW_TAG] removeFromSuperview];
        [UIView commitAnimations];
    }
    else
    {
        [[self.view viewWithTag:kLOADING_VIEW_TAG] removeFromSuperview];
    }
    
    [self.view setUserInteractionEnabled:YES];
    
	
}


@end
