//
//  TSBusquedaSeleccionTextoViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSClipBusquedaViewController.h"


@interface TSBusquedaSeleccionTextoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    TSClipBusquedaViewController *controladorBusqueda;
    UITextField *campoTexto;
    UITableView *tableView;
    
}

@property (nonatomic, retain) TSClipBusquedaViewController *controladorBusqueda;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UITextField *campoTexto;
@end
