//
//  XMLParser.m
//  RankingServiceTest
//
//  Created by Hector Hector Zarate / David Hernandez on 01/05/11.
//  Copyright 2010 MielDeMaple.com. All rights reserved.
//

#import "XMLParser.h"



@implementation XMLParser

@synthesize numeroTwits;

@synthesize analisisFecha;

@synthesize currentString, storingCharacters;

@synthesize ultimoTwit, fechaTwit;

@synthesize error;

@synthesize dentroDeItem;

- (id)init{
	
	if ((self = [super init])) {
		
		self.currentString = [[NSMutableString alloc] init];						
		self.dentroDeItem = 0;
        self.numeroTwits = 0;
	}
	
	return self;
	
	
}


#pragma mark Parsing dado el Path del XML
- (void)parseXMLFile:(NSString *)data {
	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[data dataUsingEncoding: NSUTF8StringEncoding]];
    
	[parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
	
	[parser parse];
	
	self.currentString = nil;

	[parser release];
}

#pragma mark NSXMLParser Parsing Callbacks

// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.

// Constantes a buscar durante el Parsing del archivo XML
static NSString *kName_date =               @"pubDate";
static NSString *kName_item =               @"item";
static NSString *kName_title =				@"title";



- (void)parserDidStartDocument:(NSXMLParser *)parser
{



}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
}

/*
 Sent by a parser object to its delegate when it encounters a start tag for a given element.
 Parameters
 parser: A parser object.
 elementName: A string that is the name of an element (in its start tag).
 namespaceURI: If namespace processing is turned on, contains the URI for the current namespace as a string object.
 qualifiedName: If namespace processing is turned on, contains the qualified name for the current namespace as a string object..
 attributeDict: A dictionary that contains any attributes associated with the element. Keys are the names of attributes, and values are attribute values.
 */

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict {
	
	// Obtenemos los proximos sorteos
	
	if ([elementName isEqualToString:kName_title] && self.dentroDeItem) {
		[currentString setString:@""];
        ++self.numeroTwits;
		storingCharacters = YES;
	}
	
	// Obtenemos las combinaciones que vamos a recomendar
	
	else if ([elementName isEqualToString:kName_item]) {
		
		self.dentroDeItem = YES;
        
		
	} 
    else if ([elementName isEqualToString:kName_date]) {
		[currentString setString:@""];		
		self.dentroDeItem = YES;
		storingCharacters = YES;
        self.analisisFecha = YES;
    }
	
}

/*
 Sent by a parser object to provide its delegate with a string representing all or part of the characters of the current element.
 Parameters
 parser: A parser object.
 string: A string representing the complete or partial textual content of the current element.
 */

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
	if (storingCharacters) {
        [currentString appendString:string];
    }
}


/*
 Sent by a parser object to its delegate when it encounters an end tag for a specific element.
 
 Parameters
 parser: A parser object.
 elementName: A string that is the name of an element (in its end tag).
 namespaceURI: If namespace processing is turned on, contains the URI for the current namespace as a string object.
 qName: If namespace processing is turned on, contains the qualified name for the current namespace as a string object.
 */

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
	
	
	if ([elementName isEqualToString:kName_title] && self.dentroDeItem)
    {
		self.ultimoTwit = self.currentString;

	}
	
	// Obtenemos las combinaciones que vamos a recomendar
	
	else if ([elementName isEqualToString:kName_item]) {
		
		self.dentroDeItem = NO;
		
	}
     
     
    else if ([elementName isEqualToString:kName_date] && self.dentroDeItem) {
		
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        [formater setLocale:locale];
        
        [formater setDateFormat:@"EEE, d MMM yyyy H:m:s Z"];
        
        NSLog(@"Fecha Twit: %@", self.currentString);
        
        
        self.fechaTwit = [formater dateFromString: self.currentString];
        
        [formater release];	
        
        
        
		self.dentroDeItem = NO;
    }
    
    
	storingCharacters = NO;
}



#pragma mark Parser Error Handling Method
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	NSString *errorParse=[NSString stringWithFormat:@"Error %i, Description: %@, Line: %i, Column: %i", 
					 [parseError code],
					 [[parser parserError] localizedDescription], 
					 [parser lineNumber],
					 [parser columnNumber]];
	
	self.error = YES;
	
	NSLog(@"%@",errorParse);
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
	

	[currentString release];	

	[super dealloc];
}


@end