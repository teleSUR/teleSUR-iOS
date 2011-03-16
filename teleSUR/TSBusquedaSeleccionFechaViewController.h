//
//  TSBusquedaSeleccionFechaViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSClipBusquedaViewController;

@interface TSBusquedaSeleccionFechaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate> {
    
    TSClipBusquedaViewController *controladorBusqueda;
    
    UIDatePicker *pickerFecha;
    UITableView *tableView;
    
    NSDate *fechaDesde;
    NSDate *fechaHasta;
    
    BOOL seleccionTodos;
    unsigned char seleccion;
    
}
@property (nonatomic, assign) TSClipBusquedaViewController *controladorBusqueda;

@property (nonatomic, retain) IBOutlet UIDatePicker *pickerFecha;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSDate *fechaDesde;
@property (nonatomic, retain) NSDate *fechaHasta;

@property (nonatomic, assign) BOOL seleccionTodos;
@property (nonatomic, assign)unsigned char seleccion;

- (IBAction) cambioFechaDePickerView: (UIDatePicker *)picker;

@end
