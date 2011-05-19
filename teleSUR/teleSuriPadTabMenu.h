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
    
    
}

@property (nonatomic, retain) IBOutlet UIView *selectorFondo;

-(void) animarSelectorFondo;

- (IBAction) cambiarAOtroTab: (id) sender;

@end
