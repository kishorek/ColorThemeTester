//
//  APIHelper.h
//  ColorThemeTester
//
//  Created by Kishore Kumar on 22/7/13.
//  Copyright (c) 2013 Kishore Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onSuccess) (NSArray *colors);

@interface APIHelper : NSObject

-(void) fetchKulerColourThemesOnSuccess:(onSuccess) success;
-(void) fetchCOLOURloversColourThemesOnSuccess:(onSuccess) success;

@end
