//
//  AppearanceProxy.m
//  NetCredit
//
//  Created by Armands Lazdiņš on 18/09/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "AppearanceProxy.h"

@implementation AppearanceProxy

+(void)loadDefaults
{
    [self navigationBarStyle];
    [self keyboardStyle];
}

#pragma mark - Appearances

+ (void)navigationBarStyle
{
	UIColor *barColor = LDCGreenColor;

    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:barColor]; //Bar background color
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; //Menu item color
	[[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]]; //Remove line under bar
	[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:LDCGrayColor];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithWhite:110/255.f alpha:1]}];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
}

+ (void)keyboardStyle
{
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceLight];
}


@end
