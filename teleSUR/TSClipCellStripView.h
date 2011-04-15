//
//  TSClipCellStripView.h
//  teleSUR
//
//  Created by Hector Zarate on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsynchronousImageView;

@interface TSClipCellStripView : UIView {

    UIImageView *imagen;
    UILabel *titulo;
    UILabel *tiempo;
    UILabel *firma;
}
@property (nonatomic, retain) IBOutlet UIImageView *imagen;

@property (nonatomic, retain) IBOutlet UILabel *titulo;
@property (nonatomic, retain) IBOutlet UILabel *tiempo;
@property (nonatomic, retain) IBOutlet UILabel *firma;

@end
