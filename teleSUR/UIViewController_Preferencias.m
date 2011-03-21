//
//  UIViewController_Preferencias.m
//  teleSUR
//
//  Created by Hector Zarate on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController_Preferencias.h"


@implementation NSObject (UIViewController_Preferencias)

-(NSString *)idiomaDeContenido
{
    NSUserDefaults *preferencias = [NSUserDefaults standardUserDefaults]; 
    
    
	NSInteger entero = [[preferencias objectForKey:@"contenido"] intValue];

    
    
    if (entero ==0) [preferencias setObject:[NSNumber numberWithInt: 1] forKey:@"contenido"];    // valor defualt
    
    switch (entero) {
            
        case 1:
            
            return @"es";
            
        case 2:
            
            return @"pt";
            
        default:
            
            return @"es";
    }
}

-(NSInteger)numeroDeIdioma
{
    
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"contenido"];
     
}

@end
