//
//  User.m
//  User
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import "User.h"
#import "validator.h"

@implementation User
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    User *item = [[User alloc] init];
    
    item.sessionId = validateObject(dicParams[@"sessionId"]);
    item.userId = validateObject(dicParams[@"userId"]);
    item.personId = validateObject(dicParams[@"personId"]);
    item.personName = validateObject(dicParams[@"personName"]);
    item.userRole = validateObject(dicParams[@"userRole"]);
    item.certificate = validateObject(dicParams[@"sertifikats"]);
    
    return item;
}

@end
