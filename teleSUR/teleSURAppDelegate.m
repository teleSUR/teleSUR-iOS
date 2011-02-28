//
//  teleSURAppDelegate.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "teleSURAppDelegate.h"
#import "TSMultimediaData.h"

@class "TSClipsListadoViewController";

@implementation teleSURAppDelegate


@synthesize window=_window;


#pragma mark -
#pragma mark TSMultimediaDataDelegate

- (void)entidadesRecibidasConExito:(NSArray *)array
{
    NSLog(@"Consulta exitosa, se recibió arreglo: %@", array);
}

- (void)entidadesRecibidasConFalla:(id)error
{
	NSLog(@"Error: %@", error);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TSClipsListadoViewController *controlador = [[TSClipsListadoViewController alloc]init];
    
    controlador.entidad_menu = @"categoria";
    controlador.rango = NULL;
    controlador.diccionarioFiltros = [NSDictionary dictionary];
    
    [controlador release];
    
    
    // Override point for customization after application launch.
    
    // ejemplo llamada a signleton de datos, cuando termina la consulta envía
	// mensaje a objeto según selectores en una especie de patrón delegate
	TSMultimediaData *multimediaData = [TSMultimediaData sharedTSMultimediaData];
    [multimediaData getDatosParaEntidad:@"clip" // otros ejemplos: programa, pais, categoria
						 	 conFiltros:[NSDictionary dictionary] // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
						  	    enRango:NSMakeRange(1, 10)  // otro ejemplo: NSMakeRange(1, 1) -sólo uno-
						    conDelegate:self];
    
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
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
