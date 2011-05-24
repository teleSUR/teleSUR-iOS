//
//  teleSuriPadTabMenu.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface teleSuriPadTabMenu : UIView {
    UIView *selectorFondo;
    int indiceAnterior;
}


@property (nonatomic, assign) int indiceAnterior; 
@property (nonatomic, retain) IBOutlet UIView *selectorFondo;

-(void) animarSelectorFondo;

-(IBAction) colocarSelectorEnPosicionOriginal;

- (IBAction) cambiarAOtroTab: (id) sender;


-(IBAction) accionCambiarTabSeleccionado;

@end
