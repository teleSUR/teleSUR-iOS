//
//  TSDescripcionNoticiaStrip.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSDescripcionNoticiaStrip : UIViewController {
    UILabel *titulo;
    UILabel *contenidoNoticia;
    
    
}

@property (nonatomic, retain) IBOutlet UILabel *titulo;
@property (nonatomic, retain) IBOutlet UILabel *contenidoNoticia;

-(float) ajustarTamanoTexto;

@end
