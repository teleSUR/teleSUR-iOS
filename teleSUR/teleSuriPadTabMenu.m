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

-(void) animarSelectorFondo
{
    [UIView beginAnimations:@"animarFondoSelector" context:nil];
    
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    
    CGRect frameAnteriorSelector = self.selectorFondo.frame;
    frameAnteriorSelector.origin.x = 60 + 60 * delegado.tabBarController.selectedIndex;
    self.selectorFondo.frame = frameAnteriorSelector;
    
    
    [UIView commitAnimations];
    
}

- (IBAction) cambiarAOtroTab: (UIButton *) sender
{
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [delegado.tabBarController setSelectedIndex:sender.tag];
    
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
