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

@implementation TSClipListadoiPadViewController

@synthesize strips;
@synthesize tipos;
@synthesize  scrollStrips;
@synthesize vistaUltimoClip;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.strips = [[NSMutableArray alloc] init];

    self.tipos = [NSMutableArray arrayWithObjects:@"politica", @"cultura", @"economia", @"ciencia", nil];
    
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"TSClipCellStripBigView" owner:self options:nil];
    [self.vistaUltimoClip addSubview:[nibViews lastObject]];
    self.vistaUltimoClip = [nibViews lastObject];
    
    
    
    TSClipListadoViewController *listado = [[TSClipListadoViewController alloc] init];        
    
    [listado viewDidLoad];
    [listado cargarClips];
    listado.delegate = self;
    
    
    

    
    [self.scrollStrips setContentSize:CGSizeMake(self.view.frame.size.width, [self.tipos count]*(kMargenStrips+kAlturaStrip))];
    
    for (int i=0;i<[self.tipos count]; i++)
    {
        TSClipStrip *stripClips1 = [[TSClipStrip alloc] init];
        stripClips1.listado.diccionarioConfiguracionFiltros = [NSDictionary dictionaryWithObject:[self.tipos objectAtIndex:i] forKey:@"categoria"];
        [stripClips1 cargarClips];
        [stripClips1 setFrame:CGRectMake(kMargenStrips, ((kMargenStrips)+kAlturaStrip)*i, self.view.frame.size.width-(kMargenStrips*2), kAlturaStrip)];
        [stripClips1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.scrollStrips addSubview:stripClips1];    
        
        [stripClips1 release];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
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
