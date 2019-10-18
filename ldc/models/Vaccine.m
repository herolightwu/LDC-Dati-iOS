//
//  Vaccine.m
//  ldc
//
//  Created by meixiang wu on 10/20/19.
//  Copyright © 2019 cube. All rights reserved.
//

#import "Vaccine.h"
#import "validator.h"

@implementation Vaccine

- (id)initWithDictionary:(NSDictionary *)dicParams
{
    Vaccine *item = [[Vaccine alloc] init];
    
    item.vId = validateObject(dicParams[@"b:Id"][@"text"]);
    item.vName = validateObject(dicParams[@"b:Nosaukums"][@"text"]);
    
    return item;
}

@end
