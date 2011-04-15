//
//  TSClipStrip.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TSClipStrip : UIScrollView {
    
    // Arreglo de clips
    NSMutableArray *clips;
    
    // Banderas
    BOOL agregarAlFinal;
    
    // Auxiliares
    NSMutableDictionary *diccionarioConfiguracionFiltros;
    NSRange rangoUltimo;
    int indiceDeClipSeleccionado;
    NSMutableArray *arregloClipsAsyncImageViews;    
    
}

// Clips
@property (nonatomic, retain) NSMutableArray *clips;
@property (nonatomic, assign) NSRange rangoUltimo;
@property (nonatomic, assign) int indiceDeClipSeleccionado;
@property (nonatomic, assign) BOOL agregarAlFinal;
@property (nonatomic, retain) NSMutableArray *arregloClipsAsyncImageViews;
@property (nonatomic, retain) NSMutableDictionary *diccionarioConfiguracionFiltros;

// Operaciones
- (void)cargarClips;

@end
