//
//  TSLargoViewController.h
//  teleSUR
//
//  Created by David Regla on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TSMultimediaDataDelegate.h"

#import "MediaPlayer/MediaPlayer.h"
#import "DataDescargable.h"
#import "TSClipListadoMenuProgranasViewController.h"

@class TSClipListadoViewController;
@class TSAnotacionEnMapa;
@class TwitterSobreMapa;


@interface TSLargoViewController : UIViewController <TSMultimediaDataDelegate, MKMapViewDelegate, DataDescargableDelegate> {
    
    
    UISwitch *switchVideoEnVivo;
    
    
    UIView *contenedorTwitter;
    
    TwitterSobreMapa *vistaTwitter;    
    
    UIView *menu;
    
    NSMutableArray *anotacionesDelMapa;
    
    MKMapView *vistaMapa;
    TSClipListadoMenuProgranasViewController *listado;    
    NSDictionary *noticiaSeleccionada;
    UISegmentedControl *controlSegmentadoTitulo;
    
    UINavigationBar *barraNavegacion;
    
    MPMoviePlayerController *vistaReproduccionVideoTiempoReal;    
    
    UIView *vistaCargandoEnVivo;
    
}

@property (nonatomic, retain) IBOutlet UIView *vistaCargandoEnVivo;


@property (nonatomic, retain) MPMoviePlayerController *vistaReproduccionVideoTiempoReal;

@property (nonatomic, retain) IBOutlet UISwitch *switchVideoEnVivo;
@property (nonatomic, retain) IBOutlet UIView *contenedorTwitter;
@property (nonatomic, retain) IBOutlet TwitterSobreMapa *vistaTwitter;    

@property (nonatomic, retain) IBOutlet UINavigationBar *barraNavegacion;

@property (nonatomic, retain) UIView *menu;
@property (nonatomic, retain) IBOutlet UISegmentedControl *controlSegmentadoTitulo;
@property (nonatomic, retain) NSDictionary *noticiaSeleccionada;
@property (nonatomic, retain) NSMutableArray *anotacionesDelMapa;
@property (nonatomic, retain) TSClipListadoMenuProgranasViewController *listado;
@property (nonatomic, retain) IBOutlet MKMapView *vistaMapa;


-(IBAction) mostrarVideoTiempoReal: (id) sender;

-(void) ocultarTwitter;

-(void) mostrarTwitterDelUsuario: (NSString *) nombreUsuarioTwitter;

-(void) reproducirVideoEnPantalla;

-(IBAction) recargarPines: (id) sender;

-(void) reproducirVideo: (TSAnotacionEnMapa *) anotacion;


@end




