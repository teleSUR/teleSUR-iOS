//
//  NSDate_Utilidad.m
//  teleSUR
//
//  Created by Hector Zarate on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate_Utilidad.h"
#define kTIEMPO_JUSTO_AHORA 900

@implementation NSDate (NSDate_Utilidad);

- (NSString *)enTimerContraAhora
{
	NSDate *fechaFutura = [NSDate new];
	
	NSMutableString *tiempoQueFalta = [NSMutableString string];
	
	// Obtenemos los segundos faltantes para el sig sorteo
	NSTimeInterval tiempoFaltante = [self timeIntervalSinceDate:fechaFutura];
	
    if (tiempoFaltante > (kTIEMPO_JUSTO_AHORA *-1)) return NSLocalizedString(@"Justo Ahora",@"Justo Ahora");
    
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
    
    if ([conversionInfo day] == 0) diasListo = true;

    //NSLog(@"%d", [conversionInfo day]);
	if ([conversionInfo day] == -1) {
		dias = NSLocalizedString(@"1 día", @"1 día");
        diasListo = true;
	}
    
	if ([conversionInfo hour] == 0) horasListo = true;
	
	
    if ([conversionInfo hour] == -1) {
		horas = NSLocalizedString(@"1 hora", @"1 hora");
        horasListo = true;
	}
	
	if ([conversionInfo minute] == 0) minsListo = true;
	
	if ([conversionInfo minute] == -1) {
		mins = NSLocalizedString(@"1 min", @"1 min");
        minsListo = true;
	}
    

    
    if (!diasListo) {
        dias = [NSString stringWithFormat:@"%d %@", (-1) * [conversionInfo day], NSLocalizedString(@"días", @"días")];
    }
    if (!horasListo)
        horas = [NSString stringWithFormat:@"%d %@", (-1) * [conversionInfo hour], NSLocalizedString(@"horas", @"horas")];
    if (!minsListo)
        mins = [NSString stringWithFormat:@"%d %@", (-1) * [conversionInfo minute], NSLocalizedString(@"mins", @"mins")];
	
//	tiempoQueFalta = [NSString stringWithFormat:@"%@ %@ %@", dias, horas, mins ];
	
    int numeroDeComponentes = 0;
    
    [tiempoQueFalta appendString:NSLocalizedString(@"Hace ",@"Hace ")];
    
    if (![dias isEqualToString:@""])  { 
        numeroDeComponentes++;
        [tiempoQueFalta appendFormat:@"%@, ", dias];
    }
    if (![horas isEqualToString:@""]) {
        numeroDeComponentes++;        
        [tiempoQueFalta appendFormat:@"%@, ",horas];  
    }
    if (![mins isEqualToString:@""] && numeroDeComponentes < 2) {
        numeroDeComponentes++;        
        [tiempoQueFalta appendFormat:@"%@ ", mins];    
    }
    
	
	[date1 release];
	[date2 release];
	        
    return tiempoQueFalta;
}


@end
