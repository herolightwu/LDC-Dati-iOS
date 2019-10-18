//
//  API.h
//
//  Created by Armands Lazdiņš
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

typedef NS_ENUM(NSUInteger, APIEnviroment)
{
    APIEnviromentDevelopment = 1,
    APIEnviromentProduction
};

extern NSString *const kAPIBasicAuthUsernameKey;
extern NSString *const kAPIBasicAuthPasswordKey;

@interface API : NSObject

//Reads
@property (nonatomic, readonly) NSString *hostDomain;
@property (nonatomic, readonly) NSString *currentHost;
@property (nonatomic, readonly) NSDictionary *basicAuthDictionary;

/**
 Returns shared API manager. This class can hold default configurations which will be used for
 AFHTTPSessionManager returned by this class
 */
+ (API *)sharedManager;

#pragma mark - Properties

/**
 Set API mode. This must be done before any other action
 */
@property (nonatomic) APIEnviroment enviroment;

/**
 Set default request serializer. Will be used for all managers returned by this class
 */
@property (nonatomic) AFHTTPRequestSerializer *defaultRequestSerializer;

/**
 Set default response serializer. Will be used for all managers returned by this class
 */
@property (nonatomic) AFHTTPResponseSerializer *defaultResponseSerializer;

/**
 Set URL which will be used while API class is in production mode
 */
@property (nonatomic) NSString *productionHost;

/**
 Set URL which will be used while API class is in development mode
 */
@property (nonatomic) NSString *developmentHost;

/**
 Number of maximum connections per host
 */
@property (nonatomic) NSInteger maximumConnectionsPerHost;

#pragma mark - Methods

/**
 Creates a new AFHTTPSessionManager with API configurations
 */
- (AFHTTPSessionManager *)networkManager;

/**
 Sets BasicAuth header
 */
- (void)setBasicAuthHeaderWithUser:(NSString *)name password:(NSString *)password;

/**
 Clears BasicAuth header
 */
- (void)clearBasicAuthHeader;

/**
 Override requestSerializer for specific manager. This won't affect other managers and will keep defaults configs
 */
- (void)overrideRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer manager:(AFHTTPSessionManager *)manager;

/**
 Will preppend current enviroment host
 */
- (NSString *)urlWithCurrentHost:(NSString *)relativeURL;

@end
