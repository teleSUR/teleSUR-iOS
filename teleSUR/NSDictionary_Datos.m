//
//  NSDictionary_Datos.m
//  teleSUR
//
//  Created by Hector Zarate on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary_Datos.h"
#import "NSDate_Utilidad.h"

#define kTIEMPO_DESDE_DIAS 7


@implementation NSDictionary (NSDictionary_Datos)

// Obtener NSString con firma de clip con el formato: [ciudad, ]país | fecha_completa
- (NSString *)obtenerFirmaParaEsteClip
{
    // Inicializar cadena para firma
	NSMutableString *firma = [NSMutableString string];
    
    // Obtener datos
	NSString *ciudad = [self valueForKey:@"ciudad"];
    NSString *pais = [[self valueForKey:@"pais"] valueForKey:@"nombre"];
    NSString *fechaCompleta = [self obtenerTiempoDesdeParaEsteClip];
    
	// Concatenar datos: ciudad (si la hay), país y fecha completa

	if (![ciudad isKindOfClass:[NSNull class] ] && [ciudad length] > 0) [firma appendFormat:@"%@, ", ciudad];
    
    if (![pais isKindOfClass:[NSNull class]]) [firma appendFormat:@"%@ | ", pais];

    [firma appendFormat:@"%@", fechaCompleta];
    
	return firma;
}


// Devuelve NSDate con la fecha de este clip,
// que se espera tenga el formato: yyyy-MM-dd HH:mm:ss
- (NSDate *)obtenerNSDateParaEsteClip
{	
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *date = [formater dateFromString: [self valueForKey:@"fecha"]];
	
	[formater release];
	
	return date;
}


// Devuelve cadena con fecha localizada completa de este clip: Ej: Miércoles 4 de agosto de 2010
- (NSString *)obtenerFechaCompletaParaEsteClip
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateStyle:NSDateFormatterMediumStyle];
    
	NSString *fechaCompleta = [formater stringFromDate:[self obtenerNSDateParaEsteClip]];
    
	[formater release];
    
    return fechaCompleta;
}


// TODO: Implementar
// Devuelve cadena localizada con tiempo transcurrido desde la fecha de este clip:
// Mostrar sólo las dos métricas más representativas (años-meses, meses-semanas, etc..)
// Si es necesario mostrar minutos, redondear a múltiplos de 10, si es menor a 10 minutos devolver "Justo ahora"
// Ej: Hace 1 año y 8 meses, Hace 4 meses y 2 semanas, Hace 1 semana y 2 días, Hace 5 días y 4 horas,
//     Hace 2 horas y 20 minutos, Hace 40 minutos, Justo ahora
- (NSString *)obtenerTiempoDesdeParaEsteClip
{
		
	return [[self obtenerNSDateParaEsteClip] enTimerContraAhora];
	
}



@end
