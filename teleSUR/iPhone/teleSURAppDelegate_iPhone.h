//
//  teleSURAppDelegate_iPhone.h
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "teleSURAppDelegate.h"

@interface teleSURAppDelegate_iPhone : teleSURAppDelegate {
  

    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
