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
    teleSURAppDelegate *appDelegate = (teleSURAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *url = [diccionarioClip valueForKey:@"archivo_url"];
    
    /*
    if (appDelegate.conexionLimitada && [diccionarioClip duracionEnSegundos] > 600)
    {
        url = [NSString stringWithFormat:@"%@?end=590", url];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                       message:@"Actualmente estás utilizando la red de datos celular, para reproducir este video completo es necesario conectarse a una red Wi-Fi"
                                                       delegate:self
                                             cancelButtonTitle:@"Aceptar"
                                             otherButtonTitles:nil, nil];
        [alert show];
                                            
    }
    */
    
    url = [url stringByReplacingOccurrencesOfString:@"http://media.tlsur.net/clips/" withString:@"http://vod.tlsur.net:1935/vod/mp4:"];
    url = [url stringByAppendingString:@"/playlist.m3u8"];
    NSLog(@"video url: %@", url);
                         
    self = [super initWithContentURL:[NSURL URLWithString:url]];
    if (self) {
        self.clipURL = url;
        self.clip = clip;
    }
    return self;
    
}

- (id)initConProgramaURL:(NSString *)progURL
{
    //NSDictionary *diccionarioClip = [NSDictionary dictionaryWithObjectsAndKeys:progURL,@"archivo_url",1800,@"duracion", nil];
    NSDictionary* diccionarioClip = [NSDictionary dictionaryWithObjectsAndKeys:
                                progURL, @"archivo_url",
                                [NSNumber numberWithInt:1800], @"duracion",
                                @"es", @"idioma_original",
                                nil
                                ];

    
    teleSURAppDelegate *appDelegate = (teleSURAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *url = [diccionarioClip valueForKey:@"archivo_url"];
    
    if (appDelegate.conexionLimitada && [diccionarioClip duracionEnSegundos] > 600)
    {
        url = [NSString stringWithFormat:@"%@?end=590", url];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                        message:@"Actualmente estás utilizando la red de datos celular, para reproducir este video completo es necesario conectarse a una red Wi-Fi"
                                                       delegate:self
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    self = [super initWithContentURL:[NSURL URLWithString:url]];
    if (self) {
        self.clipURL = url;
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
                                                             name:@"Idioma"
                                                            value:[self.clip valueForKey:@"idioma_original"]
                                                        withError:&error])
        {
            // Error
            NSLog(@"Error: %@", error);
        }
        
        if (![[GANTracker sharedTracker] trackEvent:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone/iPod Touch"
                                             action:@"Video reproducido"
                                              label:self.clipURL
                                              value:-1
                                          withError:&error])
        {
            NSLog(@"Error");
        }
    }
    
}

@end