//
//  DataDescargable.h
//  Nitro
//
//  Created by Hector Hector Zarate / David Hernandez on 1/22/11.
//  Copyright 2011 MielDeMaple.com. All rights reserved.
//

#define DownloadErrorDomain      @"Error de Descarga"
enum 
{   DownloadErrorNoConnection = 1000,
};

@class DataDescargable;

@protocol DataDescargableDelegate
- (void)downloadDidFinishDownloading:(DataDescargable *)download;
- (void)download:(DataDescargable *)download didFailWithError:(NSError *)error;
@end


#import <UIKit/UIKit.h>


@interface DataDescargable : NSObject {

	NSString *urlString;     
	
	id <NSObject, DataDescargableDelegate>  delegate;
	
	@private  NSMutableData *receivedData;
	
	NSData *data;
	
	BOOL downloading;
	
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, readonly) NSString *filename;
@property (nonatomic, assign) id <NSObject, DataDescargableDelegate> delegate;
@property (nonatomic, retain) NSData *data;

- (id) initWithURL: (NSString *) aUrl andDelegate: (id) theDelegate;

@end
