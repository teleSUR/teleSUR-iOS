//
//  TSTeleStrip.m
//  teleSUR
//
//  Created by Hector Zarate on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSTeleStrip.h"
#import "TSClipListadoViewController.h"
#import "TSDescripcionNoticiaStrip.h"


#define kVelocidadMovimiento 0.2

@implementation TSTeleStrip

@synthesize noticias, vistaInterior;
@synthesize vistaMovimiento;
@synthesize numeroCaracteres;
@synthesize listado;
@synthesize detenerAnimacion;
@synthesize controlPopOver;

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
        self.numeroCaracteres += [(NSString *)[[self.noticias objectAtIndex:i] valueForKey:@"titulo"] length];
        
        UIButton *unaNoticia = [UIButton buttonWithType:UIButtonTypeCustom];
        unaNoticia.tag = i;
        unaNoticia.backgroundColor = [UIColor clearColor];
        unaNoticia.titleLabel.textColor = [UIColor whiteColor];
        
        [unaNoticia addTarget:self action:@selector(detenerAnimacionNoticias:) forControlEvents:UIControlEventTouchDown];
        [unaNoticia addTarget:self action:@selector(reanudarAnimacionNoticias:) forControlEvents:UIControlEventTouchUpInside];
        unaNoticia.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];

        [unaNoticia setTitle: [NSString stringWithFormat:@"%@ |", [[self.noticias objectAtIndex:i] valueForKey:@"titulo"]] forState:UIControlStateNormal];
        CGSize labelSize = [unaNoticia.titleLabel.text sizeWithFont: unaNoticia.titleLabel.font];
        
        unaNoticia.frame = CGRectMake(offsetX, 7, labelSize.width, labelSize.height);        
        
        [self.vistaMovimiento addSubview:unaNoticia];
        self.vistaMovimiento.frame = CGRectMake(self.vistaInterior.frame.size.width, self.vistaMovimiento.frame.origin.y, offsetX, self.vistaMovimiento.frame.size.height);            
        // Actualizar offset
        offsetX += unaNoticia.frame.size.width + 8;
    }
    
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animarNuevaNoticiaDesdeInicio:) userInfo:nil repeats:YES];

    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	
    [runLoop addTimer:timer1 forMode:NSDefaultRunLoopMode];

}

-(IBAction) reanudarAnimacionNoticias: (id) sender 
{
    self.detenerAnimacion = NO;
    [controlPopOver dismissPopoverAnimated:YES];
}
         
-(IBAction) detenerAnimacionNoticias: (id) sender
{
    UIButton *boton = (UIButton *) sender;
    
    NSLog(@"%@", boton.titleLabel.text);
    self.detenerAnimacion =YES;
    
    TSDescripcionNoticiaStrip *vistaNoticia = [[TSDescripcionNoticiaStrip alloc] init];
    
    
    
    
    controlPopOver = [[UIPopoverController alloc] initWithContentViewController:vistaNoticia];

    CGRect rectanguloPosicional = CGRectMake(self.vistaMovimiento.frame.origin.x+boton.frame.origin.x, self.vistaMovimiento.frame.origin.y, boton.frame.size.width, boton.frame.size.height);
    
    NSLog(@"%f", self.vistaMovimiento.frame.origin.x);
    vistaNoticia.titulo.text = [[noticias objectAtIndex: boton.tag] valueForKey:@"titulo"];
    vistaNoticia.contenidoNoticia.text = [[noticias objectAtIndex: boton.tag] valueForKey:@"descripcion"];
    
    float nuevaAltura = [vistaNoticia ajustarTamanoTexto];
    controlPopOver.popoverContentSize = CGSizeMake(320, nuevaAltura);    
    
    
    //    self.controlPopOver.
    //    [controlPopOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [controlPopOver presentPopoverFromRect:rectanguloPosicional inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
}

-(void) animarNuevaNoticiaDesdeInicio: (BOOL) banderaInicio
{

    
    if (!self.detenerAnimacion) {
        if (self.vistaMovimiento.frame.origin.x-1 >= -self.vistaMovimiento.frame.size.width)
        {
            float nuevaPosicionX = self.vistaMovimiento.frame.origin.x-1;
            self.vistaMovimiento.frame = CGRectMake(nuevaPosicionX, self.vistaMovimiento.frame.origin.y, offsetX, self.vistaMovimiento.frame.size.height);        
            
        } else
        {
            self.vistaMovimiento.frame = CGRectMake(self.vistaInterior.frame.size.width, self.vistaMovimiento.frame.origin.y, offsetX, self.vistaMovimiento.frame.size.height);            
            [self animarNuevaNoticiaDesdeInicio:YES];
        }
    }
    


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
    [self.noticias addObjectsFromArray:array];
    
    [self iniciarAnimacion];
}

@end
