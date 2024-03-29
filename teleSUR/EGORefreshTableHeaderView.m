//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define kReleaseToReloadStatus	0
#define kPullToReloadStatus		1
#define kLoadingStatus			2

#define TEXT_COLOR [UIColor darkGrayColor]
#define BORDER_COLOR [UIColor grayColor]

@implementation EGORefreshTableHeaderView

@synthesize isFlipped, lastUpdatedDate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
	{
        // Color de fondo
		//self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Fondo2.png"]];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, 320.0f, 20.0f)];
		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		lastUpdatedLabel.opaque = YES;
		lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:lastUpdatedLabel];
		[lastUpdatedLabel release];
        
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, 320.0f, 20.0f)];
        
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.opaque = YES;
		statusLabel.textAlignment = UITextAlignmentCenter;
		[self setStatus:kPullToReloadStatus];
		[self addSubview:statusLabel];
		[statusLabel release];
        
		arrowImage = [[UIImageView alloc] initWithFrame:
                      CGRectMake(25.0f, frame.size.height
                                 - 65.0f, 30.0f, 55.0f)];
		arrowImage.contentMode = UIViewContentModeScaleAspectFit;
		arrowImage.image = [UIImage imageNamed:@"blueArrow.png"];
		[arrowImage layer].transform =
        CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
		[self addSubview:arrowImage];
		[arrowImage release];
        
		activityView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:
                        UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(25.0f, frame.size.height
                                        - 38.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		[activityView release];
        
		isFlipped = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context,  kCGPathFillStroke);
	[BORDER_COLOR setStroke];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
	CGContextAddLineToPoint(context, self.bounds.size.width,
                            self.bounds.size.height - 1);
	CGContextStrokePath(context);
}

- (void)flipImageAnimated:(BOOL)animated
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animated ? .18 : 0.0];
	[arrowImage layer].transform = isFlipped ?
    CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f) :
    CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
    
	isFlipped = !isFlipped;
}

- (void)setLastUpdatedDate:(NSDate *)newDate
{
	if (newDate)
	{
		if (lastUpdatedDate != newDate)
		{
			[lastUpdatedDate release];
		}
        
		lastUpdatedDate = [newDate retain];
        
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterShortStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		lastUpdatedLabel.text = [NSString stringWithFormat:
                                 @"%@ %@", NSLocalizedString(@"Actualizado en:", @"Actualizado en:"), [formatter stringFromDate:lastUpdatedDate]];
		[formatter release];
	}
	else
	{
		lastUpdatedDate = nil;
		lastUpdatedLabel.text = NSLocalizedString(@"Actualizado en: nunca", @"Actualizado en: nunca") ;
	}
}

- (void)setStatus:(int)status
{
	switch (status) {
		case kReleaseToReloadStatus:
			statusLabel.text = NSLocalizedString(@"Suelta para actualizar...", @"Suelta para actualizar...");
			break;
		case kPullToReloadStatus:
			statusLabel.text = NSLocalizedString(@"Jala para actualizar...", @"Jala para actualizar...");
			break;
		case kLoadingStatus:
			statusLabel.text = NSLocalizedString(@"Cargando...",@"Cargando...");
			break;
		default:
			break;
	}
}

- (void)toggleActivityView:(BOOL)isON
{
	if (!isON)
	{
		[activityView stopAnimating];
		arrowImage.hidden = NO;
	}
	else
	{
		[activityView startAnimating];
		arrowImage.hidden = YES;
		[self setStatus:kLoadingStatus];
	}
}

- (void)dealloc
{
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
    [super dealloc];
}

@end