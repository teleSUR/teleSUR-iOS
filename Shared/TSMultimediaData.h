//
//  TSMultimediaData.h
//  teleSUR-iOS
//
//  Created by David Regla on 2/12/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TSMultimediaData : NSObject {
	NSDictionary *config;
	
	// selectores y delegado 
	id delegate;
    SEL siExito;
	SEL siFalla;
	// respuesta en JSON y resultado del parse
	NSMutableData *resultadoAPIData; 	    
	NSArray *resultadoAPIArray; 
}

@property (nonatomic, retain) NSDictionary *config;

+ (TSMultimediaData *)sharedTSMultimediaData;

- (NSArray *)getDatosParaEntidad:(NSString *)entidad
		   conFiltros:(NSDictionary *)filtros
			  enRango:(NSRange)rango
		  conDelegate:(id)datosDelegate
	  selectorSiExito:(SEL)exitoSelector
	  selectorSiFalla:(SEL)fallaSelector;

@end

