//
//  UIViewWrapUIScrollView.m
//  teleSUR
//
//  Created by Hector Zarate on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewWrapUIScrollView.h"


@implementation UIViewWrapUIScrollView

@synthesize scrollEnCuestion;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrollEnCuestion touchesBegan:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrollEnCuestion touchesCancelled:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrollEnCuestion touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrollEnCuestion touchesMoved:touches withEvent:event];
}
*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if ([self pointInside:point withEvent:event]){
    
        if (CGRectContainsPoint(self.scrollEnCuestion.frame, point)) {
            return nil;
        } else return self.scrollEnCuestion;
    }
    else return nil;

    

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
