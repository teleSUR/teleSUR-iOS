//
//  AsynchronousImageView.m
//  teleSUR
//
//  Created by David Regla on 3/1/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "AsynchronousImageView.h"


@implementation AsynchronousImageView

@synthesize url, imagenCargada;


- (void)cargarImagenSiNecesario
{
    if (self.url)
    {
        if (self.image == [UIImage imageNamed:@"SinImagen.png"] && data == nil)
        {
            [self loadImageFromURLString:[NSString stringWithFormat:@"%@", self.url]];
        }
        else
        {
            
        }
    }
    else
    {
        NSLog(@"Se intentó cargar imagen sin URL definida");
    }
}

- (void)loadImageFromURLString:(NSString *)theUrlString
{    
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:theUrlString] 
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30.0];
    
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void) reset
{
    self.image = [UIImage imageNamed:@"SinImagen.png"];
    data = nil;
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
	
    self.imagenCargada = YES;
    [data release], 
	data = nil;
	
	[connection release], 
	connection = nil;
}

- (void)dealloc
{
    url = nil;
	[data release];
	[connection release];
    
    [super dealloc];
}

@end