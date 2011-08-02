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
    
    for (UIView *view in [self.tabBarController.view subviews])
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + 49);
     
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)dealloc
{
	[super dealloc];
}

@end
