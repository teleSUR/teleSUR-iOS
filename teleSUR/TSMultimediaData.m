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

@synthesize delegate, entidadString;

- (void)getDatosParaEntidad:(NSString *)entidad
                 conFiltros:(NSDictionary *)filtros
                    enRango:(NSRange)rango
                conDelegate:(id)datosDelegate
{
    self.entidadString = entidad;
	self.delegate = datosDelegate;
	
	NSString *urlBase = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuración"] objectForKey:@"API URL Base"];
	NSString *langCode = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuración"] objectForKey:@"Código de idioma"]; // default otros:  @"pt/", @"en/" (OJO: slash al final)
	
    // Prefijo de idioma
    if ([langCode isEqualToString:@"es"])
        langCode = @"";
    else
        langCode = [NSString stringWithFormat:@"%@/", langCode];
    
    NSMutableArray *parametrosGET = [NSMutableArray array];
	NSString *currentFiltro = nil;
	
    // Agregar posibles filtros para clips
	if ([entidad isEqualToString:@"clip"])
    {
        // Buscar nombres de parámetros reconocidos y agregarlos al arreglo de parámetros GET
        NSArray *params = [NSArray arrayWithObjects:@"categoria", @"programa", @"tipo", @"desde", @"hasta", @"pais", @"tema", nil];
        
        for (NSString *param in params)
            if ((currentFiltro = [filtros objectForKey:param]))
                [parametrosGET addObject:[NSString stringWithFormat:@"%@=%@", param, currentFiltro]];
	
	} else if ([entidad isEqualToString:@"categoria"]) {
	} else if ([entidad isEqualToString:@"programa"]) {
	} else if ([entidad isEqualToString:@"pais"]) {
    } else if ([entidad isEqualToString:@"tema"]) {
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
    if (rango.length)
    {
        [parametrosGET addObject:[NSString stringWithFormat:@"primero=%d", rango.location]];
        [parametrosGET addObject:[NSString stringWithFormat:@"ultimo=%d", rango.location + rango.length - 1]];
    }
	
	// construir quierystring, URL, consulta y conexión
	NSString *queryString = [parametrosGET componentsJoinedByString:@"&"];
	
	NSURL *multimediaAPIRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@api/%@?%@", urlBase, langCode, entidad, queryString]];
	NSLog(@"URL a consular: %@", multimediaAPIRequestURL);
	
	NSURLRequest *apiRequest=[NSURLRequest requestWithURL:multimediaAPIRequestURL
											  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										  timeoutInterval:60.0];
	
	NSURLConnection *conexion = [[NSURLConnection alloc] initWithRequest:apiRequest delegate:self];
	
	if (conexion)
    {
        JSONData = [[NSMutableData alloc] init];
	}
    else
    {
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

    [JSONData setLength:0];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Poblar objeto de datos con datos recibidos
    [JSONData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Liberar objeto de conexión y objeto de datos
    [connection release];
    [JSONData release];
    JSONData = nil;
	
    // Informar al delegate
    NSLog(@"Error de conexión - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	if ([delegate respondsToSelector:@selector(entidadesRecibidasConFalla:)])
		[delegate performSelector:@selector(entidadesRecibidasConFalla:) withObject:error];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Parsear JSON
	NSError *JSONError = NULL;
	NSArray *resultadoArray = [NSDictionary dictionaryWithJSONData:JSONData error:&JSONError];
	
	if (!JSONError)
    {
		if (delegate && [delegate respondsToSelector:@selector(TSMultimediaData:entidadesRecibidas:paraEntidad:)])
			[delegate TSMultimediaData:self entidadesRecibidas:resultadoArray paraEntidad:self.entidadString];
	}
    else // falla
    {
		if (delegate && [delegate respondsToSelector:@selector(TSMultimediaData:entidadesRecibidasConError:)])
			[delegate TSMultimediaData:self entidadesRecibidasConError:JSONError];
	}
    
    // liberar objeto de conexión y objeto de datos
    [connection release];
    [JSONData release];
    JSONData = nil;
	
}


#pragma Mark -

- (void)dealloc
{
	self.delegate= nil;
    
	[super dealloc];
}

@end
