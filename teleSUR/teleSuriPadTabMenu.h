//
//  teleSuriPadTabMenu.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MediaPlayer.h"

@interface teleSuriPadTabMenu : UIView {
    UIView *selectorFondo;
    int indiceAnterior;
    UISwitch *switchEnVivo;
    MPMoviePlayerController *vistaReproduccionVideoTiempoReal;
}

@property (nonatomic, retain) MPMoviePlayerController *vistaReproduccionVideoTiempoReal;

@property (nonatomic, retain) IBOutlet UISwitch *switchEnVivo;

@property (nonatomic, assign) int indiceAnterior; 
@property (nonatomic, retain) IBOutlet UIView *selectorFondo;

-(IBAction) reproducirVideoEnTiempoReal;

-(void) animarSelectorFondo;

-(IBAction) colocarSelectorEnPosicionOriginal;

- (IBAction) cambiarAOtroTab: (id) sender;

-(IBAction) accionCambiarTabSeleccionado;

@end
