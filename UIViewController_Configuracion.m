//
//  UIViewController_Configuracion.m
//  teleSUR
//
//  Created by Hector Zarate on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController_Configuracion.h"


@implementation UIViewController (UIViewController_Configuracion)

-(void)personalizarNavigationBar
{
	[self setTitle:@"teleSUR"];
	[self.navigationController.navigationBar setTintColor:[UIColor redColor]];

}


@end
