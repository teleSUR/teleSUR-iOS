//
//  TSAnotacionEnMapa.h
//  teleSUR
//
//  Created by Hector Zarate on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>

@interface TSAnotacionEnMapa : NSObject  <MKAnnotation> {
    NSDictionary *noticia;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSDictionary *noticia;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id) initWithDiccionarioNoticia: (NSDictionary *) unDiccionario;

@end
