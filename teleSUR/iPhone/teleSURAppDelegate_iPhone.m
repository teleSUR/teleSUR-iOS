//
//  teleSURAppDelegate_iPhone.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "teleSURAppDelegate_iPhone.h"
#import "TSSeleccionIdioma.h"
#import "UIViewController_Preferencias.h"


@implementation teleSURAppDelegate_iPhone

@synthesize tabBarController;

#pragma mark -
#pragma mark View lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[self.tabBarController.tabBar items] objectAtIndex:0] setTitle:NSLocalizedString(@"Noticias", @"Noticias")];
    [[[self.tabBarController.tabBar items] objectAtIndex:1] setTitle:NSLocalizedString(@"Entrevistas", @"Entrevistas")];
    [[[self.tabBarController.tabBar items] objectAtIndex:2] setTitle:NSLocalizedString(@"Programas", @"Programas")];

    
}

- (void)dealloc
{
//    [tabBarController release];
	[super dealloc];
}

@end
