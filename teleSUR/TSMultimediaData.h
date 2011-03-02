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
    
	id <NSObject, TSMultimediaDataDelegate>  delegate;
	NSMutableData *JSONData;
    @private NSString *entidadString;
    
}

@property (nonatomic, assign) id <NSObject, TSMultimediaDataDelegate>  delegate;
@property (nonatomic, retain) NSString *entidadString;

- (void)getDatosParaEntidad:(NSString *)entidad conFiltros:(NSDictionary *)filtros enRango:(NSRange)rango conDelegate:(id)datosDelegate;

@end

