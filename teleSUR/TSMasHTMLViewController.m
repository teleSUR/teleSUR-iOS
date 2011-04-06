//
//  TSMasHTMLViewController.m
//  teleSUR
//
//  Created by David Regla on 3/30/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "TSMasHTMLViewController.h"
#import "UIViewController_Configuracion.h"


@implementation TSMasHTMLViewController

@synthesize webView, nombreHTML;


- (void)dealloc
{
    self.nombreHTML = nil;
    
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
    [self personalizarNavigationBar];
    [super viewDidLoad];
    
    if (!self.nombreHTML)
    {
        NSLog(@"No se ha especificó nombre de archivo HTML a depslegar.");
        return;
    }
    
    // Cargar HTML en webView
    NSData *htmlData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.nombreHTML ofType:@"html"]];  
    [self.webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:nil]];
    
    // Configurar webView
    self.webView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.webView = nil;
}


@end