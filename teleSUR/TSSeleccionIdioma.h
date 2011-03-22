//
//  TSSeleccionIdioma.h
//  teleSUR
//
//  Created by Hector Zarate on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSClipListadoViewController;

@interface TSSeleccionIdioma : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *tableView;
    NSArray *arregloIdiomas;
    
    TSClipListadoViewController *vistaListado;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) TSClipListadoViewController *vistaListado;

@end
