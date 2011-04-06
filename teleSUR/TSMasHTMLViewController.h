//
//  TSMasHTMLViewController.h
//  teleSUR
//
//  Created by David Regla on 3/30/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TSMasHTMLViewController : UIViewController {
    UIWebView *webView;
    NSString *nombreHTML;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;
@property(nonatomic, retain) NSString *nombreHTML;

@end
