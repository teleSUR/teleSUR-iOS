//
//  TSClipListadoViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"
#import "PullToRefreshTableViewController.h"

extern NSInteger const TSNumeroClipsPorPagina;
extern NSString* const TSEntidadClip;

@interface TSClipListadoViewController : UIViewController <TSMultimediaDataDelegate> {
    
	id <NSObject, TSMultimediaDataDelegate>  delegate;    
    
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
@property (nonatomic, assign) id <NSObject, TSMultimediaDataDelegate>  delegate;

@property (nonatomic, retain) NSMutableArray *clips;
@property (nonatomic, assign) NSRange rangoUltimo;
@property (nonatomic, assign) int indiceDeClipSeleccionado;
@property (nonatomic, assign) BOOL agregarAlFinal;
@property (nonatomic, retain) NSMutableArray *arregloClipsAsyncImageViews;
@property (nonatomic, retain) NSMutableDictionary *diccionarioConfiguracionFiltros;

// Operaciones
- (void)cargarClips;

@end
