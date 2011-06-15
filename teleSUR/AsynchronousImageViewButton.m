//
//  AsynchronousImageViewButton.m
//  teleSUR
//
//  Created by Hector Zarate on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageViewButton.h"


@implementation AsynchronousImageViewButton


@synthesize selector;
@synthesize delegado;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegado performSelector:self.selector];    
}



@end
