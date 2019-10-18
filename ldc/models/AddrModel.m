//
//  AddrModel.m
//  ldc
//
//  Created by meixiang wu on 10/25/19.
//  Copyright © 2019 cube. All rights reserved.
//

#import "AddrModel.h"
#import "validator.h"

@implementation AddrModel
- (id)initWithDictionary:(NSDictionary *)dicParams
{
    AddrModel *item = [[AddrModel alloc] init];
    
    item.kods = validateObject(dicParams[@"b:Kods"][@"text"]);
    item.nosaukum = validateObject(dicParams[@"b:Nosaukums"][@"text"]);
    
    return item;
}
@end
