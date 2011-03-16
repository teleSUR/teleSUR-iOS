//
//  TSBusquedaSeleccionTextoViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSBusquedaSeleccionTextoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITextField *texto;
    UITableView *tableView;
    
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UITextField *texto;
@end
