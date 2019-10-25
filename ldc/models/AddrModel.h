//
//  AddrModel.h
//  ldc
//
//  Created by meixiang wu on 10/25/19.
//  Copyright © 2019 cube. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddrModel : NSObject
@property (nonatomic, strong) NSString *kods;
@property (nonatomic, strong) NSString *nosaukum;

- (id)initWithDictionary:(NSDictionary *)dicParams;
@end

NS_ASSUME_NONNULL_END
