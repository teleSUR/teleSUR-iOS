//
//  teleSURAppDelegate_iPad.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "teleSURAppDelegate_iPad.h"

@implementation teleSURAppDelegate_iPad

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window addSubview: self.tabBarController.view];
     
     
}

- (void)dealloc
{
	[super dealloc];
}

@end
