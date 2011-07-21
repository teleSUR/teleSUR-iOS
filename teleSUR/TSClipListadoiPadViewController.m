//
//  TSClipListadoiPadViewController.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipListadoiPadViewController.h"
#import "TSClipStrip.h"
#import "TSClipListadoViewController.h"
#import "TSMultimediaDataDelegate.h"
#import "TSClipCellStripView.h"
#import "AsynchronousImageView.h"
#import "TSClipDetallesViewController.h"
#import "TSClipStrip.h"
#import "TSTeleStrip.h"
#import "TSClipBusquedaViewController.h"
#import "TSMasTableViewController.h"
#import "TSTabMenuiPad_UIViewController.h"
#import "teleSuriPadTabMenu.h"
#import "UIViewController_Configuracion.h"
#import "NSDictionary_Datos.h"

@implementation TSClipListadoiPadViewController

@synthesize strips;
@synthesize tipos;
@synthesize  scrollStrips;
@synthesize vistaUltimoClip;
@synthesize menu;
@synthesize listadoVideoUnico;
@synthesize barraNavegacion;
@synthesize vistaReproduccionVideoTiempoReal;

@synthesize vistaTwitter;

@synthesize vistaCargandoEnVivo;

@synthesize botonBusqueda, controlPopOver, switchVideoEnVivo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



-(IBAction) mostrarDetallesDeNoticiaStrip: (UIButton *) sender
{
    
}




-(void)viewDidAppear:(BOOL)animated
{
    [self.menu colocarSelectorEnPosicionOriginal];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.strips = [[NSMutableArray alloc] init];

    self.tipos = [NSMutableArray arrayWithObjects:@"politica", @"economia", @"deportes", @"cultura", @"ciencia", @"medio-ambiente", nil];
    
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"TSClipCellStripBigView" owner:self options:nil];
    [self.vistaUltimoClip addSubview:[nibViews lastObject]];
    self.vistaUltimoClip = [nibViews lastObject];
    
    TSTeleStrip *vistaTeleStrip = (TSTeleStrip *) [[[NSBundle mainBundle] loadNibNamed:@"TSTeleStrip" owner:self options:nil] lastObject];
    [vistaTeleStrip obtenerDatosParaTeleStrip];
     
    [[self.view viewWithTag:99] addSubview:vistaTeleStrip];

    
    // Poner imagen teleSur en la barra
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Header.png"]];
    
    self.barraNavegacion.topItem.titleView = imageView;
    
    [imageView release];
    
    

    
    [self.scrollStrips setContentSize:CGSizeMake(self.view.frame.size.width, [self.tipos count]*(kMargenStrips+kAlturaStrip))];
    
    for (int i=0;i<[self.tipos count]; i++)
    {        
        TSClipStrip *stripClips1 = [[TSClipStrip alloc] init];
        stripClips1.nombreCategoria = [self.tipos objectAtIndex:i];
        stripClips1.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObjectsAndKeys:[self.tipos objectAtIndex:i], @"categoria", @"noticia", @"tipo", nil];
        stripClips1.posicion = i;
        [stripClips1 cargarClips];
        [stripClips1 setFrame:CGRectMake(0, kMargenStrips + (kMargenStrips+kAlturaStrip)*i, self.view.frame.size.width/*-(kMargenStrips*2)*/, kAlturaStrip)];
        [stripClips1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        [self.scrollStrips addSubview:stripClips1];    
        [self.strips addObject:stripClips1];
        [stripClips1 release];
    }

    self.menu = [self cargarMenu];
    
    self.listadoVideoUnico = [[TSClipListadoViewController alloc] init];        
    self.listadoVideoUnico.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:@"noticia" forKey:@"tipo"];
    
    self.listadoVideoUnico.delegate = self;    
    [self.listadoVideoUnico prepararListado];
    
    self.listadoVideoUnico.rangoUltimo = NSMakeRange(1, 1);    
    [self.listadoVideoUnico cargarClips];

    // Get the tabbar frame
    
    CGRect tabbarFrame = self.tabBarController.tabBar.frame;
    
    // Create a new rect, to store the size and position
    CGRect previousTabbarFrame = CGRectMake(tabbarFrame.origin.x, tabbarFrame.origin.y, tabbarFrame.size.width, tabbarFrame.size.height);
    
    // Offset to move the tabbar, if we are going from/to fullscreen
    int fullscreen = 1;
    int offset = !fullscreen ? tabbarFrame.size.height : -1 * tabbarFrame.size.height;
    
    // Set tabbar Y position
    int tabBarY = tabbarFrame.origin.y + offset;
    tabbarFrame.origin.y = tabBarY;
    
    // Set the new tabbar frame
    self.tabBarController.tabBar.frame = tabbarFrame;
    
    // Fade out the tabbar, if we are going to fullscreen. Otherwise, fade it in.
    self.tabBarController.tabBar.alpha = fullscreen ? 0 : 1;
    

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)recargar
{
    [self.listadoVideoUnico cargarClips];
    
    [self.scrollStrips setContentOffset:CGPointMake(0, 0) animated:YES];
    
    for (TSClipStrip *strip in self.strips)
    {
        [strip setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    for (TSClipStrip *strip in self.strips)
    {
        [strip cargarClips];
    }
            
}

- (void)retirarModalView 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)mostrarVideoTiempoReal:(id)sender
{

    if (self.switchVideoEnVivo.on)
    {
        self.vistaCargandoEnVivo.alpha = 1.0;
        NSString *moviePath = [[[[NSBundle mainBundle] infoDictionary] valueForKey:@"Configuración"] valueForKey:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"Streaming URL Alta" : @"Streaming URL Media"];
        NSURL *movieURL = [NSURL URLWithString:moviePath];
        
        self.vistaReproduccionVideoTiempoReal = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        [self.vistaReproduccionVideoTiempoReal.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];
        self.vistaReproduccionVideoTiempoReal.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+44, self.view.frame.size.width, self.view.frame.size.height-44);
        
        [self.view addSubview:self.vistaReproduccionVideoTiempoReal.view];
        [self.vistaReproduccionVideoTiempoReal.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];        
        [self.vistaReproduccionVideoTiempoReal play];
    }
    else
    {
        self.vistaCargandoEnVivo.alpha = 0.0;        
        [self.vistaReproduccionVideoTiempoReal stop];
        [self.vistaReproduccionVideoTiempoReal.view removeFromSuperview];
        [self.vistaReproduccionVideoTiempoReal release];
    }
}

