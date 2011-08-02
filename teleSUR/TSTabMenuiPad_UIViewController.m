//
//  TSTabMenuiPad_UIViewController.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSTabMenuiPad_UIViewController.h"
#import "teleSuriPadTabMenu.h"
#import "teleSURAppDelegate_iPad.h"

@implementation UIViewController (TSTabMenuiPad_UIViewController)



-(teleSuriPadTabMenu *) cargarMenu
{
    teleSuriPadTabMenu *vistaMenu = (teleSuriPadTabMenu *) [[[NSBundle mainBundle] loadNibNamed:@"teleSuriPadTabMenuView" owner:self options:nil] lastObject];
    
    [[self.view viewWithTag:98] addSubview:vistaMenu];
    return vistaMenu;

}

@end
