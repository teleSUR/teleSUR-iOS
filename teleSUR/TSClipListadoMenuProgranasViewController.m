//
//  TSProgramaListadoViewController.m
//  teleSUR
//
//  Created by David Regla on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSClipListadoMenuProgranasViewController.h"

#define kMENU_ALTURA 40

@implementation TSClipListadoMenuProgranasViewController


- (void)viewDidLoad
{
    self.entidadMenu = @"programa";
    [super viewDidLoad];
    
    /*
    CGRect frame;
    
    // Agrandar menú
    frame = self.menuScrollView.frame; 
    frame.size.height += kMENU_ALTURA_EXTRA;
    self.menuScrollView.frame = frame;
    
    // Achicar y recorrer tabla
    frame = self.clipsTableView.frame;
    frame.origin.y += kMENU_ALTURA_EXTRA;
    frame.size.height -= kMENU_ALTURA_EXTRA;
    self.clipsTableView.frame = frame;
    
    // Configuración de scrollview
    self.menuScrollView.pagingEnabled = YES;
	
    self.menuScrollView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    // No mostrar primer filtro "Todos"
     
     
    self.conFiltroTodos = NO;
     */
}

#pragma mark -
#pragma mark Internos

- (void)construirMenu 
{
    [super construirMenu];
    
    
    menuScrollView.pagingEnabled = YES;
    
    // Retirar todos los botones del menú, si es que hay
    for (int i=0; i<[self.menuScrollView.subviews count]; i++)
    {
        UIButton *boton = [self.menuScrollView.subviews objectAtIndex:i];
        
        CGRect frame = boton.frame;
        frame.size.width = 200.0;
        boton.frame = frame;
        
        
        NSString *url = [[self.filtros objectAtIndex:i] valueForKey:@"imagen_url"];
        
        if (![url isEqual:[NSNull null]])
            [boton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] forState:UIControlStateNormal];
        
        [boton setTitle:@"" forState:UIControlStateNormal];
        boton.titleLabel.text = @"";
        
    }
}
    

        
    // Deifnir área de scroll
    //[self.menuScrollView setContentSize: CGSizeMake(offsetX, self.menuScrollView.frame.size.height)];


- (NSString *)nombreNibParaIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.clips count])
        return @"ProgramaTableCellView";
    else
        return [super nombreNibParaIndexPath:indexPath];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
