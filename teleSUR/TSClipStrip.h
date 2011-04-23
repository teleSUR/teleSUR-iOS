//
//  TSClipStrip.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMultimediaDataDelegate.h"

@class TSClipListadoViewController;


@interface TSClipStrip : UIScrollView <TSMultimediaDataDelegate> {
    
    char posicion;    
    
    NSString *nombreCategoria;
    
    TSClipListadoViewController *listado;
    NSMutableArray *tipos;
    
}

@property (nonatomic, retain) NSString *nombreCategoria;

@property (nonatomic, assign) char posicion;

@property (nonatomic, assign) id <NSObject, TSMultimediaDataDelegate>  delegate;
@property (nonatomic, retain) TSClipListadoViewController *listado;
@property (nonatomic, retain) NSMutableArray *tipos;

-(void) cargarClips;

@end
