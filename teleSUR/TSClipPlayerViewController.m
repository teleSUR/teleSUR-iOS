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


@implementation TSClipPlayerViewController

@synthesize clip;

- (id)initConClip:(NSDictionary *)diccionarioClip
{
    self = [super initWithContentURL:[NSURL URLWithString:[diccionarioClip valueForKey:@"archivo_url"]]];
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
    
    // Agregar observer al finalizar reproducción
    [[NSNotificationCenter defaultCenter] 
     addObserver:viewController
     selector:selector                                                
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:self.moviePlayer];
    
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