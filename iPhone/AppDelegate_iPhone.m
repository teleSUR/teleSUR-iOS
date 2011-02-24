//
//  AppDelegate_iPhone.m
//  teleSUR-iOS
//
//  Created by David Regla on 2/10/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "TSMultimediaData.h"

@implementation AppDelegate_iPhone


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];

	// ejemplo llamada a signleton de datos, cuando termina la consulta envía
	// mensaje a objeto según selectores en una especie de patrón delegate
	TSMultimediaData *mmData = [TSMultimediaData sharedTSMultimediaData];
    [mmData getDatosParaEntidad:@"clip" // otros ejemplos: programa, pais, categoria
					conFiltros:[NSDictionary dictionary] // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
					   enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -sólo uno-
				   conDelegate:self
			   selectorSiExito:@selector(entidadesRecibidasExito:)
				selectorSiFalla:@selector(entidadesRecibidasFalla:)];
    
    return YES;
}

- (void)clipsRecibidosExito:(NSArray *)array {
    NSLog(@"Consulta exitosa, se recibió arreglo: %@", array);
}

- (void)clipsRecibidosFalla:(id)error {
	NSLog(@"Error: %@", error);
}
										   


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.

     Superclass implementation saves changes in the application's managed object context before the application terminates.
     */
	[super applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
	
	[super dealloc];
}


@end

