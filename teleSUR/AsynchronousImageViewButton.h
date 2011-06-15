//
//  AsynchronousImageViewButton.h
//  teleSUR
//
//  Created by Hector Zarate on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousImageView.h"

@interface AsynchronousImageViewButton : AsynchronousImageView {
    
    id delegado;
    SEL selector;
    
}
@property (nonatomic, assign) SEL selector;

@property (nonatomic, retain) IBOutlet id delegado;

@end
