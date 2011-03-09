//
//  NSDate_Utilidad.m
//  teleSUR
//
//  Created by Hector Zarate on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate_Utilidad.h"


@implementation NSDate (NSDate_Utilidad);

- (NSString *)enTimerContraAhora
{
	NSDate *fechaFutura = [NSDate new];
	
	NSString *tiempoQueFalta;
	
	// Obtenemos los segundos faltantes para el sig sorteo
	NSTimeInterval tiempoFaltante = [self timeIntervalSinceDate:fechaFutura];
	
	// Create the NSDates
	NSDate *date1 = [[NSDate alloc] init];
	NSDate *date2 = [[NSDate alloc] initWithTimeInterval:tiempoFaltante sinceDate:date1]; 
	
	// Get conversion to months, days, hours, minutes
	unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
	
	NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags 
													  fromDate:date1  
														toDate:date2  
													   options:0];
	
	
	NSString *dias = @"";
	NSString *horas = @"";
	NSString *mins = @"";
	
	BOOL diasListo = false;
    BOOL horasListo = false;
    BOOL minsListo = false;
    
    if ([conversionInfo day] == 0) {
        diasListo = true;
	}
    
	if ([conversionInfo day] == 1) {
		dias = @"1 dia_";
        diasListo = true;
	}
	
	if ([conversionInfo hour] == 0) {
        horasListo = true;
	}
	
    if ([conversionInfo hour] == 1) {
		horas = @"1 hora_";
        horasListo = true;
	}
	
	if ([conversionInfo minute] == 0) {
        minsListo = true;
	}
	
	if ([conversionInfo minute] == 1) {
		mins = @"1 min_";
        minsListo = true;
	}
    
    if (!diasListo)
        dias = [NSString stringWithFormat:@"%d dias_", (-1) * [conversionInfo day]];
    if (!horasListo)
        horas = [NSString stringWithFormat:@"%d horas_", (-1) * [conversionInfo hour]];
    if (!minsListo)
        mins = [NSString stringWithFormat:@"%d mins", (-1) * [conversionInfo minute]];
	
	tiempoQueFalta = [NSString stringWithFormat:@"%@ %@ %@", dias, horas, mins ];
	
	//NSLog(@"Faltan: %@", tiempoQueFalta);
	
	[date1 release];
	[date2 release];
	
    NSArray *componentesTiempoQueFalta = [tiempoQueFalta componentsSeparatedByString:@"_"];
    
    //NSString *cadenaConResolucionDeDos = [NSString stringWithFormat:@"%@ %@", [componentesTiempoQueFalta objectAtIndex:0], [componentesTiempoQueFalta objectAtIndex:1]];
    
	
	//return cadenaConResolucionDeDos;
	
}


@end
