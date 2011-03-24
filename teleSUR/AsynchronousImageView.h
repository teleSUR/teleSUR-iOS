//
//  AsyncImageView.h
//  teleSUR
//
//  Created by David Regla on 3/1/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"


@interface AsynchronousImageView : UIImageView {
    
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