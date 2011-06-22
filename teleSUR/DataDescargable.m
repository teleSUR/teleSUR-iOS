//
//  DataDescargable.m
//  Nitro
//
//  Created by Hector Hector Zarate / David Hernandez on 1/22/11.
//  Copyright 2011 MielDeMaple.com. All rights reserved.
//




#import "DataDescargable.h"

@interface DataDescargable()
@property (nonatomic, retain) NSMutableData *receivedData;
@end




@implementation DataDescargable

@synthesize urlString;
@synthesize delegate;
@synthesize receivedData;
@synthesize data;

#pragma mark -

- (id) initWithURL: (NSString *) url andDelegate: (id) aDelegate {
	
	if ((self = [super init])) {
		[self setUrlString: url];
		[self setDelegate: aDelegate];
		 
	}
	
	return self;
	
	
}

- (NSData *)data
{
    if (data == nil && !downloading)
    {
        if (urlString != nil && [urlString length] > 0)
        {
            NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString] 
                                                      cachePolicy:NSURLCacheStorageNotAllowed 
                                                  timeoutInterval:15.0];
            NSURLConnection *con = [[NSURLConnection alloc]
                                    initWithRequest:req
                                    delegate:self
                                    startImmediately:NO];
            [con scheduleInRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
            [con start];
            
            
            
            if (con) 
            {
                NSMutableData *unData = [[NSMutableData alloc] init];
                self.receivedData=unData;
                [unData release];
            } 
            else 
            {
                NSError *error = [NSError errorWithDomain:DownloadErrorDomain 
                                                     code:DownloadErrorNoConnection 
                                                 userInfo:nil];
                if ([self.delegate respondsToSelector:@selector(download:didFailWithError:)])
                    [delegate download:self didFailWithError:error];
            }   
            [req release];

			
            downloading = YES;
        }
    }
	
    return data;
}
- (NSString *)filename
{
    return [urlString lastPathComponent];
}
- (void)dealloc 
{
    [urlString release];
    delegate = nil;
	[data release];
    [receivedData release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)esteData 
{
    [receivedData appendData:esteData];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error 
{
    [connection release];
    if ([delegate respondsToSelector:@selector(download:didFailWithError:)])
        [delegate download:self didFailWithError:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    self.data = [NSData dataWithData:receivedData];
    if ([delegate respondsToSelector:@selector(downloadDidFinishDownloading:)])
        [delegate downloadDidFinishDownloading:self];
    
    [connection release];
    self.receivedData = nil;
}
#pragma mark -
#pragma mark Comparison
- (NSComparisonResult)compare:(id)theOther
{
    DataDescargable *other = (DataDescargable *)theOther;
    return [self.filename compare:other.filename];
}



@end
