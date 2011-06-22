//
//  teleSuriPadTabMenu.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "teleSuriPadTabMenu.h"
#import "teleSURAppDelegate_iPad.h"
#import "TSClipBusquedaViewController.h"
#import "TSMasTableViewController.h"


#define kMargenIzquierdo 1
#define kEspacioEntreMenu 75

@implementation teleSuriPadTabMenu

@synthesize controlPopMas, controlPopBusqueda;

@synthesize selectorFondo;
@synthesize indiceAnterior;

@synthesize vistaReproduccionVideoTiempoReal;
@synthesize switchEnVivo;

-(IBAction) mostrarAcercaDe: (UIButton *) sender
{
    if([self.controlPopBusqueda isPopoverVisible])
    {
        
        [self.controlPopBusqueda dismissPopoverAnimated:YES];
        return;
    }
    
    
    UINavigationController *controlNavegacion = [[UINavigationController alloc] init];
    
    TSMasTableViewController *busquedaView = [[TSMasTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [controlNavegacion pushViewController:busquedaView animated:NO];
    
    self.controlPopBusqueda = [[UIPopoverController alloc] initWithContentViewController:controlNavegacion];
    self.controlPopBusqueda.popoverContentSize = CGSizeMake(320, 480);
    //    self.controlPopOver.
    //    [controlPopOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [self.controlPopBusqueda presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [busquedaView release];
}

-(IBAction) mostrarBusqueda: (UIButton *) sender
{
    if([self.controlPopBusqueda isPopoverVisible])
    {
        [self.controlPopBusqueda dismissPopoverAnimated:YES];
        return;
    }
    
    
    UINavigationController *controlNavegacion = [[UINavigationController alloc] init];
    
    TSClipBusquedaViewController *busquedaView = [[TSClipBusquedaViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [controlNavegacion pushViewController:busquedaView animated:NO];
    
    self.controlPopBusqueda = [[UIPopoverController alloc] initWithContentViewController:controlNavegacion];
    self.controlPopBusqueda.popoverContentSize = CGSizeMake(320, 520);    
    [self.controlPopBusqueda presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [busquedaView release];
    
}


-(IBAction) colocarSelectorEnPosicionOriginal
{
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    
    CGRect frameAnteriorSelector = self.selectorFondo.frame;
    frameAnteriorSelector.origin.x = kMargenIzquierdo + kEspacioEntreMenu * delegado.tabBarController.selectedIndex;
    self.selectorFondo.frame = frameAnteriorSelector;

    
    
}

-(void) animarSelectorFondo
{
    [UIView beginAnimations:@"animarFondoSelector" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(accionCambiarTabSeleccionado)];
    
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    CGRect frameAnteriorSelector = self.selectorFondo.frame;
    frameAnteriorSelector.origin.x = kMargenIzquierdo + kEspacioEntreMenu * self.indiceAnterior;
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
