//
//  TSBusquedaSeleccionFechaViewController.m
//  teleSUR
//
//  Created by Hector Zarate on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSBusquedaSeleccionFechaViewController.h"
#import "TSClipBusquedaViewController.h"

@implementation TSBusquedaSeleccionFechaViewController

@synthesize pickerFecha, tableView;

@synthesize controladorBusqueda, fechaDesde, fechaHasta, seleccionTodos, seleccion;

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
    
    self.seleccion = 1;
    self.fechaDesde = self.pickerFecha.date;
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
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

-(void) viewWillDisappear:(BOOL)animated
{
//    [self.controladorBusqueda.selecciones setValue:self.seleccion forKey:self.entidad];
    [self.controladorBusqueda.tableView reloadData];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    self.seleccion = indexPath.row;
    
    switch (self.seleccion) {
        case 0:
            self.fechaDesde = nil;
            self.fechaHasta = nil;
            
            if (self.seleccionTodos) self.seleccionTodos = NO;
            else self.seleccionTodos =YES;

            [self.tableView reloadData];
            break;
        case 1:
        case 2:
            [[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];            
            break;
        
        default:
            break;
    }
    
    NSLog(@"%d-%d", indexPath.section, indexPath.row);
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *CellIdentifier = @"busquedaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];

    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Cualquier Fecha";
            if (self.seleccionTodos) 
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else 
                cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.textLabel.text = @"Desde";
            cell.detailTextLabel.text = [fechaDesde description];
            break;
        case 2:
            cell.textLabel.text = @"Hasta";
            cell.detailTextLabel.text = [fechaHasta description];            
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark UIPickerView Delegate
- (IBAction) cambioFechaDePickerView: (UIDatePicker *)picker
{
    self.seleccionTodos = NO;
    
    switch (self.seleccion) {
        case 1:
            self.fechaDesde = picker.date;
            break;
        case 2:
            self.fechaHasta = picker.date;            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

@end
