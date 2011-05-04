//
//  TSClipListadoiPadViewController.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"

#define kAlturaStrip 167
#define kNumeroStrips 5
#define kMargenStrips 10

@class TSClipCellStripView;
@class  TSClipListadoViewController;

@interface TSClipListadoiPadViewController : UIViewController <TSMultimediaDataDelegate> {
    
    UIScrollView *scrollStrips;
    TSClipCellStripView *vistaUltimoClip;
    
    NSMutableArray *strips;
    NSMutableArray *tipos;
    
    UIBarButtonItem *botonBusqueda;
    
    UIPopoverController *controlPopOver;
    
    TSClipListadoViewController *listadoVideoUnico;
}

@property (nonatomic, retain) UIPopoverController *controlPopOver;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *botonBusqueda;

@property (nonatomic, retain) TSClipListadoViewController *listadoVideoUnico;

@property (nonatomic, retain) IBOutlet TSClipCellStripView *vistaUltimoClip;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollStrips;

@property (nonatomic, retain) NSMutableArray *strips;
@property (nonatomic, retain) NSMutableArray *tipos;

-(void) retirarModalView;

-(IBAction) mostrarBusqueda: (id) sender;

-(IBAction) mostrarVideo: (id) sender;

@end
