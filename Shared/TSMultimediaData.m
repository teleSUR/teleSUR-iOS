//
//  TSMultimediaData.m
//  teleSUR-iOS
//
//  Created by David Regla on 2/12/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import "TSMultimediaData.h"


@implementation TSMultimediaData

@synthesize config;

- (NSArray *)getClips: (NSDictionary *)filtros {
	
	NSString *queryString = [NSString string];
	NSString *uri = [NSString stringWithString:@"/clip"];
	
	// cargar configuración al iniciar singleton
	self.config = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"teleSUR_iOS-Config.plist"]];
	
	
	if ([filtros objectForKey:@"tipo"])
		//uri = [uri stringByAppendingFormat:<#(NSString *)format#>
		
	    queryString = [queryString stringByAppendingFormat:@"desde=%@", @"2005-10-06"];
	
	
	if ([filtros objectForKey:@"desde"])
	    queryString = [queryString stringByAppendingFormat:@"desde=%@", @"2005-10-06"];
	if ([filtros objectForKey:@"hasta"])
		queryString = [queryString stringByAppendingFormat:@"hasta=%@", @"2005-10-06"];
	
	//NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.config objectForKey:@"Base API URL"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
	//connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSArray *)getSecciones: (NSDictionary *)filtros {
	
	// cargar configuración al iniciar singleton
	self.config = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"teleSUR_iOS-Config.plist"]];
	
	//NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.config objectForKey:@"Base API URL"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
	//connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)dealloc {
    [self.config release];	
}

@end
