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

#import "MediaPlayer/MediaPlayer.h"
#import "DataDescargable.h"

@class TSClipListadoViewController;
@class TSAnotacionEnMapa;
@class TwitterSobreMapa;


@interface TSMapaViewController : UIViewController <TSMultimediaDataDelegate, MKMapViewDelegate, DataDescargableDelegate> {
    
    UIView *contenedorTwitter;
    
    TwitterSobreMapa *vistaTwitter;    
    
    UIView *menu;
    
    NSMutableArray *anotacionesDelMapa;
    
    MKMapView *vistaMapa;
    TSClipListadoViewController *listado;    
    NSDictionary *noticiaSeleccionada;
    UISegmentedControl *controlSegmentadoTitulo;
    
    UINavigationBar *barraNavegacion;
    
    MPMoviePlayerController *vistaReproduccionVideoTiempoReal;    
}
@property (nonatomic, retain) IBOutlet UIView *contenedorTwitter;
@property (nonatomic, retain) IBOutlet TwitterSobreMapa *vistaTwitter;    

@property (nonatomic, retain) IBOutlet UINavigationBar *barraNavegacion;

@property (nonatomic, retain) UIView *menu;
@property (nonatomic, retain) IBOutlet UISegmentedControl *controlSegmentadoTitulo;
@property (nonatomic, retain) NSDictionary *noticiaSeleccionada;
@property (nonatomic, retain) NSMutableArray *anotacionesDelMapa;
@property (nonatomic, retain) TSClipListadoViewController *listado;
@property (nonatomic, retain) IBOutlet MKMapView *vistaMapa;

@property (nonatomic, retain) MPMoviePlayerController *vistaReproduccionVideoTiempoReal;


-(void) ocultarTwitter;

-(void) mostrarTwitterDelUsuario: (NSString *) nombreUsuarioTwitter;

-(void) reproducirVideoEnPantalla;

-(IBAction) recargarPines: (id) sender;

-(void) reproducirVideo: (TSAnotacionEnMapa *) anotacion;


@end
