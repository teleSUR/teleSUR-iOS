//
//  TSMapitaViewController.m
//  teleSUR
//
//  Created by David Regla on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TSMapitaViewController.h"

@interface TSMapitaViewController ()

@end

@implementation TSMapitaViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://telesur.kgdesignes.net/componentes/mapa.html?width=300&height=350&modo=minimalista&zoom=1"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
