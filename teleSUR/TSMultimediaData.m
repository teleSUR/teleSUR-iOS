//
//  TSMultimediaData.m
//  teleSUR-iOS
//
//  Created by David Regla on 2/12/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "TSMultimediaData.h"
#include "NSDictionary_JSONExtensions.h"
#include "TSMultimediaDataDelegate.h"

@implementation TSMultimediaData

@synthesize delegate;

// Singleton
+ (TSMultimediaData *)sharedTSMultimediaData
{
	static TSMultimediaData *sharedTSMultimediaData;
    
	@synchronized(self)
    {
		if (!sharedTSMultimediaData)
			sharedTSMultimediaData = [[TSMultimediaData alloc] init];
		
		return sharedTSMultimediaData;
	}
}


- (void)getDatosParaEntidad:(NSString *)entidad
                 conFiltros:(NSDictionary *)filtros
                    enRango:(NSRange)rango
                conDelegate:(id)datosDelegate
{
    entidadActual = entidad;
    
	self.delegate = datosDelegate;
	
	NSString *urlBase = @"http://stg.multimedia.tlsur.net";
	NSString *langCode = @"es";
	NSMutableArray *parametrosGET = [NSMutableArray array];
	NSString *currentFiltro = nil;
	
    // agregar posibles filtros para clips
	if ([entidad isEqualToString:@"clip"])
    {
		if (currentFiltro = [filtros objectForKey:@"categoria"])
			[parametrosGET addObject:[NSString stringWithFormat:@"categoria=%@", currentFiltro]];
		
		if (currentFiltro = [filtros objectForKey:@"tipo"])
			[parametrosGET addObject:[NSString stringWithFormat:@"tipo=%@", currentFiltro]];
		
		if (currentFiltro = [filtros objectForKey:@"desde"])
			[parametrosGET addObject:[NSString stringWithFormat:@"desde=%@", currentFiltro]];
		
		if (currentFiltro = [filtros objectForKey:@"hasta"])
			[parametrosGET addObject:[NSString stringWithFormat:@"hasta=%@", currentFiltro]];
	
	} else if ([entidad isEqualToString:@"categoria"]) {
	} else if ([entidad isEqualToString:@"programa"]) {
	} else if ([entidad isEqualToString:@"pais"]) {
	} else if ([entidad isEqualToString:@"tipo_clip"]) {
	} else
    {
		NSLog(@"El nombre de la entidad no se reconoce: %@", entidad);
		if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)])
        {
            NSError *error = [NSError errorWithDomain:@"TSMultimediaData" code:100 userInfo:[NSDictionary dictionary]];
			[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:error];
		}
		return;
	}
	
	// cualquier entidad puede ser paginada
	[parametrosGET addObject:[NSString stringWithFormat:@"primero=%d", rango.location]];
	[parametrosGET addObject:[NSString stringWithFormat:@"ultimo=%d", rango.length]];
	
	// construir quierystring, URL, consulta y conexión
	NSString *queryString = [parametrosGET componentsJoinedByString:@"&"];
	
	NSURL *multimediaAPIRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/api/%@?%@", urlBase, langCode, entidad, queryString]];
	//NSLog(@"URL a consular: %@", multimediaAPIRequestURL);
	
	NSURLRequest *apiRequest=[NSURLRequest requestWithURL:multimediaAPIRequestURL
											  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										  timeoutInterval:60.0];
	
	NSURLConnection *conexion = [[NSURLConnection alloc] initWithRequest:apiRequest delegate:self];
	
	if (conexion) {
        resultadoAPIData = [[NSMutableData alloc] init];
        
	} else {
        NSLog(@"Error de conexión");
		if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)])
        {
            NSError *error = [NSError errorWithDomain:@"TSMultimediaData" code:101 userInfo:[NSDictionary dictionary]];
			[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:error];
		}
	}
}



#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// Preparar objeto de datos
    [resultadoAPIData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Poblar objeto de datos con datos recibidos
    [resultadoAPIData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// liberar objeto de conexión y objeto de datos
    [connection release];
    [resultadoAPIData release];
    resultadoAPIData = nil;
	
    // informar al delegate
    NSLog(@"Error de conexión - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)])
		[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:error];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
	// parsear JSON
	NSError *errorJSON = NULL;
	NSArray *resultadoArray = [NSDictionary dictionaryWithJSONData:resultadoAPIData error:&errorJSON];
	
	if (!errorJSON)
    {
		if ([delegate respondsToSelector:@selector(TSMultimediaData:entidadesRecibidas:paraEntidad:)])
			[delegate TSMultimediaData:self entidadesRecibidas:resultadoArray paraEntidad:entidadActual];
	}
    else // falla
    {
		if ([delegate respondsToSelector:@selector(TSMultimediaData:entidadesRecibidasConError:)])
			[delegate TSMultimediaData:self entidadesRecibidasConError:errorJSON];
	}
    
    // liberar objeto de conexión y objeto de datos
    [connection release];
    [resultadoAPIData release];
    resultadoAPIData = nil;
	
}


- (void)dealloc
{
	self.delegate= nil;
    
	[super dealloc];
}

@end
