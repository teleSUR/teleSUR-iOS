//
//  TSDescripcionNoticiaStrip.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSDescripcionNoticiaStrip.h"


@implementation TSDescripcionNoticiaStrip

@synthesize titulo, contenidoNoticia;

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

-(float) ajustarTamanoTexto
{
    NSLog(@"%@", self.contenidoNoticia.text);
    
    CGSize maximumLabelSize = CGSizeMake(262,9999);
    CGSize expectedLabelSize = [self.contenidoNoticia.text
                                sizeWithFont:self.contenidoNoticia.font 
                                constrainedToSize:maximumLabelSize 
                                lineBreakMode:self.contenidoNoticia.lineBreakMode];
    
    NSLog(@"Expected Size: %f-%f",expectedLabelSize.width, expectedLabelSize.height );
    
//    self.descripcionCell.frame = CGRectMake(self.descripcionCell.frame.origin.x, self.descripcionCell.frame.origin.y, self.descripcionCell.frame.size.width, expectedLabelSize.height+15);
//    self.descripcionCell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.contenidoNoticia.frame = CGRectMake(self.contenidoNoticia.frame.origin.x, self.contenidoNoticia.frame.origin.y, self.contenidoNoticia.frame.size.width,expectedLabelSize.height);
    
    return self.contenidoNoticia.frame.size.height + self.titulo.frame.size.height + 16;// + 10;
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
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

@end
