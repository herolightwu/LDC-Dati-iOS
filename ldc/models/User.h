//
//  User.h
//  User
//
//  Created by weiquan zhang on 6/15/16.
//  Copyright © 2016 Odelan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *personId;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *certificate;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end
