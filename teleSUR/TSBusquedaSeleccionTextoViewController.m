//
//  TSBusquedaSeleccionTextoViewController.m
//  teleSUR
//
//  Created by Hector Zarate on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSBusquedaSeleccionTextoViewController.h"
#import "UIViewController_Configuracion.h"

@implementation TSBusquedaSeleccionTextoViewController

@synthesize controladorBusqueda, tableView, campoTexto;


- (void)dealloc
{
    self.controladorBusqueda = nil;
    self.tableView = nil;
    self.campoTexto = nil;
    
    [super dealloc];
}


#pragma mark - View lifecycle


-(void) viewWillAppear:(BOOL)animated
{
    [self.campoTexto becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{   
    [self.controladorBusqueda.selecciones setValue:self.campoTexto.text forKey:@"texto"];
    
    [self.controladorBusqueda.tableView reloadData];
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    [self personalizarNavigationBar];
    
    self.campoTexto = [[UITextField alloc] initWithFrame:CGRectMake(110, 12, 185, 30)];   
    self.campoTexto.delegate = self;
    self.campoTexto.textColor = [UIColor blackColor];
    self.campoTexto.clearButtonMode = UITextFieldViewModeAlways;
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"textoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }


    [cell addSubview:self.campoTexto];
    cell.textLabel.text = NSLocalizedString(@"Búsqueda", @"Búsqueda");

    return cell;
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

@end
