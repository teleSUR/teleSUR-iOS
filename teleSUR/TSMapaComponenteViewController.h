//
//  TSMapaComponenteViewController.h
//  teleSUR
//
//  Created by David Regla on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMapaViewController.h"

@interface TSMapaComponenteViewController : TSMapaViewController <UIWebViewDelegate, TSMultimediaDataDelegate> {
    
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
