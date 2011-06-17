//
//  AsynchronousButtonView.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AsynchronousButtonView : UIButton {
    NSURL *url;
    NSURLConnection *connection;
    NSMutableData *data;
    
    BOOL imagenCargada;
    
}


- (void)cargarImagenSiNecesario;
- (void)loadImageFromURLString:(NSString *)theUrlString;


@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) BOOL imagenCargada;


@end
