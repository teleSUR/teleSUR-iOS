//
//  TSClipPlayerViewController.h
//  teleSUR
//
//  Created by David Regla on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TSClipPlayerViewController : MPMoviePlayerViewController {
    
    NSDictionary *clip;
    
}

// Init
- (id)initConClip:(NSDictionary *)diccionarioClip;

// Play
- (void)playEnViewController:(UIViewController *)viewController finalizarConSelector:(SEL)selector registrandoAccion:(BOOL)registrar;


@property (nonatomic, retain) NSDictionary *clip;

@end
