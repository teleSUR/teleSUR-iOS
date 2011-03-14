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
#define kPERSONAJES_ROW   0
#define kCORRESPONSAL_ROW 1

// Sección FECHA
#define kDESDE_ROW   0
#define kHASTA_ROW   1



@implementation TSClipBusquedaViewController

#pragma mark - Memoria

-(id) initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"hola!");
    
    if ((self =  [super initWithStyle:UITableViewStyleGrouped])) {
        
    }
    return self;
    
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"hola1!");
    
    if ((self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
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



#pragma mark - Table view data source

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
            
            return 2; // desde, hasta
            
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.section)
    {
        case kTEXTO_SECTION:
            
            cell.textLabel.text = @"Búsqueda de Texto";
            cell.detailTextLabel.text = @"Prueba";
            
            break;
            
        case kCLASIFICACION_SECTION:
            
            switch (indexPath.row)
            {
                case kTIPO_ROW:
                    
                    cell.textLabel.text = @"Tipo";
                    
                    break;
                    
                case kCATEGORIA_ROW:
                    
                    cell.textLabel.text = @"Sección";
                    
                case kTEMA_ROW:
                    
                    cell.textLabel.text = @"Tema";
                    
                default:
                    break;
            }
            break;
        case kUBICACION_SECTION:
            
            switch (indexPath.row) {
                case kREGION_ROW:
                    cell.textLabel.text = @"Región";
                    break;
                case kPAIS_ROW:
                    cell.textLabel.text = @"País";
                default:
                    break;
            }
            
            
            break;
            
        case kPERSONAS_SECTION:
            
            switch (indexPath.row) {
                case kCORRESPONSAL_ROW:
                    cell.textLabel.text = @"Corresponsal";
                    break;
                case kPERSONAJES_ROW:
                    cell.textLabel.text = @"Personajes";
                default:
                    break;
            }
            
            break;
        case kFECHA_SECTION:
            
            switch (indexPath.row) {
                case kDESDE_ROW:
                    cell.textLabel.text = @"Desde";
                    break;
                case kHASTA_ROW:
                    cell.textLabel.text = @"Hasta";
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section)
    {
        case kTEXTO_SECTION:
            
            return @"Palabras clave";
            
        case kCLASIFICACION_SECTION:
            
            return @"Clasificación";
            
        case kUBICACION_SECTION:
            
            return @"Ubicación";
            
        case kPERSONAS_SECTION:
            
            return @"Personas";
            
        case kFECHA_SECTION:
            
            return @"Fecha";	
            
        default:
            NSLog(@"Advertencia: Sección Reconocida: %d!", section);
            return @"";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    				      
}


@end
