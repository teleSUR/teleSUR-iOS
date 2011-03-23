//
//  TSClipListadoTableViewController.h
//  teleSUR
//
//  Created by David Regla on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSClipListadoViewController.h"


@interface TSClipListadoTableViewController : TSClipListadoViewController <UITableViewDataSource, UITableViewDelegate> {
    PullToRefreshTableViewController *tableViewController;
    
    BOOL omitirVerMas;
    
    // Auxiliares
    CGFloat celdaEstandarHeight;
    CGFloat celdaGrandeHeight;
    CGFloat celdaVerMasHeight;
    
    NSIndexPath *indexPathSeleccionado;
}


- (void)reloadTableViewDataSource; // Para pull-to-refresh
- (NSString *)nombreNibParaIndexPath:(NSIndexPath *)indexPath;
- (void)playerFinalizado:(NSNotification *)notification;

@property (nonatomic, retain) IBOutlet PullToRefreshTableViewController *tableViewController;

@property (nonatomic, assign) BOOL omitirVerMas;

@property (nonatomic, retain) NSIndexPath *indexPathSeleccionado;

@end
