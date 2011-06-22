//
//  TwitterSobreMapa.h
//  teleSUR
//
//  Created by Hector Zarate Rea on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchronousImageView.h"

@interface TwitterSobreMapa : UIView {
    
    AsynchronousImageView *imagenTwitter;
    UILabel *labelNombreTwitter;
    UILabel *labelTwit;
    UILabel *labelFechaTwit;
    
    
}

@property (nonatomic, retain) IBOutlet AsynchronousImageView *imagenTwitter;
@property (nonatomic, retain) IBOutlet UILabel *labelNombreTwitter;
@property (nonatomic, retain) IBOutlet UILabel *labelTwit;

@property (nonatomic, retain) IBOutlet UILabel *labelFechaTwit;


@end
