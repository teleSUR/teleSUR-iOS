//
//  teleSURAppDelegate.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "teleSURAppDelegate.h"
#import "TSMultimediaData.h"
#import "GANTracker.h"
#import "TSSeleccionIdioma.h"
#import "UIViewController_Preferencias.h"
#import "Reachability.h"

@implementation teleSURAppDelegate


@synthesize window=_window;
@synthesize conexionLimitada;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // COnexi—n
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    // Checar si hay ruta hacia el sitio
    hostReachable = [[Reachability reachabilityWithHostName: @"multimedia.telesurtv.net"] retain];
    [hostReachable startNotifier];
    
    
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-11834651-1"
                                           dispatchPeriod:60
                                                 delegate:nil];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone/iPod Touch"
                                         action:@"app iniciada"
                                          label:@"v1.0"
                                          value:-1
                                      withError:&error])
    {
        // Error
        NSLog(@"Error: %@", error);
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) checkNetworkStatus:(NSNotification *)notice
{
    // Ejecutado cuando cambia el estado de la red
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            
        }
            
        case ReachableViaWiFi:
        {
            self.conexionLimitada = NO;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            self.conexionLimitada = YES;
            
            break;
        }
    }
}


- (void)dealloc
{
    [[GANTracker sharedTracker] stopTracker];
    [_window release];
    [super dealloc];
}

@end
