//
//  API.m
//
//  Created by Armands Lazdiņš
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "API.h"

static API *shared = nil;

//Keys
NSString *const kAPIBasicAuthUsernameKey = @"basicAuthUsernameKey";
NSString *const kAPIBasicAuthPasswordKey = @"basicAuthPasswordKey";

@interface API()

@property (nonatomic, readwrite) NSString *currentHost;
@property (nonatomic, readwrite) NSString *hostDomain;
@property (nonatomic) NSString *localHost;

@property (nonatomic, readwrite) NSDictionary *basicAuthDictionary;

@end

@implementation API

+(API *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark - Public

-(AFHTTPSessionManager *)networkManager
{
    //Create manager with default configs
    AFHTTPSessionManager *defaultManager = [self createDefaultManager];
    
    //Set BasicAuth
    if (self.basicAuthDictionary) {
        [defaultManager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.basicAuthDictionary[kAPIBasicAuthUsernameKey] password:self.basicAuthDictionary[kAPIBasicAuthPasswordKey]];
    }
    
    return defaultManager;
}

-(void)setBasicAuthHeaderWithUser:(NSString *)name password:(NSString *)password
{
    if (!name || !password) {
        [NSException raise:@"All BasicAuth values must be provided" format:@"user: %@ password: %@", name, password];
        return;
    }
    self.basicAuthDictionary = @{kAPIBasicAuthUsernameKey : name, kAPIBasicAuthPasswordKey : password};
}

-(void)clearBasicAuthHeader
{
    self.basicAuthDictionary = nil;
}

- (void)overrideRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer manager:(AFHTTPSessionManager *)manager
{
    if (!self.defaultRequestSerializer) {
        return;
    }
    
    for (NSString *key in self.defaultRequestSerializer.HTTPRequestHeaders.allKeys) {
        NSString *value = self.defaultRequestSerializer.HTTPRequestHeaders[key];
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager setRequestSerializer:requestSerializer];
}

-(NSString *)urlWithCurrentHost:(NSString *)relativeURL
{
    if (!relativeURL) {
        return nil;
    }
    
    NSString *firstChar = [relativeURL substringToIndex:1];
    BOOL appendSlash = ![firstChar isEqualToString:@"/"];
    
    NSString *fullRelativeURL;
    if (appendSlash) {
        fullRelativeURL = [NSString stringWithFormat:@"/%@", relativeURL];
    } else {
        fullRelativeURL = relativeURL;
    }
    return [NSString stringWithFormat:@"%@%@", self.currentHost, fullRelativeURL];
}

#pragma mark - Helpers

-(AFHTTPSessionManager *)createDefaultManager
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = self.maximumConnectionsPerHost;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    if (self.defaultRequestSerializer) {
        [manager setRequestSerializer:self.defaultRequestSerializer];
    }
    if (self.defaultResponseSerializer) {
        [manager setResponseSerializer:self.defaultResponseSerializer];
    }
    
    //Development
    if (self.enviroment == APIEnviromentDevelopment) {
        AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        manager.securityPolicy = policy;
    }
    
    return manager;
}

#pragma mark - Getters

-(NSString *)hostDomain
{
    if (!self.currentHost) {
        return nil;
    }
    
    if (!_hostDomain || ![self.localHost isEqualToString:self.currentHost]) {
        NSURL *currentHostURL = [NSURL URLWithString:self.currentHost];
        NSArray *hostComponents = [currentHostURL.host componentsSeparatedByString:@"."];
        
        if (hostComponents.count > 2) {
            NSInteger count = hostComponents.count;
            _hostDomain = [NSString stringWithFormat:@"%@.%@", hostComponents[count-2], hostComponents[count-1]];
        } else {
            _hostDomain = currentHostURL.host;
        }
        self.localHost = [self.currentHost copy];
    }
    
    return _hostDomain;
}

#pragma mark - Setters

-(void)setEnviroment:(APIEnviroment)enviroment
{
    _enviroment = enviroment;
    switch (enviroment) {
        case APIEnviromentDevelopment:
        {
            if (!self.developmentHost) {
                [NSException raise:@"No development host provided. Please update API defaults" format:@""];
            }
            self.currentHost = self.developmentHost;
            break;
        }
        case APIEnviromentProduction:
        {
            if (!self.productionHost) {
                [NSException raise:@"No production host provided. Please update API defaults" format:@""];
            }
            self.currentHost = self.productionHost;
            break;
        }
        default:
            break;
    }
}

-(void)setDevelopmentHost:(NSString *)developmentHost
{
    NSString *lastChar = [developmentHost substringFromIndex:developmentHost.length-1];
    
    NSString *normalizedHost;
    if ([lastChar isEqualToString:@"/"]) {
        normalizedHost = [developmentHost substringToIndex:developmentHost.length-1];
    } else {
        normalizedHost = developmentHost;
    }
    _developmentHost = normalizedHost;
}

-(void)setProductionHost:(NSString *)productionHost
{
    NSString *lastChar = [productionHost substringFromIndex:productionHost.length-1];
    
    NSString *normalizedHost;
    if ([lastChar isEqualToString:@"/"]) {
        normalizedHost = [productionHost substringToIndex:productionHost.length-1];
    } else {
        normalizedHost = productionHost;
    }
    _productionHost = productionHost;
}

#pragma mark - Lazy Load

-(NSInteger)maximumConnectionsPerHost
{
    if (!_maximumConnectionsPerHost) {
        _maximumConnectionsPerHost = [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost;
    }
    return _maximumConnectionsPerHost;
}

@end
