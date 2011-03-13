//
//  TSClipBusquedaViewController.m
//  teleSUR
//
//  Created by David Regla on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipBusquedaViewController.h"

// TODO: Integrar estas constantes mejor a configuración, quizá plist principal
// Orden de secciones
#define kTEXTO_SECTION         0
#define kCLASIFICACION_SECTION 1
#define kUBICACION_SECTION     2
#define kPERSONAS_SECTION      3
#define kFECHA_SECTION         4

// Sección PALABRAS
#define kTEXTO_ROW 0

// Sección CLASIFICACION
#define kTIPO_ROW      0
#define kCATEGORIA_ROW 1
#define kTEMA_ROW      2

// Sección UBICACION
#define kREGION_ROW   0
#define kPAIS_ROW     1

// Sección PERSONAS
#define kPERSONAJES   0
#define kCORRESPONSAL 1

// Sección FECHA
#define kDESDE_ROW   0
#define kHASTA_ROW   1



@implementation TSClipBusquedaViewController

#pragma mark - Memoria

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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case kTEXTO_SECTION:
            
            return 1; // texto
            
        case kCLASIFICACION_SECTION:
            
            return 3; // tipo, categoría, tema
        
        case kUBICACION_SECTION:
            
            return 2; // región, país
        
        case kPERSONAS_SECTION:
            
            return 2; // personajes, corresponsal
        
        case kFECHA_SECTION:
            
            return 1; // desde, hasta
            
        default:
            
            NSLog(@"sección de tabla no reconocida: %d", section);
            
            return 0;
    } 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *CellIdentifier = @"busquedaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    
    switch (section)
    {
        case kTEXTO_SECTION:
            
            label.text = @"Palabras clave";
            
            break;
            
        case kCLASIFICACION_SECTION:
            
            label.text = @"Clasificación";
            
            break;
            
        case kUBICACION_SECTION:
            
            label.text = @"Ubicación";
            
            break;
            
        case kPERSONAS_SECTION:
            
            label.text = @"Personas";
            
            break;
            
        case kFECHA_SECTION:
            
            label.text = @"Fecha";
            
            break;
    }
    
    label.text = [NSString stringWithFormat:@"   %@", label.text];
    return label;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    				      
}


@end
