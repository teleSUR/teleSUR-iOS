//
//  NSDictionary_Datos.h
//  teleSUR
//
//  Created by Hector Zarate on 2/28/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (NSDictionary_Datos)

-(NSString *)obtenerFechaConDia;

- (NSString *)obtenerFirmaParaEsteClip;
- (NSDate *)obtenerNSDateParaEsteClip;
- (NSString *)obtenerFechaCompletaParaEsteClip;
- (NSString *)obtenerFechaLargaParaEsteClip;
- (NSString *)obtenerTiempoDesdeParaEsteClip;

- (NSString *)obtenerDescripcion;

- (int)duracionEnSegundos;

- (BOOL)esPrograma;

// Clasificadores
- (NSArray *)arregloDiccionariosClasificadores;
- (NSDictionary *)diccionarioClasificadorParaCampo:(NSString *)campo;

@end
