//
//  TSMultimediaDataDelegate.h
//  teleSUR-iOS
//
//  Created by Hector Zarate on 2/25/11.
//  Copyright 2011 teleSUR. All rights reserved.
//

@protocol TSMultimediaDataDelegate

- (void) entidadesRecibidasConExito: (NSArray *) array;
- (void) entidadesRecibidasConFalla: (id) error;

@end
