//
//  TSMultimediaData.h
//  teleSUR-iOS
//
//  Created by David Regla on 2/12/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMultimediaDataDelegate.h"

@interface TSMultimediaData : NSObject {	
	// selectores y delegado 
	id <NSObject, TSMultimediaDataDelegate>  delegate;
	// respuesta en JSON y resultado del parse
	NSMutableData *resultadoAPIData; 	    
	NSArray *resultadoAPIArray;
    
    NSString *entidadActual;
}

@property (nonatomic, assign) id <NSObject, TSMultimediaDataDelegate>  delegate;

+ (TSMultimediaData *)sharedTSMultimediaData;

- (void)getDatosParaEntidad:(NSString *)entidad
		   conFiltros:(NSDictionary *)filtros
			  enRango:(NSRange)rango
		  conDelegate:(id)datosDelegate;

@end

