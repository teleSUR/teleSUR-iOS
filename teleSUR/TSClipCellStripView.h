//
//  TSClipCellStripView.h
//  teleSUR
//
//  Created by Hector Zarate on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsynchronousImageView;

@interface TSClipCellStripView : UIView {

    char posicion;
    
    AsynchronousImageView *imagen;
    UILabel *titulo;
    UILabel *tiempo;
    UILabel *firma;
    UILabel *descripcion;
    
    UIViewController *controlador;
}

@property (nonatomic, retain) IBOutlet UILabel *descripcion;

@property (nonatomic, assign) char posicion;

@property (nonatomic, retain) UIViewController *controlador;

@property (nonatomic, retain) IBOutlet AsynchronousImageView *imagen;

@property (nonatomic, retain) IBOutlet UILabel *titulo;
@property (nonatomic, retain) IBOutlet UILabel *tiempo;
@property (nonatomic, retain) IBOutlet UILabel *firma;


@end
