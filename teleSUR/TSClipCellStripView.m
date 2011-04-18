//
//  TSClipCellStripView.m
//  teleSUR
//
//  Created by Hector Zarate on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipCellStripView.h"
#import "AsynchronousImageView.h"
#import "TSClipDetallesViewController.h"

@implementation TSClipCellStripView

@synthesize  imagen, titulo, firma, tiempo;

@synthesize controlador;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (void)dealloc
{
    [super dealloc];
}

@end
