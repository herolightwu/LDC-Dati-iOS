//
//  AppDelegate.h
//  ldc
//
//  Created by Nikita Work on 31/01/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserBarButtonItem.h"

@class AppDelegate;

extern User *g_user;
extern BOOL g_bLogin;
extern NSInteger g_homemode;
extern UserBarButtonItem *g_userBarButtonItem;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

