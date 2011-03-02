//
//  AsynchronousImageView.m
//  teleSUR
//
//  Created by David Regla on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousImageView.h"


@implementation AsynchronousImageView


- (void)loadImageFromURLString:(NSString *)theUrlString
{
	//[self.image release], self.image = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] 
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30.0];
    
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark NSURLConnection

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)theConnection 
	didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    self.image = [UIImage imageWithData:data];
	
    [data release], 
	data = nil;
	
	[connection release], 
	connection = nil;
}

- (void)dealloc
{
	[data release];
	[connection release];
    [super dealloc];
}

@end