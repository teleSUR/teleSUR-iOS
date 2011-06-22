//
//  XMLParser.h
//  RankingServiceTest
//
//  Created by Hector Hector Zarate / David Hernandez on 01/05/11.
//  Copyright 2010 MielDeMaple.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sorteo;
@class Combinacion;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
	
    BOOL analisisFecha;
    
    BOOL dentroDeItem;
    
	BOOL error;
	
    int numeroTwits;
    
	NSMutableString *currentString;
    BOOL storingCharacters;
	int tipoDeSorteo;
	NSMutableSet *sorteos;
	
    NSString *ultimoTwit;
    NSDate *fechaTwit;
    
	int index;
}
@property (nonatomic, assign) BOOL analisisFecha;

@property (nonatomic, assign) int numeroTwits;

@property (nonatomic, assign) BOOL dentroDeItem;
@property (nonatomic, assign) BOOL error;

@property (nonatomic, copy) NSString *ultimoTwit;
@property (nonatomic, retain) NSDate *fechaTwit;


@property (nonatomic, retain) NSMutableString *currentString;
@property (nonatomic, assign)  BOOL storingCharacters;

- (void)parseXMLFile:(NSString *)pathToFile;
- (void)print;
- (void)printNumeros;
- (void)printProximos;

@end


