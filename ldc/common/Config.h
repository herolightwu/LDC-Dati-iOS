//
//  Config.h
//  Foods
//
//  Created by Jin_Q on 3/17/16.
//  Copyright © 2016 Jin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SERVER_URL @"https://193.84.184.14:8443/muvis/WebServices/MobileService.svc" //@"https://muvis2.ldc.gov.lv/muvis/WebServices/MobileService.svc";
#define NAMESPACE_URL @"http://tempuri.org/"
#define login_header @"IMobileService/Login"
#define logout_header @"IMobileService/Logout"
#define getAnimal_header @"IMobileService/GetDzivniekaDati"
#define getVaccines_header @"IMobileService/GetVakcinas"
#define getAddresses_header @"IMobileService/MekletAdresi"


#define PRIMARY_TEXT_COLOR [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define T_HEADER_TEXT_COLOR [UIColor colorWithRed:(53.0/255.0) green:(56.0/255.0) blue:(65.0/255.0) alpha:1.0]
#define CONTROLL_EDGE_COLOR  [UIColor colorWithRed:(160.0/255.0) green:(160.0/255.0) blue:(160.0/255.0) alpha:1.0]

#define event_type_prompt @"Notikums"
#define event_type_1 @"Dzīvnieks ir bīstams"
#define event_type_5 @"Reģistrēta dzīvnieka nāve"
#define event_type_6 @"Reģistrēta dzīvnieka eitanāzija"
#define event_type_7 @"Dzīvnieks ir sterilizēts"
#define event_type_8 @"Dzīvnieks pazudis"
#define event_type_9 @"Dzīvnieks ir vakcinēts"
#define event_type_10 @"Mainīta turēšanas adrese"
#define event_type_14 @"Dzīvnieks atrasts"
#define event_type_15 @"Dzīvnieks atgūts"

//home mode
#define HOME_INIT 0
#define HOME_AAS 1
#define HOME_LOGIN 2

