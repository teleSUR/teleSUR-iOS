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

@synthesize clip, clipURL;

- (id)initConClip:(NSDictionary *)diccionarioClip
{
    NSString *url;
    if ([[diccionarioClip valueForKey:@"metodo_preferido"] isEqualToString:@"streaming"])
    {
        url = [[diccionarioClip valueForKey:@"streaming"] valueForKey:@"apple_hls_url"];
    }
    else
    {
        url = [diccionarioClip valueForKey:@"archivo_url"];
    }
    
    NSLog(@"%@", url);
    
                         
    self = [super initWithContentURL:[NSURL URLWithString:url]];
    if (self) {
        self.clipURL = url;
        self.clip = diccionarioClip;
    }
    return self;
    
}

- (id)initConProgramaURL:(NSString *)progURL
{    
    self = [super initWithContentURL:[NSURL URLWithString:progURL]];
    if (self) {
        self.clipURL = progURL;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor: [UIColor blackColor]];
}

- (void)viewDidUnload
{
    self.clip = nil;
    self.clipURL = nil;
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
        if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                             name: @"Idioma"
                                                            value: (self.clip) ? [self.clip valueForKey:@"idioma"] : @"es"
                                                        withError: &error])
        {
            // Error
            NSLog(@"Error al establecer Variable Idioma: %@", error);
        }
        
        if (![[GANTracker sharedTracker] trackEvent:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone/iPod Touch"
                                             action:@"Video reproducido"
                                              label:self.clipURL
                                              value:-1
                                          withError:&error])
        {
            NSLog(@"Error al enviar evento 'Video reproducido': %@", error);
        }
    }
    
}

@end