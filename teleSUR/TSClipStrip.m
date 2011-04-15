//
//  TSClipStrip.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipStrip.h"
#import "TSClipListadoViewController.h"
#import "TSMultimediaDataDelegate.h"
#import "TSClipListadoiPadViewController.h"
#import "TSClipCellStripView.h"

@implementation TSClipStrip

@synthesize listado;


-(id) init
{
    if ((self = [super init])) {
        


        self.showsHorizontalScrollIndicator = YES;
        self.scrollEnabled =YES;
        
        
        
        self.listado = [[TSClipListadoViewController alloc] init];
        [self.listado viewDidLoad];
        [self.listado cargarClips];
        self.listado.delegate = self;
        
    }
    return self;
    
}


-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    int offsetX = 0 + 10;
    
    int anchoCelda;
    for (NSDictionary *unDiccionario in array)
    {
        
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"TSClipCellStripView" owner:self options:nil];
        
        TSClipCellStripView *celdaClip = [nibViews lastObject];

        
        celdaClip.titulo.text = [unDiccionario valueForKey:@"titulo"];
        celdaClip.tiempo.text = [unDiccionario valueForKey:@"duracion"];
        // Actualizar offset
        
        CGRect tempFrame = celdaClip.frame;
        tempFrame.origin.x = offsetX;
        celdaClip.frame = tempFrame;
        
        // Actualizar offset
        offsetX += celdaClip.frame.size.width + 10;
        
        // Añadir botón a la jerarquón de vistas
        [self addSubview:celdaClip];
        
    }
    [self setContentSize: CGSizeMake([array count]*(220+10), kAlturaStrip)];
    NSLog(@"RECIBIDASSSSSS");
}



-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}



@end
