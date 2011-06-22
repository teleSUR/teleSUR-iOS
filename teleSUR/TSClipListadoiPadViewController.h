//
//  TSClipListadoiPadViewController.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"
#import "MediaPlayer/MediaPlayer.h"


#define kAlturaStrip 148
#define kNumeroStrips 5
#define kMargenStrips 10
#define kMargenAltura 10


@class teleSuriPadTabMenu;
@class TSClipCellStripView;
@class  TSClipListadoViewController;

@interface TSClipListadoiPadViewController : UIViewController <TSMultimediaDataDelegate> {
    
    teleSuriPadTabMenu *menu; 
     

    
    UINavigationBar *barraNavegacion;
    
    UIScrollView *scrollStrips;
    TSClipCellStripView *vistaUltimoClip;
    
    NSMutableArray *strips;
    NSMutableArray *tipos;
    
    UIBarButtonItem *botonBusqueda;
    
    UIPopoverController *controlPopOver;
    
    TSClipListadoViewController *listadoVideoUnico;
    
    UISwitch *switchVideoEnVivo;
    
    MPMoviePlayerController *vistaReproduccionVideoTiempoReal;
    
    UIView *vistaCargandoEnVivo;
    
}

@property (nonatomic, retain) IBOutlet UIView *vistaTwitter; 

@property (nonatomic, retain) IBOutlet UIView *vistaCargandoEnVivo;
@property (nonatomic, retain) IBOutlet UINavigationBar *barraNavegacion;

@property (nonatomic, retain) teleSuriPadTabMenu *menu; 

@property (nonatomic, retain) IBOutlet UISwitch *switchVideoEnVivo;

@property (nonatomic, retain) UIPopoverController *controlPopOver;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *botonBusqueda;

@property (nonatomic, retain) TSClipListadoViewController *listadoVideoUnico;

@property (nonatomic, retain) IBOutlet TSClipCellStripView *vistaUltimoClip;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollStrips;

@property (nonatomic, retain) NSMutableArray *strips;
@property (nonatomic, retain) NSMutableArray *tipos;

@property (nonatomic, retain) MPMoviePlayerController *vistaReproduccionVideoTiempoReal;

-(void) retirarModalView;

-(IBAction) mostrarDetallesDeNoticiaStrip: (UIButton *) sender;

-(IBAction) mostrarAcercaDe: (id) sender;

-(IBAction) mostrarVideoTiempoReal: (id) sender;

-(IBAction) mostrarBusqueda: (id) sender;

-(IBAction) mostrarVideo: (id) sender;

@end
