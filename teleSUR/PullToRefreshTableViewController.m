//
//  PullToRefreshTableViewController.m
//  ASiST
//
//  Created by Oliver on 09.12.09.
//  Copyright 2009 Drobnik.com. All rights reserved.
//

#import "PullToRefreshTableViewController.h"

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@implementation PullToRefreshTableViewController

@synthesize refreshDisabled, refreshHeaderView;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (!refreshDisabled)
    {
        self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, 320.0f, self.view.bounds.size.height)] autorelease];
        [self.tableView addSubview:refreshHeaderView];
        self.tableView.showsVerticalScrollIndicator = YES;
        
        // pre-load sounds
        psst1Sound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"psst1" ofType:@"wav"]];
        psst2Sound  = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"psst2" ofType:@"wav"]];
        popSound  = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]];
    }
	
}

- (void)dealloc 
{
	[psst1Sound release];
	[psst2Sound release];
	[popSound release];
	self.refreshHeaderView = nil;
    [super dealloc];
}

#pragma mark State Changes

- (void)showReloadAnimationAnimated:(BOOL)animated
{
	reloading = YES;
	[refreshHeaderView toggleActivityView:YES];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
	else
	{
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
	}
}

- (void)reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource");
}

- (void)dataSourceDidFinishLoadingNewData
{
    if (!refreshDisabled)
    {
        reloading = NO;
        [refreshHeaderView flipImageAnimated:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [refreshHeaderView setStatus:kPullToReloadStatus];
        [refreshHeaderView toggleActivityView:NO];
        [UIView commitAnimations];
        [popSound play];
    }
}

- (void)setLastUpdate:(NSDate *)date {
    [refreshHeaderView setLastUpdatedDate:date];
}


#pragma mark Scrolling Overrides

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (!reloading && !refreshDisabled)
	{
		checkForRefresh = YES;  //  only check offset when dragging 
	}
} 


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (reloading || refreshDisabled) return;
	
	if (checkForRefresh) {
		if (refreshHeaderView.isFlipped && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !reloading) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kPullToReloadStatus];
			[popSound play];
            
		} else if (!refreshHeaderView.isFlipped && scrollView.contentOffset.y < -65.0f) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kReleaseToReloadStatus];
			[psst1Sound play];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (reloading || refreshDisabled) return;
	
	if (scrollView.contentOffset.y <= - 65.0f) {
		if([self.tableView.dataSource respondsToSelector:@selector(reloadTableViewDataSource)]){
			[self showReloadAnimationAnimated:YES];
			[psst2Sound play];
            if ([self.tableView.dataSource respondsToSelector:@selector(reloadTableViewDataSource)])
                [self.tableView.dataSource performSelector:@selector(reloadTableViewDataSource)];
		}
	} 
	checkForRefresh = NO;
}


@end
