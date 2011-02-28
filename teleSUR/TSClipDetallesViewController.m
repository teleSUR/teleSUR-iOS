//
//  TSClipDetallesViewController.m
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "TSClipDetallesViewController.h"


@implementation TSClipDetallesViewController

@synthesize clip;


- (id)initWithClip:(NSDictionary *)diccionarioClip
{
    self = [super init];
    if (self) {
        self.clip = diccionarioClip;
    }
    return self;
}

#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{
    // Provisional
    [[self.view viewWithTag:1] setText:[clip valueForKey:@"descripcion"]];
    [[self.view viewWithTag:2] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://stg.multimedia.tlsur.net/media/%@", [clip valueForKey:@"imagen"]]]]]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)dealloc
{
    self.clip = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
