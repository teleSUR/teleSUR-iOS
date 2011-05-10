//
//  TSTeleStrip.m
//  teleSUR
//
//  Created by Hector Zarate on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSTeleStrip.h"
#import "TSClipListadoViewController.h"

#define kVelocidadMovimiento 0.2

@implementation TSTeleStrip

@synthesize noticias, vistaInterior;
@synthesize vistaMovimiento;
@synthesize numeroCaracteres;
@synthesize listado;

-(void) obtenerDatosParaTeleStrip 
{
    self.noticias = [[NSMutableArray alloc] init];    
    self.listado = [[TSClipListadoViewController alloc] init];        
    
    
    
    [self.listado prepararListado];

    [self.listado cargarClips];
    
    self.listado.delegate = self;

    
    

}

-(void) iniciarAnimacion 
{
    self.numeroCaracteres = 0;
    offsetX = 0 + 8;//TSMargenMenu;
    
    // Recorrer filtros
    for (int i=0; i < [self.noticias count]; i++)
    {
        self.numeroCaracteres += [(NSString *)[self.noticias objectAtIndex:i] length];
        
        UILabel *unaNoticia = [[UILabel alloc] init];
        unaNoticia.backgroundColor = [UIColor clearColor];
        unaNoticia.textColor = [UIColor whiteColor];
        
        unaNoticia.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        unaNoticia.text = [self.noticias objectAtIndex:i];
        CGSize labelSize = [unaNoticia.text sizeWithFont: unaNoticia.font];
        
        unaNoticia.frame = CGRectMake(offsetX, 11, labelSize.width, labelSize.height);        
        
        [self.vistaMovimiento addSubview:unaNoticia];
        
        // Actualizar offset
        offsetX += unaNoticia.frame.size.width + 8;
    }
    
    [self animarNuevaNoticia];
}

-(void) animarNuevaNoticia
{
    self.vistaMovimiento.frame = CGRectMake(self.vistaInterior.frame.size.width, self.vistaMovimiento.frame.origin.y, offsetX, self.vistaMovimiento.frame.size.height);    
    
    [UIView beginAnimations:@"mostrarTableView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animarNuevaNoticia)];
    [UIView setAnimationDuration:kVelocidadMovimiento * self.numeroCaracteres];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.vistaMovimiento.frame = CGRectMake(-self.vistaMovimiento.frame.size.width, self.vistaMovimiento.frame.origin.y, offsetX, self.vistaMovimiento.frame.size.height);    
    
    [UIView commitAnimations];

}

-(void) reciclarNoticia
{
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{
    for(NSDictionary *unDiccionario in array)
    {
        [self.noticias addObject: [NSString stringWithFormat:@"%@   |", [unDiccionario valueForKey:@"titulo"]]];

    }
    
    [self iniciarAnimacion];
}

@end
