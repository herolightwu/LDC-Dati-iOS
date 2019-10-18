//
//  Globals.h
//  Fotobus
//
//  Created by Armands Lazdins on 28/07/15.
//  Copyright (c) 2015 Armands Lazdins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Globals : NSObject


#define LDCGreenColor [UIColor colorWithRed:170/255.f green:235/255.f blue:169/255.f alpha:1]
#define LDCGrayColor [UIColor colorWithRed:100/255.f green:109/255.f blue:158/255.f alpha:1]
#define LANGUAGE_CHANGE_NOTIFICATION @"LanguageChangeNotification"


+ (Globals *)sharedGlobals;

//API
-(NSDictionary *)defaultPostDataWithAnimalCode:(NSString *)code;

@end
