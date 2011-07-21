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
#import "AsynchronousImageView.h"

#define kMargenPolaroidX 10

@implementation TSClipStrip

@synthesize listado;

@synthesize tipos;

@synthesize posicion;

@synthesize nombreCategoria;

-(id) init
{
    if ((self = [super init])) {
        
        self.showsHorizontalScrollIndicator = YES;
        self.scrollEnabled =YES;
        
        self.listado = [[TSClipListadoViewController alloc] init];        
        
    }
    return self;
    
}

-(void) cargarClips
{
    for (UIView *view in self.subviews)
        [view removeFromSuperview];
    
    [self.listado prepararListado];        
    [self.listado cargarClips];
    self.listado.delegate = self;
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    NSLog(@"recibbooo");
    int offsetX = 40 + kMargenPolaroidX;
    
    int anchoCelda;
    int i =0;
    
    
    for (NSDictionary *unDiccionario in array)
    {
        
        NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"TSClipCellStripView" owner:self options:nil];
        
        TSClipCellStripView *celdaClip = [nibViews lastObject];
        celdaClip.posicion = i;
        
        celdaClip.titulo.text = [unDiccionario valueForKey:@"titulo"];
        celdaClip.tiempo.text = [unDiccionario valueForKey:@"duracion"];
        
        // Imagen
        
        AsynchronousImageView *imageView;
        if ((imageView = (AsynchronousImageView *)celdaClip.imagen ))
        {
            imageView.url = [NSURL URLWithString:[unDiccionario valueForKey:@"thumbnail_pequeno"]];
            [imageView cargarImagenSiNecesario];
        }

        // Actualizar offset
        CGRect tempFrame = celdaClip.frame;
        tempFrame.origin.x = offsetX;
        celdaClip.frame = tempFrame;
        
        // Actualizar offset
        offsetX += celdaClip.frame.size.width + kMargenPolaroidX;
        
        // Añadir botón a la jerarquón de vistas
        [self addSubview:celdaClip];
        i++;
    }
    

    
    UIView *vistaEtiquetaGigante =  [[[NSBundle mainBundle] loadNibNamed:@"TSClipCategoriaView" owner:self options:nil] lastObject];
    vistaEtiquetaGigante.transform = CGAffineTransformMakeRotation(-M_PI/2);    
    CGRect frameHorizontal = vistaEtiquetaGigante.frame;
    
    frameHorizontal.origin.x = -1;
    frameHorizontal.origin.y = 1;
    
    vistaEtiquetaGigante.frame = frameHorizontal;
    
    // Poner etiqueta de la izquierda:
    
    if ([array count] != 0) [(UILabel *)[vistaEtiquetaGigante viewWithTag:1] setText: [[[array lastObject] valueForKey:@"categoria"] valueForKey:@"nombre"] ];
    
    
//    [(UILabel *)[vistaEtiquetaGigante viewWithTag:1] setText:self.nombreCategoria];
    
    [self addSubview:vistaEtiquetaGigante];
    

    [self setContentSize: CGSizeMake(([array count]*(170+kMargenPolaroidX))+ 39 + kMargenPolaroidX, kAlturaStrip)];
}



-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}



@end
