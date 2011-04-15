//
//  TSClipStrip.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipStrip.h"


@implementation TSClipStrip

@synthesize clips, indiceDeClipSeleccionado;
@synthesize rangoUltimo, arregloClipsAsyncImageViews;
@synthesize diccionarioConfiguracionFiltros, agregarAlFinal;


-(id) init
{
    if ((self = [super init])) {
        
    }
    return self;
    
}


@end
