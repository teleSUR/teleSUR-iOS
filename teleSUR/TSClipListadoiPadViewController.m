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
<<<<<<< HEAD
#import "TSTeleStrip.h"
=======
#import "TSClipBusquedaViewController.h"
>>>>>>> e1944401b72502b942b3fbacf41ce63947502c85

@implementation TSClipListadoiPadViewController

@synthesize strips;
@synthesize tipos;
@synthesize  scrollStrips;
@synthesize vistaUltimoClip;

@synthesize listadoVideoUnico;

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

-(IBAction) mostrarBusqueda: (id) sender
{
    if([self.controlPopOver isPopoverVisible])
    {
        //close the popover view if toolbar button was touched
        //again and popover is already visible
        //Thanks to @chrisonhismac
        
        [self.controlPopOver dismissPopoverAnimated:YES];
        return;
    }

    
    UINavigationController *controlNavegacion = [[UINavigationController alloc] init];
    
    TSClipBusquedaViewController *busquedaView = [[TSClipBusquedaViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [controlNavegacion pushViewController:busquedaView animated:NO];
    
    self.controlPopOver = [[UIPopoverController alloc] initWithContentViewController:controlNavegacion];
    
    [controlPopOver presentPopoverFromBarButtonItem:self.botonBusqueda permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    [busquedaView release];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.strips = [[NSMutableArray alloc] init];

    self.tipos = [NSMutableArray arrayWithObjects:@"politica", @"cultura", @"economia", @"ciencia", nil];
    
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"TSClipCellStripBigView" owner:self options:nil];
    [self.vistaUltimoClip addSubview:[nibViews lastObject]];
    self.vistaUltimoClip = [nibViews lastObject];
    
    TSTeleStrip *vistaTeleStrip = (TSTeleStrip *) [[[NSBundle mainBundle] loadNibNamed:@"TSTeleStrip" owner:self options:nil] lastObject];
    [vistaTeleStrip obtenerDatosParaTeleStrip];
     
    [[self.view viewWithTag:99] addSubview:vistaTeleStrip];
    
    self.listadoVideoUnico = [[TSClipListadoViewController alloc] init];        
    
    

    [self.listadoVideoUnico prepararListado];
    self.listadoVideoUnico.rangoUltimo = NSMakeRange(0, 1);    
    [self.listadoVideoUnico cargarClips];
    
    self.listadoVideoUnico.delegate = self;
    
    
    

    
    [self.scrollStrips setContentSize:CGSizeMake(self.view.frame.size.width, [self.tipos count]*(kMargenStrips+kAlturaStrip))];
    
    for (int i=0;i<[self.tipos count]; i++)
    {

        
        
        
        TSClipStrip *stripClips1 = [[TSClipStrip alloc] init];
        stripClips1.nombreCategoria = [self.tipos objectAtIndex:i];
        stripClips1.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:[self.tipos objectAtIndex:i] forKey:@"categoria"];
        stripClips1.posicion = i;
        [stripClips1 cargarClips];
        [stripClips1 setFrame:CGRectMake(kMargenStrips, ((kMargenStrips)+kAlturaStrip)*i, self.view.frame.size.width-(kMargenStrips*2), kAlturaStrip)];
        [stripClips1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        [self.scrollStrips addSubview:stripClips1];    
        [self.strips addObject:stripClips1];
        [stripClips1 release];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) retirarModalView 
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) mostrarVideoTiempoReal: (id) sender
{

    if (self.switchVideoEnVivo.state == 0) {
    NSString *moviePath = @"http://streaming.tlsur.net:1935/live/vivo.stream/playlist.m3u8";
    NSURL *movieURL = [NSURL URLWithString:moviePath];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    player.view.frame = CGRectMake(0.0, 44.0, 1024, 704);
    [self.view addSubview:player.view];
    [player play];
    } else
    {
//        [self.view 
    }
    

}

-(IBAction) mostrarVideoDeControlador
{
    
    
    TSClipDetallesViewController *detalleView = [[TSClipDetallesViewController alloc] initWithClip:[[self.listadoVideoUnico clips] lastObject]];
    
    detalleView.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:detalleView animated:YES  ];
    
    [detalleView release];

    
}

-(IBAction) mostrarVideo: (UIButton *) sender
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
    
    AsynchronousImageView *imageView;
    if ((imageView = (AsynchronousImageView *)self.vistaUltimoClip.imagen ))
    {
        imageView.url = [NSURL URLWithString:[unDiccionario valueForKey:@"thumbnail_grande"]];
        [imageView cargarImagenSiNecesario];
    }
}
@end
