//
//  AnimalObject.h
//  ldc
//
//  Created by Nikita Work on 17/03/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <Realm/Realm.h>

@interface AnimalObj : RLMObject

@property (nonatomic) NSInteger uniqueID;
@property (nonatomic) NSString * animalType;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * idString;
@property (nonatomic) NSString * gender;
@property (nonatomic) NSString * species;
@property (nonatomic) NSString * blood;
@property (nonatomic) NSString * bornDate;
@property (nonatomic) NSString * liquidationDate;
@property (nonatomic) NSString * liquidationReason;
@property (nonatomic) NSString * fold;
@property (nonatomic) NSString * placement;

@property (nonatomic) BOOL isDangerAnimal;
@property (nonatomic) NSString * pote;
@property (nonatomic) NSString * aizliegumi;
@property (nonatomic) NSString * majasDzivnieks;
@property (nonatomic) NSString * status;
@property (nonatomic) NSString * adress;
@property (nonatomic) NSString * vakcinacijas;

@property (nonatomic) NSArray *publicRows;

-(instancetype)initWithData:(NSDictionary *)data;

@end
