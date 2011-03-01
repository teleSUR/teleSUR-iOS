//
//  NSDictionary_Datos.h
//  teleSUR
//
//  Created by Hector Zarate on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (NSDictionary_Datos)

- (NSString *)obtenerFirmaParaEsteClip;
- (NSDate *)obtenerNSDateParaEsteClip;
- (NSString *)obtenerFechaCompletaParaEsteClip;
- (NSString *)obtenerTiempoDesdeParaEsteClip;

@end
