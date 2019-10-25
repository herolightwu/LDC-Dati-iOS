//
//  NetworkManager.h
//  novietnesGPS
//
//  Created by meixiang wu on 16/10/2017.
//  Copyright © 2017 meixiang wu. All rights reserved.
//

#ifndef NetworkManager_h
#define NetworkManager_h

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


//宏定义成功block 回调成功后得到的信息
typedef void (^HttpSuccess)(id data);
//宏定义失败block 回调失败信息
typedef void (^HttpFailure)(NSError *error);

@interface NetworkManager : NSObject<NSXMLParserDelegate,  NSURLConnectionDelegate>
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;


+ (void)sendLoginRequest:(NSString *)username
                 Password:(NSString *)password
                success:(HttpSuccess)success
                 failure:(HttpFailure)failure;

+ (void)logoutRequest:(NSString *)sessionID
              success:(HttpSuccess)success
              failure:(HttpFailure)failure;

+ (void)getAnimalData:(NSString *)sessionID
             AnimalID:(NSString *)animalID
              success:(HttpSuccess)success
              failure:(HttpFailure)failure;

+ (void)getVaccines:(NSString *)sessionID
              success:(HttpSuccess)success
              failure:(HttpFailure)failure;
+ (void)getAddresses:(NSString *)sessionID
              preTxt:(NSString *)pretxt
             success:(HttpSuccess)success
             failure:(HttpFailure)failure;

+ (void)createEventRequest:(NSString *)sessionID
                  animalId:(NSString *)idAnimal
                 eventType:(NSString *)eType
                eventStart:(NSString *)startDate
                  eventEnd:(NSString *)endDate
                 eventNext:(NSString *)nextDate
               vaccineType:(NSString *)vType
                    certId:(NSString *)certId
                 keptBoard:(BOOL) bKept
                   isoCode:(NSString *)isocode
                  addrCode:(NSString *)addrcode
                addrDetail:(NSString *)addrdetail
                   comment:(NSString *)comment
                   success:(HttpSuccess)success
                   failure:(HttpFailure)failure;


@end

#endif /* NetworkManager_h */
