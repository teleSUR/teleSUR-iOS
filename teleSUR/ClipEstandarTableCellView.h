//
//  ClipEstandarTableCellView.h
//  teleSUR
//
//  Created by Hector Zarate on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynchronousImageView.h"


@interface ClipEstandarTableCellView : UITableViewCell {

	UILabel *titulo;
	UILabel *duracion;
    
    AsynchronousImageView *thumbnailView;
	
	UILabel *firma;
}


@property (nonatomic, retain) IBOutlet UILabel *titulo;
@property (nonatomic, retain) IBOutlet UILabel *duracion;
@property (nonatomic, retain) IBOutlet UILabel *firma;
@property (nonatomic, retain) IBOutlet AsynchronousImageView *thumbnailView;

@end
