//
//  TSClipDetallesViewController.h
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSClipDetallesViewController : UIViewController {
    
    // Controladores
	UITableViewController *detallesTableViewController;
	
	// Sub-Vistas
	UITableView *detallesTableView;
    
    // Datos
    NSDictionary *clip;
    
}

// Controladores
@property (nonatomic, retain) UITableViewController *detallesTableViewController;

// Sub-Vistas
@property (nonatomic, retain) IBOutlet UITableView *detallesTableView;

// Datos
@property (nonatomic, retain) NSDictionary *clip;


// Init
- (id)initWithClip:(NSDictionary *)diccionarioClip;

@end
