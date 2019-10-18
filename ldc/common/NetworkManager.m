//
//  NetworkManager.m
//  novietnesGPS
//
//  Created by meixiang wu on 16/10/2017.
//  Copyright © 2017 meixiang wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "Config.h"

@implementation NetworkManager
@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;



+ (void)sendLoginRequest:(NSString *)username
                Password:(NSString *)password
                 success:(HttpSuccess)success
                 failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *soapMessage =
    [NSString stringWithFormat:
     @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"%@\">"
     "<soap:Header xmlns:wsa=\"http://www.w3.org/2005/08/addressing\">"
     "<wsa:Action>http://tempuri.org/IMobileService/Login</wsa:Action>"
     "</soap:Header>"
     "<soap:Body>"
     "<tem:Login>"
     "<tem:login>%@</tem:login>"
     "<tem:password>%@</tem:password>"
     "</tem:Login>"
     "</soap:Body>"
     "</soap:Envelope>", NAMESPACE_URL, username,password
     ];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMessage);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    //[req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"application/soap+xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *actStr = [NSString stringWithFormat:@"%@%@", NAMESPACE_URL, login_header];
    [req addValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [req addValue:actStr forHTTPHeaderField:@"action"];
    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [req setTimeoutInterval:10];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            //            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            failure(error);
        }
    }] resume];
}

+ (void)logoutRequest:(NSString *)sessionID
                   success:(HttpSuccess)success
                   failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *soapMessage =
    [NSString stringWithFormat:
     @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"%@\">"
     "<soap:Header xmlns:wsa=\"http://www.w3.org/2005/08/addressing\">"
     "<wsa:Action>http://tempuri.org/IMobileService/Logout</wsa:Action>"
     "</soap:Header>"
     "<soap:Body>"
     "<tem:Logout>"
     "<tem:sessionId>%@</tem:sessionId>"
     "</tem:Logout>"
     "</soap:Body>"
     "</soap:Envelope>", NAMESPACE_URL, sessionID
     ];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMessage);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *actStr = [NSString stringWithFormat:@"%@%@", NAMESPACE_URL, logout_header];
    [req addValue:actStr forHTTPHeaderField:@"action"];
    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            //            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            failure(error);
        }
    }] resume];
}

+ (void)getAnimalData:(NSString *)sessionID
             AnimalID:(NSString *)animalID
              success:(HttpSuccess)success
              failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *soapMessage =
    [NSString stringWithFormat:
     @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"%@\">"
     "<soap:Header xmlns:wsa=\"http://www.w3.org/2005/08/addressing\">"
     "<wsa:Action>http://tempuri.org/IMobileService/GetDzivniekaDati</wsa:Action>"
     "</soap:Header>"
     "<soap:Body>"
     "<tem:GetDzivniekaDati>"
     "<tem:sessionId>%@</tem:sessionId>"
     "<tem:identifikators>%@</tem:identifikators>"
     "</tem:GetDzivniekaDati>"
     "</soap:Body>"
     "</soap:Envelope>", NAMESPACE_URL, sessionID, animalID
     ];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMessage);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *actStr = [NSString stringWithFormat:@"%@%@", NAMESPACE_URL, getAnimal_header];
    [req addValue:actStr forHTTPHeaderField:@"action"];
    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            //            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            failure(error);
        }
    }] resume];
}

+ (void)getVaccines:(NSString *)sessionID
            success:(HttpSuccess)success
            failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *soapMessage =
    [NSString stringWithFormat:
     @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"%@\">"
     "<soap:Header xmlns:wsa=\"http://www.w3.org/2005/08/addressing\">"
     "<wsa:Action>http://tempuri.org/IMobileService/GetVakcinas</wsa:Action>"
     "</soap:Header>"
     "<soap:Body>"
     "<tem:GetVakcinas>"
     "<tem:sessionId>%@</tem:sessionId>"
     "</tem:GetVakcinas>"
     "</soap:Body>"
     "</soap:Envelope>", NAMESPACE_URL, sessionID
     ];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMessage);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    //[req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"application/soap+xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *actStr = [NSString stringWithFormat:@"%@%@", NAMESPACE_URL, getVaccines_header];
    [req addValue:actStr forHTTPHeaderField:@"action"];
    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            //            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            failure(error);
        }
    }] resume];
}

+ (void)getAddresses:(NSString *)sessionID
              preTxt:(NSString *)pretxt
             success:(HttpSuccess)success
             failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *soapMessage =
    [NSString stringWithFormat:
     @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"%@\">"
     "<soap:Header xmlns:wsa=\"http://www.w3.org/2005/08/addressing\">"
     "<wsa:Action>http://tempuri.org/IMobileService/MekletAdresi</wsa:Action>"
     "</soap:Header>"
     "<soap:Body>"
     "<tem:MekletAdresi>"
     "<tem:sessionId>%@</tem:sessionId>"
     "<tem:teksts>%@</tem:teksts>"
     "</tem:MekletAdresi>"
     "</soap:Body>"
     "</soap:Envelope>", NAMESPACE_URL, sessionID, pretxt
     ];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMessage);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    //[req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"application/soap+xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *actStr = [NSString stringWithFormat:@"%@%@", NAMESPACE_URL, getAddresses_header];
    [req addValue:actStr forHTTPHeaderField:@"action"];
    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            failure(error);
        }
    }] resume];
}

