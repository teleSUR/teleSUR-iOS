//
//  TSMapaViewController.h
//  teleSUR
//
//  Created by Hector Zarate on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TSMultimediaDataDelegate.h"

@class TSClipListadoViewController;

@interface TSMapaViewController : UIViewController <TSMultimediaDataDelegate, MKMapViewDelegate> {
    
    NSMutableArray *anotacionesDelMapa;
    
    MKMapView *vistaMapa;
    TSClipListadoViewController *listado;    
    
}
@property (nonatomic, retain) NSMutableArray *anotacionesDelMapa;
@property (nonatomic, retain) TSClipListadoViewController *listado;
@property (nonatomic, retain) IBOutlet MKMapView *vistaMapa;

@end
