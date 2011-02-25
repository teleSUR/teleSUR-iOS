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

+ (TSMultimediaData *)sharedTSMultimediaData {
	// singleton
	static TSMultimediaData *sharedTSMultimediaData;
	@synchronized(self) {
		if (!sharedTSMultimediaData)
			sharedTSMultimediaData = [[TSMultimediaData alloc] init];
		
		return sharedTSMultimediaData;
	}
	
}


- (void)getDatosParaEntidad:(NSString *)entidad
  conFiltros:(NSDictionary *)filtros
  enRango:(NSRange)rango
  conDelegate:(id)datosDelegate {
	
	self.delegate = datosDelegate;
	
	NSString *urlBase = @"http://stg.multimedia.tlsur.net";
	NSString *langCode = @"es";
	NSMutableArray *parametrosGet = [NSMutableArray array];
	NSString *tmpFiltro = nil;
	
	if ([entidad isEqualToString:@"clip"]) {  // agregar posibles filtros para clips
		
		if (tmpFiltro = [filtros objectForKey:@"categoria"])
			[parametrosGet addObject:[NSString stringWithFormat:@"categoria=%@", tmpFiltro]];
		
		if (tmpFiltro = [filtros objectForKey:@"tipo"])
			[parametrosGet addObject:[NSString stringWithFormat:@"tipo=%@", tmpFiltro]];
		
		if (tmpFiltro = [filtros objectForKey:@"desde"])
			[parametrosGet addObject:[NSString stringWithFormat:@"desde=%@", tmpFiltro]];
		
		if (tmpFiltro = [filtros objectForKey:@"hasta"])
			[parametrosGet addObject:[NSString stringWithFormat:@"hasta=%@", tmpFiltro]];
	
	} else if ([entidad isEqualToString:@"categoria"]) {
	} else if ([entidad isEqualToString:@"programa"]) {
	} else if ([entidad isEqualToString:@"pais"]) {
	} else if ([entidad isEqualToString:@"tipo_clip"]) {
		
	} else {
		NSLog(@"El nombre de la entidad no se reconoce: %@", entidad);
		if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)]) {
			[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:[NSError errorWithDomain:@"TSMultimediaData" code:100 userInfo:[NSDictionary dictionary]]];
		}
		return;
	}
	
	// cualquier entidad puede ser paginada
	[parametrosGet addObject:[NSString stringWithFormat:@"primero=%d", rango.location]];
	[parametrosGet addObject:[NSString stringWithFormat:@"ultimo=%d", rango.length]];
	
	// construir quierystring, URL, consulta y conexión
	NSString *queryString = [parametrosGet componentsJoinedByString:@"&"];
	
	NSURL *multimediaAPIRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/api/%@?%@", urlBase, langCode, entidad, queryString]];
	//NSLog(@"URL a consular: %@", multimediaAPIRequestURL);
	
	NSURLRequest *apiRequest=[NSURLRequest requestWithURL:multimediaAPIRequestURL
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	
	NSURLConnection *conexion = [[NSURLConnection alloc] initWithRequest:apiRequest delegate:self];
	
	if (conexion) {
		resultadoAPIData = [[NSMutableData data] retain];
	} else {
		// Informal al usuario
	}
}



#pragma mark -
#pragma mark Conexión HTTP a API

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// Preparar objeto de datos
    [resultadoAPIData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [resultadoAPIData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// liberar objeto de conexión y objeto de datos
    [connection release];
    [resultadoAPIData release];
	
    // informar al usuario
    NSLog(@"Error de conexión - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)]) {
		[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:error];
	}
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// parsear JSON
	NSError *errorJSON = NULL;
	NSArray *resultadoArray = [NSDictionary dictionaryWithJSONData:resultadoAPIData error:&errorJSON];
	
	if (errorJSON) {
		
		if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)]) {
			[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:errorJSON];
		}
		
	} else {
		
		if ([delegate respondsToSelector:@selector(entidadesRecibidasConExito:)]) {
			[delegate performSelector:@selector(entidadesRecibidasConExito:) withObject:resultadoArray];
		}
	
	}
	
    // liberar objeto de conexión y objeto de datos
    [connection release];
    [resultadoAPIData release];
	
}



- (void)dealloc {
	if (delegate) [delegate release];
	[super dealloc];
	
}

@end
