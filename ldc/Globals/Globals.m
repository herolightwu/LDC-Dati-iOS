//
//  Globals.m
//  Fotobus
//
//  Created by Armands Lazdins on 28/07/15.
//  Copyright (c) 2015 Armands Lazdins. All rights reserved.
//

#import "Globals.h"
//#import "AppDelegate.h"
//Helpers
//#import "AppInfo.h"
//Frameworks
//#import <DTCoreText/DTCoreTextConstants.h>
//#import <DTCoreText/DTHTMLAttributedStringBuilder.h>
//#import <AFNetworking/AFNetworkReachabilityManager.h>

static Globals *sharedGlobals = nil;

@interface Globals()

@property (nonatomic, readwrite) NSDictionary *zoneColors;

@end

@implementation Globals

+ (Globals *)sharedGlobals
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobals = [[self alloc] init];
    });
    return sharedGlobals;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

#pragma mark - API

-(NSDictionary *)defaultPostDataWithAnimalCode:(NSString *)code
{
    NSMutableDictionary *postData = [NSMutableDictionary new];
	[postData setValue:@"pub_dziv" forKey:@"tips"];
	[postData setValue:@"dziv" forKey:@"c_param"];
	[postData setValue:@"lv" forKey:@"lang"];
	[postData setValue:@"CDGS2NLBzKg4yxJA" forKey:@"auth_code"];
	if (code) {
		[postData setValue:code forKey:@"dzid"];
	}

    return [postData copy];
}

@end