+(void)createEventRequest:(NSString *)sessionID
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
                  failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [sec setAllowInvalidCertificates:YES];
    [sec setValidatesDomainName:NO];
    manager.securityPolicy = sec;
    
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *eMsg = @"";
    if([eType isEqualToString:event_type_1]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDati>"
                "<muv:Lauks>beiguDatums</muv:Lauks>"
                "<muv:Vertiba>%@</muv:Vertiba>"
                "</muv:NotikumaDati>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>1</muv:NotikumaVeids>", comment, idAnimal, endDate, startDate];
    } else if([eType isEqualToString:event_type_9]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDati>"
                "<muv:Lauks>nakosaisDatums</muv:Lauks>"
                "<muv:Vertiba>%@</muv:Vertiba>"
                "</muv:NotikumaDati>"
                "<muv:NotikumaDati>"
                "<muv:Lauks>vakcinasId</muv:Lauks>"
                "<muv:Vertiba>%@</muv:Vertiba>"
                "</muv:NotikumaDati>"
                "<muv:NotikumaDati>"
                "<muv:Lauks>sertifikats</muv:Lauks>"
                "<muv:Vertiba>%@</muv:Vertiba>"
                "</muv:NotikumaDati>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>9</muv:NotikumaVeids>", comment, idAnimal, nextDate, vType, certId , startDate];
    } else if ([eType isEqualToString:event_type_10]){
        NSString *kept_str = @"false";
        if(bKept){
            kept_str = @"true";
            eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                    "<muv:Identifikators>%@</muv:Identifikators>"
                    "<muv:NotikumaDati>"
                    "<muv:Lauks>turetsArzemes</muv:Lauks>"
                    "<muv:Vertiba>%@</muv:Vertiba>"
                    "</muv:NotikumaDati>"
                    "<muv:NotikumaDati>"
                    "<muv:Lauks>valstsIsoKods</muv:Lauks>"
                    "<muv:Vertiba>%@</muv:Vertiba>"
                    "</muv:NotikumaDati>"
                    "<muv:NotikumaDati>"
                    "<muv:Lauks>adresesPrecizejums</muv:Lauks>"
                    "<muv:Vertiba>%@</muv:Vertiba>"
                    "</muv:NotikumaDati>"
                    "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                    "<muv:NotikumaVeids>10</muv:NotikumaVeids>", comment, idAnimal, kept_str, isocode, addrdetail, startDate];
        } else{
            eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                    "<muv:Identifikators>%@</muv:Identifikators>"
                    "<muv:NotikumaDati>"
                    "<muv:Lauks>turetsArzemes</muv:Lauks>"
                    "<muv:Vertiba>%@</muv:Vertiba>"
                    "</muv:NotikumaDati>"
                    "<muv:NotikumaDati>"
                    "<muv:Lauks>adresesKods</muv:Lauks>"
                    "<muv:Vertiba>%@</muv:Vertiba>"
                    "</muv:NotikumaDati>"
                    "<muv:NotikumaDati>"
                    "<muv:Lauks>adresesPrecizejums</muv:Lauks>"
                    "<muv:Vertiba>%@</muv:Vertiba>"
                    "</muv:NotikumaDati>"
                    "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                    "<muv:NotikumaVeids>10</muv:NotikumaVeids>", comment, idAnimal, kept_str, addrcode, addrdetail, startDate];
        }
        
    } else if ([eType isEqualToString:event_type_5]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>5</muv:NotikumaVeids>", comment, idAnimal, startDate];
    } else if ([eType isEqualToString:event_type_6]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>6</muv:NotikumaVeids>", comment, idAnimal, startDate];
    } else if ([eType isEqualToString:event_type_7]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>7</muv:NotikumaVeids>", comment, idAnimal, startDate];
    } else if ([eType isEqualToString:event_type_8]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>8</muv:NotikumaVeids>", comment, idAnimal, startDate];
    } else if ([eType isEqualToString:event_type_14]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>14</muv:NotikumaVeids>", comment, idAnimal, startDate];
    } else if ([eType isEqualToString:event_type_15]){
        eMsg = [NSString stringWithFormat:@"<muv:Detalas>%@</muv:Detalas>"
                "<muv:Identifikators>%@</muv:Identifikators>"
                "<muv:NotikumaDatums>%@</muv:NotikumaDatums>"
                "<muv:NotikumaVeids>15</muv:NotikumaVeids>", comment, idAnimal, startDate];
    } else{
        return;
    }
    
    NSString *soapMsg =
    [NSString stringWithFormat:
     @"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"%@\" xmlns:muv=\"http://schemas.datacontract.org/2004/07/Muvis.WebServices.MobileServiceActions\">"
     "<soap:Header xmlns:wsa=\"http://www.w3.org/2005/08/addressing\">"
     "<wsa:Action>http://tempuri.org/IMobileService/IzveidotNotikumu</wsa:Action>"
     "</soap:Header>"
     "<soap:Body>"
     "<tem:IzveidotNotikumu>"
     "<tem:sessionId>%@</tem:sessionId>"
     "<tem:notikums>%@</tem:notikums>"
     "</tem:IzveidotNotikumu>"
     "</soap:Body>"
     "</soap:Envelope>", NAMESPACE_URL, sessionID, eMsg
     ];
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMsg);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    // 根据上面的URL创建一个请求
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    //[req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"application/soap+xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *actStr = [NSString stringWithFormat:@"%@%@", NAMESPACE_URL, getVaccines_header];
    [req addValue:actStr forHTTPHeaderField:@"action"];
    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    //[req setTimeoutInterval:5];
    
    [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            success(responseObject);
        } else {
            //            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            failure(error);
        }
    }] resume];
}
@end
