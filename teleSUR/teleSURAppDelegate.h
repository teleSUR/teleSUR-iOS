//
//  teleSURAppDelegate.h
//  teleSUR
//
//  Created by David Regla on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface teleSURAppDelegate : NSObject <UIApplicationDelegate> {
    
    Reachability *internetReachable;
    Reachability *hostReachable;
    
    BOOL conexionLimitada;
    
}

// Conexi—n
- (void) checkNetworkStatus:(NSNotification *)notice;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) BOOL conexionLimitada;


@end
