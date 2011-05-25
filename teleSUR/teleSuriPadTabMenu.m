//
//  teleSuriPadTabMenu.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "teleSuriPadTabMenu.h"
#import "teleSURAppDelegate_iPad.h"


@implementation teleSuriPadTabMenu


@synthesize selectorFondo;
@synthesize indiceAnterior;

@synthesize vistaReproduccionVideoTiempoReal;
@synthesize switchEnVivo;

-(IBAction) colocarSelectorEnPosicionOriginal
{
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    
    CGRect frameAnteriorSelector = self.selectorFondo.frame;
    frameAnteriorSelector.origin.x = 60 + 60 * delegado.tabBarController.selectedIndex;
    self.selectorFondo.frame = frameAnteriorSelector;

    
    
}

-(void) animarSelectorFondo
{
    [UIView beginAnimations:@"animarFondoSelector" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(accionCambiarTabSeleccionado)];
    
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    CGRect frameAnteriorSelector = self.selectorFondo.frame;
    frameAnteriorSelector.origin.x = 60 + 60 * self.indiceAnterior;
    self.selectorFondo.frame = frameAnteriorSelector;
    
    
    [UIView commitAnimations];
    
}

- (IBAction) cambiarAOtroTab: (UIButton *) sender
{
    
    self.indiceAnterior = sender.tag;
  
    [self animarSelectorFondo];
    


    
}

-(IBAction) accionCambiarTabSeleccionado
{
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    [delegado.tabBarController setSelectedIndex:self.indiceAnterior];
}


-(IBAction) reproducirVideoEnTiempoReal
{
    if (self.switchEnVivo.on) {
        NSString *moviePath = @"http://streaming.tlsur.net:1935/live/vivo.stream/playlist.m3u8";
        NSURL *movieURL = [NSURL URLWithString:moviePath];
        
        
        self.vistaReproduccionVideoTiempoReal = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        self.vistaReproduccionVideoTiempoReal.view.frame = CGRectMake(0.0, self.frame.size.height, self.superview.frame.size.width, self.superview.superview.superview.frame.size.height);
        [self.superview addSubview:self.vistaReproduccionVideoTiempoReal.view];
        [self.vistaReproduccionVideoTiempoReal play];
        [self.vistaReproduccionVideoTiempoReal.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        
    } else
    {
        [self.vistaReproduccionVideoTiempoReal stop];
        [self.vistaReproduccionVideoTiempoReal.view removeFromSuperview];
        [self.vistaReproduccionVideoTiempoReal release];
    }

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
