//
//  TSClipBusquedaViewController.h
//  teleSUR
//
//  Created by David Regla on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSClipBusquedaViewController : UITableViewController {
    NSMutableDictionary *selecciones;
}

@property (nonatomic,retain) NSMutableDictionary *selecciones;

- (void) botonBuscarPresionado:(UIBarButtonItem *)sender;
- (NSString *)nombreEntidadParaIndexPath:(NSIndexPath *)indexPath;

@end
