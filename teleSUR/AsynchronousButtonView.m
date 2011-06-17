//
//  AsynchronousButtonView.m
//  teleSUR
//
//  Created by Hector Zarate Rea on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousButtonView.h"


@implementation AsynchronousButtonView

@synthesize url, imagenCargada;

- (id) init
{
    if ((self = [super init]))
    {
        self.imageView.image = [UIImage imageNamed:@"SinImagen.png"];
    }
    
    return self;
}

- (void)cargarImagenSiNecesario
{
    if (self.url)
    {
        
        if (self.imageView.image == [UIImage imageNamed:@"SinImagen.png"] && data == nil)
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
    [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
	
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