- (IBAction)mostrarVideoDeControlador
{
    UINavigationController *controlNavegacion = [[UINavigationController alloc] init];
    
    UIBarButtonItem *botonSalir = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStyleBordered target:self action:@selector(retirarModalView)];
    
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[[self.listadoVideoUnico clips] lastObject]];
    controlNavegacion.modalPresentationStyle = UIModalPresentationFormSheet;
    
    detalleView.navigationItem.leftBarButtonItem = botonSalir;    
    
    [controlNavegacion pushViewController:detalleView animated:NO];

    [self presentModalViewController:controlNavegacion animated:YES  ];
    
    [detalleView release];
    [controlNavegacion release];
}

- (IBAction)mostrarVideo:(UIButton *)sender
{
    UINavigationController *controlNavegacion = [[UINavigationController alloc] init];
    
    UIBarButtonItem *botonSalir = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStyleBordered target:self action:@selector(retirarModalView)];
    
    TSClipCellStripView *celda =  [sender superview];
    TSClipStrip *strip = [celda superview];
    
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[[[[self.strips objectAtIndex:strip.posicion] listado] clips] objectAtIndex:celda.posicion]];
    controlNavegacion.modalPresentationStyle = UIModalPresentationFormSheet;
    
    detalleView.navigationItem.leftBarButtonItem = botonSalir;    
    
    [controlNavegacion pushViewController:detalleView animated:NO];
    
    [self presentModalViewController:controlNavegacion animated:YES  ];
    
    [detalleView release];
    [controlNavegacion release];
}


- (void)viewDidUnload
{
    [self.strips release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



-(void)TSMultimediaData:(TSMultimediaData *)data  entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{    
    NSDictionary *unDiccionario = [array lastObject];
    
    self.vistaUltimoClip.titulo.text = [unDiccionario valueForKey:@"titulo"];
    self.vistaUltimoClip.tiempo.text = [unDiccionario valueForKey:@"duracion"];
    self.vistaUltimoClip.descripcion.text = [unDiccionario valueForKey:@"descripcion"];
    self.vistaUltimoClip.firma.text = [unDiccionario obtenerFirmaParaEsteClip];
    
    AsynchronousImageView *imageView;
    if ((imageView = (AsynchronousImageView *)self.vistaUltimoClip.imagen ))
    {
        imageView.url = [NSURL URLWithString:[unDiccionario valueForKey:@"thumbnail_mediano"]];
        [imageView cargarImagenSiNecesario];
    }
}
@end
