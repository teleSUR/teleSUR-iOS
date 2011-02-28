//
//  TSMultimediaDataDelegate.h
//  teleSUR-iOS
//
//  Created by Hector Zarate on 2/25/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

@class TSMultimediaData;

@protocol TSMultimediaDataDelegate

- (void) TSMultimediaData:(TSMultimediaData *)data entidadesRecibidas: (NSArray *)array paraEntidad:(NSString *)entidad ;
- (void) TSMultimediaData:(TSMultimediaData *)data entidadesRecibidasConError: (id) error;

@end
