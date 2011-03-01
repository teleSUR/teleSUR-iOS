//
//  AsyncImageView.h
//  teleSUR
//
//  Created by David Regla on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMultimediaDataDelegate.h"


@interface AsynchronousImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *data;
}

- (void)loadImageFromURLString:(NSString *)theUrlString;

@end