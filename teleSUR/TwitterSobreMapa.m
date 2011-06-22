//
//  TwitterSobreMapa.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterSobreMapa.h"


@implementation TwitterSobreMapa

@synthesize labelTwit, labelNombreTwitter, imagenTwitter, labelFechaTwit;

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
