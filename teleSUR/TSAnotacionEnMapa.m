//
//  TSAnotacionEnMapa.m
//  teleSUR
//
//  Created by Hector Zarate on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSAnotacionEnMapa.h"

#import <MapKit/Mapkit.h>
#include <stdlib.h>
@implementation TSAnotacionEnMapa

@synthesize coordinate, noticia;

-(id) initWithDiccionarioNoticia: (NSDictionary *) unDiccionario
{
    if ((self = [super init]))
    {
        self.noticia = unDiccionario;
        
        NSDictionary *diccionarioPais = [self.noticia valueForKey:@"pais"];
        NSLog(@"%@", diccionarioPais);
        NSLog(@"Clase %@-%@", [diccionarioPais valueForKey:@"geotag"],[[diccionarioPais valueForKey:@"geotag"] class] );
        NSArray *arregloCoordenadas;
        
        
        if ([diccionarioPais valueForKey:@"geotag"] != [NSNull null]) {
            arregloCoordenadas = [(NSString *)[diccionarioPais valueForKey:@"geotag"] componentsSeparatedByString:@","];
            if ([arregloCoordenadas count] > 1) {
                
                double latitud2 = atof([(NSString *) [arregloCoordenadas objectAtIndex:0] UTF8String]);
                double longitud2 = atof([(NSString *) [arregloCoordenadas objectAtIndex:1] UTF8String]);

                coordinate.longitude = longitud2;
                coordinate.latitude = latitud2;         
                NSLog(@"----%@, %@", [arregloCoordenadas objectAtIndex:1], [arregloCoordenadas objectAtIndex:0]);
                NSLog(@"----%f, %f", coordinate.longitude, coordinate.latitude);
            }
        }
//        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        
        
    }
    return self;
}


-(NSString *)title
{
    return [self.noticia valueForKey:@"titulo"];
}

- (NSString *) subtitle
{
    NSDictionary *diccionarioPais = [self.noticia valueForKey:@"pais"];
    
    NSDictionary *diccionarioCorresponsal = [self.noticia valueForKey:@"corresponsal"];
    
    if (diccionarioCorresponsal)
    {
        return [diccionarioCorresponsal valueForKey:@"nombre"];
    }
    else
    {
        return [diccionarioPais valueForKey:@"nombre"];
    }
    
}


@end
