//
//  TSSenchaLargoProgramasViewController.m
//  teleSUR
//
//  Created by David Regla on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSSenchaLargoProgramasViewController.h"
#import "TSMapaViewController.h"
#import "TSTabMenuiPad_UIViewController.h"
#import "teleSuriPadTabMenu.h"
#import "TSClipListadoViewController.h"
#import "TSMultimediaDataDelegate.h"
#import "TSMultimediaData.h"
#import "teleSURAppDelegate_iPad.h"
#import "TSClipPlayerViewController.h"


@implementation TSSenchaLargoProgramasViewController

@synthesize webView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    self.menu = [self cargarMenu];
    self.webView.delegate = self;
    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Programas" ofType:@"html"] isDirectory:NO]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    TSMultimediaData *dataClips = [[TSMultimediaData alloc] init];
    [dataClips getDatosParaEntidad:@"programa" // otros ejemplos: programa, pais, categoria
                        conFiltros:nil // otro ejemplo: conFiltros:[NSDictionary dictionaryWithObject:@"2010-01-01" forKey:@"hasta"]
                           enRango:NSMakeRange(1, 200)  // otro: NSMakeRange(1, 1) -s√≥lo uno-
                       conDelegate:self];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString: @".mp4" options: NSCaseInsensitiveSearch];
       
    if ( range.location != NSNotFound ) //opening MP4 video file
    {        
        TSClipPlayerViewController *player = [[TSClipPlayerViewController alloc] initConProgramaURL:[NSString stringWithFormat:@"%@", request.URL]];
        [player playEnViewController:self finalizarConSelector:@selector(videoTerminado) registrandoAccion:YES];
        [player release];
        
        return NO;
    }
    
    return YES;
} 


- (void)videoTerminado
{
    
}

- (void)recargar
{
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Programas" ofType:@"html"] isDirectory:NO]]];
}

- (void)showFullscreenMediaWithURL:(NSURL *)mediaURL
{
    MPMoviePlayerViewController *ctrl = [[MPMoviePlayerViewController alloc] initWithContentURL: mediaURL];
    
    ctrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController: ctrl animated: YES];
    
    [ctrl release];
}

- (void)viewWillDisappear:(BOOL)animated {
        //[self.webView stringByEvaluatingJavaScriptFromString:@"var myVideo=document.getElementById('video');myVideo.pause();myVideo.currentTime = -1;"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.menu colocarSelectorEnPosicionOriginal];
    
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma - TSMultimediaDataDelegate

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas:(NSArray *)array paraEntidad:(NSString *)entidad
{   
    if (entidad != @"programa") return;
    
    
    for (NSDictionary *prog in array)
    {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"add_programa('%@', '%@', '%@', '%@');", [prog valueForKey:@"slug"], [prog valueForKey:@"nombre"], [prog valueForKey:@"imagen_url"], [prog valueForKey:@"descripcion"]]];
    }
    
    teleSURAppDelegate_iPad *delegado = (teleSURAppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    NSString *tipo;
    if (delegado.tabBarController.selectedIndex == 2) {
        tipo = @"programas";
    }
    else if (delegado.tabBarController.selectedIndex == 3) {
        tipo = @"documentales";
    } else {
        tipo = @"reportajes";
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"iniciar('%@');", tipo]];
}

-(void)TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError:(id)error
{
    
}

@end







