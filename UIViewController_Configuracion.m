//
//  UIViewController_Configuracion.m
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController_Configuracion.h"
#import <UIKit/UIkit.h>
#import "TSClipPlayerViewController.h"
#import "GANTracker.h"

#define kLOADING_VIEW_TAG 100
#define kLOADING_TRANSPARENCIA 0.70
#define kLOADING_TIEMPO_ANIMACION 0.4


@implementation UIViewController (UIViewController_Configuracion)


-(void) presentarVideoEnVivo
{
    NSString *moviePath = [[[[NSBundle mainBundle] infoDictionary] valueForKey:@"Configuración"] valueForKey:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"Streaming URL Alta" : @"Streaming URL Media"];
    NSLog(@"%@", moviePath);
    //NSDictionary *fakeClip = [NSDictionary dictionaryWithObject:moviePath forKey:@"archivo_url"];
    
    ;// Crear y configurar player
    TSClipPlayerViewController *playerController = [[TSClipPlayerViewController alloc] initConProgramaURL:moviePath];
    
    // Reproducir video
    [playerController playEnViewController:self
                      finalizarConSelector:nil
                         registrandoAccion:NO];
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone/iPod Touch"
                                         action:@"Señal en vivo iniciada"
                                          label:moviePath
                                          value:-1
                                      withError:&error])
    {
        NSLog(@"Error");
    }
}

-(void) agregarBotonEnVivo
{
    UIBarButtonItem *botonEnVivo = [[UIBarButtonItem alloc] initWithTitle:@"En Vivo" style:UIBarButtonItemStyleBordered target:self action:@selector(presentarVideoEnVivo)];
    
    self.navigationItem.rightBarButtonItem = botonEnVivo;
    
    [botonEnVivo release];
    
}

- (void)personalizarNavigationBar
{
    // Perosnalizar navigation bar
	[self.navigationController.navigationBar setTintColor: [UIColor colorWithRed:0.6 green:0.04 blue:0.039 alpha:1.0]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Header.png"]];
    self.navigationItem.titleView = imageView;
    [imageView release];

}

- (void)mostrarLoadingViewConAnimacion:(BOOL)animacion
{
    
    // Cargar NIB con vista para loading, asignarle un tag para hacer referenciar después
    UIView *vistaLoading = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] lastObject];					
    
    vistaLoading.tag = kLOADING_VIEW_TAG;
    vistaLoading.alpha = 0;
    [self.view setUserInteractionEnabled:NO];
    
    // Agregar como subvista
    if (![self.view viewWithTag:kLOADING_VIEW_TAG])
    {
        [self.view addSubview:vistaLoading];
    }
    
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
