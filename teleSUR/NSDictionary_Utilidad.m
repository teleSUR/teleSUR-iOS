//
//  NSDictionary_Utilidad.m
//  teleSUR
//
//  Created by Hector Zarate on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary_Utilidad.h"


@implementation NSDictionary (NSDictionary_Utilidad)

- (NSString *) obtenerFirmaParaEsteClip {
	
	NSString *resultado;
	
	NSString *pais = [[self valueForKey:@"pais"] valueForKey:@"nombre"];
	NSString *ciudad = [self valueForKey:@"ciudad"];
	
	NSString *locacion;
	
	if ([ciudad length] > 0) {
		locacion = [NSString stringWithFormat:@"%@, %@", pais, ciudad];
		
	} else {
		locacion = pais;
	}

	
	
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	
	[formater setDateStyle:NSDateFormatterMediumStyle];
	
	NSString *fechaEnString = [formater stringFromDate: [self obtenerNSDateParaEsteClip]];
	
	resultado = [NSString stringWithFormat:@"%@ | %@", fechaEnString, locacion];
	
	[formater release];
	
	return resultado;
	
								 
	
	
}

-(NSDate *) obtenerNSDateParaEsteClip {
	
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	
	[formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *date = [formater dateFromString: [self valueForKey:@"fecha"]];
	
	[formater release];
	
	return date;
	
	
}

@end
