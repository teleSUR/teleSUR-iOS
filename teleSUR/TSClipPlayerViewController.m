//
//  TSClipPlayerViewController.m
//  teleSUR
//
//  Created by David Regla on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GANTracker.h"
#import "teleSURAppDelegate.h"
#import "NSDictionary_Datos.m"

@implementation TSClipPlayerViewController

@synthesize clip;

- (id)initConClip:(NSDictionary *)diccionarioClip
{
    teleSURAppDelegate *appDelegate = (teleSURAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *clipURL = [diccionarioClip valueForKey:@"archivo_url"];
    
    if (appDelegate.conexionLimitada && [diccionarioClip duracionEnSegundos] > 600)
    {
        clipURL = [NSString stringWithFormat:@"%@?end=590", clipURL];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Conexión limitada"
                                                       message:@"Actualmente estás conectado a Internet a través de la red celular, para ver el video completo conéctate a una red Wi-Fi"
                                                       delegate:self
                                             cancelButtonTitle:@"Aceptar"
                                             otherButtonTitles:nil, nil];
        [alert show];
                                            
    }
                         
    self = [super initWithContentURL:[NSURL URLWithString:clipURL]];
    if (self) {
        self.clip = diccionarioClip;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor: [UIColor blackColor]];
}



- (void)playEnViewController:(UIViewController *)viewController finalizarConSelector:(SEL)selector registrandoAccion:(BOOL)registrar
{   
    [viewController presentMoviePlayerViewControllerAnimated:self];
    [self.moviePlayer play];
    
    if (selector != nil) {
        // Agregar observer al finalizar reproducción
        [[NSNotificationCenter defaultCenter] 
         addObserver:viewController
         selector:selector                                                
         name:MPMoviePlayerPlaybackDidFinishNotification
         object:self.moviePlayer];
    }
    
    // Enviar notificación a Google Analytics
    if (registrar)
    {
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"iPhone"
                                             action:@"Video reproducido"
                                              label:[self.clip valueForKey:@"archivo"]
                                              value:-1
                                          withError:&error])
        {
            NSLog(@"Error");
        }
    }
    
}

@end