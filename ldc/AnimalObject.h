//
//  AnimalObject.h
//  ldc
//
//  Created by Nikita Work on 17/03/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <Realm/Realm.h>

@interface AnimalObject : RLMObject

@property (nonatomic) NSInteger uniqueID;
@property (nonatomic) NSString * animalType;
@property (nonatomic) NSString * gender;
@property (nonatomic) NSString * species;
@property (nonatomic) NSString * blood;
@property (nonatomic) NSString * bornDate;
@property (nonatomic) NSString * liquidationDate;
@property (nonatomic) NSString * fold;
@property (nonatomic) NSString * placement;
@property (nonatomic) NSString * liquidationReason;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * idString;
@property (nonatomic) BOOL isDangerAnimal;
@property (nonatomic) NSString * offensive;
@property (nonatomic) NSString * lost;
@property (nonatomic) NSString * lostDetails;
@property (nonatomic) NSString * furyTreatment;
@property (nonatomic) NSString * notPayed;
@property (nonatomic) NSString * adress;
@property (nonatomic) NSString * properties;

@property (nonatomic) NSArray *publicRows;

-(instancetype)initWithData:(NSDictionary *)data;

@end
