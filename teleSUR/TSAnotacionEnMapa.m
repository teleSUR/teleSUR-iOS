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

@synthesize sinCoordenadas;

-(id) initWithDiccionarioNoticia: (NSDictionary *) unDiccionario
{
    if ((self = [super init]))
    {
        self.noticia = unDiccionario;
        
        NSString *coord = [self.noticia valueForKey:@"geotag"];
        
        if (![coord isKindOfClass:[NSNull class]] && ![coord isEqualToString:@""])
        {
            NSArray *arregloCoordenadas;
            self.sinCoordenadas = NO;
            
            arregloCoordenadas = [(NSString *)coord componentsSeparatedByString:@","];
            //arregloCoordenadas = [(NSString *)[diccionarioPais valueForKey:@"geotag"] componentsSeparatedByString:@","];
            if ([arregloCoordenadas count] > 1) {
                
                double latitud2 = atof([(NSString *) [arregloCoordenadas objectAtIndex:0] UTF8String]);
                double longitud2 = atof([(NSString *) [arregloCoordenadas objectAtIndex:1] UTF8String]);

                coordinate.longitude = longitud2;
                coordinate.latitude = latitud2;         
                //NSLog(@"----%@, %@", [arregloCoordenadas objectAtIndex:1], [arregloCoordenadas objectAtIndex:0]);
                //NSLog(@"----%f, %f", coordinate.longitude, coordinate.latitude);
            }
        }
        else
        {
            self.sinCoordenadas = YES;
            NSLog(@"Sin geotag!");
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
    

    NSString *lugar;
    if (![[self.noticia valueForKey:@"ciudad"] isKindOfClass:[NSNull class]] && ! [[[self.noticia valueForKey:@"ciudad"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        lugar = [NSString stringWithFormat:@"%@, %@", [self.noticia valueForKey:@"ciudad"], [diccionarioPais valueForKey:@"nombre"]];
    }
    else
    {
        lugar = [diccionarioPais valueForKey:@"nombre"];
    }
    
    
    if (![diccionarioCorresponsal isKindOfClass:[NSNull class]])
    {   
        return [NSString stringWithFormat:@"%@: %@", [diccionarioCorresponsal valueForKey:@"nombre"], lugar];
    }
    else
    {
        return lugar;
    }
}


@end
