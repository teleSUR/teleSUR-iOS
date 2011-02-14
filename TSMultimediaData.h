//
//  TSMultimediaData.h
//  teleSUR-iOS
//
//  Created by David Regla on 2/12/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TSMultimediaData : NSObject {
	NSDictionary *config;
}

@property (nonatomic, retain) NSDictionary *config;

- (NSArray *) getClips: (NSDictionary *)filtros;

@end

