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
	NSInteger entero = [preferencias integerForKey:@"contenido"];

    if (entero ==0) [preferencias setInteger:1 forKey:@"contenido"];    // valor defualt
    
    switch (entero) {
            
        case 1:
            
            return @"es";
            
        case 2:
            
            return @"pt";
            
        default:
            
            return @"es";
    }
}

@end
