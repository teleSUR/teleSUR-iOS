//
//  TSSeleccionIdioma.m
//  teleSUR
//
//  Created by Hector Zarate on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSSeleccionIdioma.h"
#import "UIViewController_Preferencias.h"
#import "TSClipListadoViewController.h"

@implementation TSSeleccionIdioma

@synthesize vistaListado, tableView;

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
    [arregloIdiomas release];
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
    NSString *bPath = [[NSBundle mainBundle] bundlePath];
    NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
    
    //Get the Preferences Array from the dictionary
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    NSDictionary *diccionarioIdiomas = [preferencesArray objectAtIndex:1];
    
    NSArray *arregloIdiomasBundlePreferencias = [diccionarioIdiomas valueForKey:@"Titles"];
    
    arregloIdiomas = [arregloIdiomasBundlePreferencias retain];
    
    [super viewDidLoad];
}
    
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Selecciona un idioma para el contenido de los videos", @"Selecciona un idioma para el contenido de los videos") ;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
        return NSLocalizedString(@"Esta configuración puede ser cambiada en las preferencias de la aplicación.", @"Esta configuración puede ser cambiada en las preferencias de la aplicación.");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arregloIdiomas count];   
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    cell.textLabel.text = [arregloIdiomas objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *bPath = [[NSBundle mainBundle] bundlePath];
    NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
    
    //Get the Preferences Array from the dictionary
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    NSDictionary *diccionarioIdiomas = [preferencesArray objectAtIndex:1];
    
    NSArray *arregloValoresIdiomasBundlePreferencias = [diccionarioIdiomas valueForKey:@"Values"];
    
    NSLog(@"Numero: %d", [[arregloValoresIdiomasBundlePreferencias objectAtIndex:indexPath.row] intValue]);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[arregloValoresIdiomasBundlePreferencias objectAtIndex:indexPath.row] forKey:@"contenido"];
    
    [defaults synchronize];
    
    [self.vistaListado cargarClips];
    
    [self dismissModalViewControllerAnimated:YES];
    

    
}


@end
