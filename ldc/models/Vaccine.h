//
//  Vaccine.h
//  ldc
//
//  Created by meixiang wu on 10/20/19.
//  Copyright © 2019 cube. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Vaccine : NSObject

@property (nonatomic, strong) NSString *vId;
@property (nonatomic, strong) NSString *vName;

- (id)initWithDictionary:(NSDictionary *)dicParams;

@end

