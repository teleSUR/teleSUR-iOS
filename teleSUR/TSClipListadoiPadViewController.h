//
//  TSClipListadoiPadViewController.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAlturaStrip 167
#define kNumeroStrips 5
#define kMargenStrips 10

@interface TSClipListadoiPadViewController : UIViewController {

    NSMutableArray *strips;
    
}

@property (nonatomic, retain) NSMutableArray *strips;

@end
