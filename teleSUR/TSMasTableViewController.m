//
//  TSMasTableViewController.m
//  teleSUR
//
//  Created by Hector Zarate on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSMasTableViewController.h"
#import "UIViewController_Configuracion.h"
#import "TSMasHTMLViewController.h"

@implementation TSMasTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [self personalizarNavigationBar];    
    [super viewDidLoad];
    
    self.navigationController.title = @"Más";
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Acerca de teleSUR";
            break;
        case 1:
            return @"teleSUR en redes sociales";
            break;
        default:
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
        default:
            return 0; 
            break;
    }


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
        switch (indexPath.section) {
            case 0: // Primera Seccion
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;                        
                switch (indexPath.row) {
                        
                    case 0:
                        cell.textLabel.text = @"¿Quiénes somos?";
                        cell.imageView.image = [UIImage imageNamed:@"IconoLogo.png"];                                                 

                        break;
                    case 1:
                        cell.textLabel.text = @"Contáctenos";
                        cell.imageView.image = [UIImage imageNamed:@"mail.png"];                                                 
                    default:
                        break;
                }
                
                break;
                
            case 1: // Segunda Seccion
                
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"Facebook";
                        cell.imageView.image = [UIImage imageNamed:@"facebook-logo.png"];
                        break;
                    case 1:
                        cell.textLabel.text = @"Twitter";
                        cell.imageView.image = [UIImage imageNamed:@"twitter-logo.png"]; 
                        break;
                    case 2:
                        cell.textLabel.text = @"YouTube";
                        cell.imageView.image = [UIImage imageNamed:@"youtube-logo.png"]; 
                    default:
                        break;
                }
                
                break;
                
            default:
                
                break;
        }
        
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    switch (indexPath.section) {
        case 0: // Primera Seccion
            ;
            NSString *nombreHTML;
            
            switch (indexPath.row)
            {
                case 0:
                    
                    nombreHTML = @"TSQuienesSomos";
                    
                    break;
                    
                case 1:
                    
                    nombreHTML = @"TSContacto";

                    break;
            }
            
            
            TSMasHTMLViewController *htmlController = [[TSMasHTMLViewController alloc] init];
            htmlController.nombreHTML = nombreHTML;
            [self.navigationController pushViewController:htmlController animated:YES];
            [htmlController release];
            
            break;
            
        case 1: // Segunda Seccion
            
            switch (indexPath.row) {
                case 0:

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/teleSUR"]];
                    break;
                    
                case 1:

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/teleSURtv"]];                    
                    break;
                    
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/user/telesurtv"]];                    
                    break;
                    
            }
            
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
            
        default:
            
            break;
    }

    
}

@end
