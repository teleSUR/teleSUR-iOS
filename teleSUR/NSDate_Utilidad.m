//
//  NSDate_Utilidad.m
//  teleSUR
//
//  Created by Hector Zarate on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate_Utilidad.h"


@implementation NSDate (NSDate_Utilidad);

- (NSString *) enTimerContraAhora
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
	
	
	NSString *dias = [[NSString alloc] init];
	NSString *horas = [[NSString alloc] init];
	NSString *mins = [[NSString alloc] init];
	
	BOOL diasListo = false;
    BOOL horasListo = false;
    BOOL minsListo = false;
    
    if ([conversionInfo day] == 0) {
		dias = @"";
        diasListo = true;
	}
    
	if ([conversionInfo day] == 1) {
		dias = @"1 dia";
        diasListo = true;
	}
	
	if ([conversionInfo hour] == 0) {
		horas = @"";
        horasListo = true;
	}
	
    if ([conversionInfo hour] == 1) {
		horas = @"1 hora";
        horasListo = true;
	}
	
	if ([conversionInfo minute] == 0) {
		mins = @"";
        minsListo = true;
	}
	
	if ([conversionInfo minute] == 1) {
		mins = @"1 min";
        minsListo = true;
	}
    
    if (!diasListo)
        dias = [NSString stringWithFormat:@"%d dias", (-1) * [conversionInfo day]];
    if (!horasListo)
        horas = [NSString stringWithFormat:@"%d horas", (-1) * [conversionInfo hour]];
    if (!minsListo)
        mins = [NSString stringWithFormat:@"%d mins", (-1) * [conversionInfo minute]];
	
	tiempoQueFalta = [NSString stringWithFormat:@"%@ %@ %@", dias, horas, mins ];
	
	NSLog(@"Faltan: %@", tiempoQueFalta);
	
	[date1 release];
	[date2 release];
	
	
	return tiempoQueFalta;
	
}


@end
