//
//  PullToRefreshTableViewController.h
//  ASiST
//
//  Created by Oliver on 09.12.09.
//  Copyright 2009 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SoundEffect.h"

@interface PullToRefreshTableViewController : UITableViewController 
{
	EGORefreshTableHeaderView *refreshHeaderView;
	
	BOOL checkForRefresh;
	BOOL reloading;
    BOOL refreshDisabled;
	
	SoundEffect *psst1Sound;
	SoundEffect *psst2Sound;
	SoundEffect *popSound;
}

- (void)dataSourceDidFinishLoadingNewData;
- (void)showReloadAnimationAnimated:(BOOL)animated;
- (void)setLastUpdate:(NSDate *)date;

@property (nonatomic, assign) BOOL refreshDisabled;

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

@end