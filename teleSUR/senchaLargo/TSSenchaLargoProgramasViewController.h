//
//  TSSenchaLargoProgramasViewController.h
//  teleSUR
//
//  Created by David Regla on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMapaViewController.h"
#import "TSMultimediaDataDelegate.h"


@interface TSSenchaLargoProgramasViewController : TSMapaViewController <UIWebViewDelegate, TSMultimediaDataDelegate> {
    
    IBOutlet UIWebView *webView;
}

- (void)videoTerminado;

@property (nonatomic, retain) UIWebView *webView;

@end


