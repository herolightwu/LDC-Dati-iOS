//
//  AnimalObject.m
//  ldc
//
//  Created by Nikita Work on 17/03/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "AnimalObject.h"
#import "validator.h"

@implementation AnimalObject


- (instancetype)initWithData:(NSDictionary *)data
{


	self = [super init];
	if (self) {

		NSLog(@"data %@", data);
		self.animalType = validateObject(data[@"suga"]);
		self.gender = validateObject(data[@"dzimums"]);
		self.species = validateObject(data[@"skirne"]);
		self.blood = validateObject(data[@"asiniba"]);
		self.bornDate = validateObject(data[@"dzimdat"]);
		self.liquidationDate = validateObject(data[@"likvdat"]);
		self.fold = validateObject(data[@"ganampulks"]);
		self.placement = validateObject(data[@"novietne"]);
		self.liquidationReason = validateObject(data[@"likviemesls"]);
		self.name = validateObject(data[@"vards"]);
		self.lost = validateObject(data[@"pazudis"]);
		self.lostDetails = validateObject(data[@"pazudisdetalas"]);
		self.furyTreatment = validateObject(data[@"trakumspote"]);
		self.notPayed = validateObject(data[@"neapmaksats"]);
		self.adress = validateObject(data[@"adrese"]);
		self.properties = validateObject(data[@"ipasaspazimes"]);

		if (validateObject(data[@"numurs"])) {
			NSArray *idsArray = data[@"numurs"];
			NSString *valueString = @"";
			for (int i = 0; i < idsArray.count; i++) {
				NSDictionary *idDict = idsArray[i];

				if (i == idsArray.count - 1) {
					valueString = [valueString stringByAppendingString:idDict[@"ID"]];
				} else {
					valueString = [valueString stringByAppendingString:[NSString stringWithFormat:@"%@ \n\n", idDict[@"ID"]]];
				}

			}
			self.idString = valueString;
		}


		self.offensive = validateObject(data[@"apmacitsuzbrukt"]);

		if (self.offensive) {
			self.isDangerAnimal = YES;
		}
	}

	return self;
}

-(NSArray *)publicRows
{

	if (!_publicRows) {
		NSMutableArray *mutableArray = [[NSMutableArray alloc]init];

		if (self.animalType) {
			[mutableArray addObject:@{@"title": @"Suga", @"value": self.animalType}];
		}
		if (self.idString) {
			[mutableArray addObject:@{@"title": @"Identifikators(i)", @"value": self.idString}];
		}
		if (self.name) {
			[mutableArray addObject:@{@"title": @"Vārds", @"value": self.name}];
		}
		if (self.gender) {
			[mutableArray addObject:@{@"title": @"Dzimums", @"value": self.gender}];
		}
		if (self.species) {
			[mutableArray addObject:@{@"title": @"Šķirne", @"value": self.species}];
		}
		if (self.blood) {
			[mutableArray addObject:@{@"title": @"Asinība", @"value": self.blood}];
		}
		if (self.bornDate) {
			[mutableArray addObject:@{@"title": @"Dzimš. datums", @"value": self.bornDate}];
		}
		if (self.liquidationDate) {
			[mutableArray addObject:@{@"title": @"Izslēgš. datums", @"value": self.liquidationDate}];
		}
		if (self.liquidationReason) {
			[mutableArray addObject:@{@"title": @"Izslēgš. iemesls", @"value": self.liquidationReason}];
		}
		if (self.fold) {
			[mutableArray addObject:@{@"title": @"Ganāmpulks", @"value": self.fold}];
		}
		if (self.placement) {
			[mutableArray addObject:@{@"title": @"Novietne", @"value": self.placement}];
			//	} else if ([key isEqualToString:@""]) {
			//		[mutableArray addObject:@{@"title": @"Bīstams", @"value": self.animalType}];
		}
		if (self.offensive) {
		}
		if (self.lost) {
			[mutableArray addObject:@{@"title": @"Pazudis", @"value": self.lost}];
		}
		if (self.lostDetails) {
			[mutableArray addObject:@{@"title": @"Pazušanas info", @"value": self.lostDetails}];
		}
		if (self.furyTreatment) {
			[mutableArray addObject:@{@"title": @"Vakcīna pret trakumsērgu", @"value": self.furyTreatment}];
		}
		if (self.notPayed) {
			[mutableArray addObject:@{@"title": @"Neapmaksāts", @"value": self.notPayed}];
		}
		if (self.adress) {
			[mutableArray addObject:@{@"title": @"Pašvaldība", @"value": self.adress}];
		}
		if (self.properties) {
			[mutableArray addObject:@{@"title": @"Īpašas pazīmes", @"value": self.properties}];
		}
		_publicRows = [mutableArray copy];
	}

	return _publicRows;
}

+ (NSArray<NSString *> *)ignoredProperties
{
	return @[@"publicRows"];
}

//if ([key isEqualToString:@"error"]) {
//	return @"Kļūda";
//} else if ([key isEqualToString:@"suga"]) {
//	return @"Suga";
//} else if ([key isEqualToString:@"dzimums"]) {
//	return @"Dzimums";
//} else if ([key isEqualToString:@"skirne"]) {
//	return @"Šķirne";
//} else if ([key isEqualToString:@"asiniba"]) {
//	return @"Asinība";
//} else if ([key isEqualToString:@"dzimdat"]) {
//	return @"Dzimš. datums";
//} else if ([key isEqualToString:@"likvdat"]) {
//	return @"Izslēgš. datums";
//} else if ([key isEqualToString:@"ganampulks"]) {
//	return @"Ganāmpulks";
//} else if ([key isEqualToString:@"novietne"]) {
//	return @"Novietne";

//} else if ([key isEqualToString:@"likviemesls"]) {
//	return @"Izslēgš. iemesls";
//} else if ([key isEqualToString:@"vards"]) {
//	return @"Vārds";
//} else if ([key isEqualToString:@"numurs"]) {
//	return @"Identifikators(i)";
//} else if ([key isEqualToString:@"bistams"]) {
//	return @"Bīstams";
//} else if ([key isEqualToString:@"apmacitsuzbrukt"]) {
//	return @"Apmācīts uzbrukt";
//} else if ([key isEqualToString:@"apmaciba"]) {
//	return @"Apmācība";
//} else if ([key isEqualToString:@"pazudis"]) {
//	return @"Pazudis";
//} else if ([key isEqualToString:@"pazudisdetalas"]) {
//	return @"Pazušanas info";
//} else if ([key isEqualToString:@"trakumspote"]) {
//	return @"Vakcīna pret trakumsērgu";
//} else if ([key isEqualToString:@"neapmaksats"]) {
//	return @"Neapmaksāts";
//} else if ([key isEqualToString:@"adrese"]) {
//	return @"Pašvaldība";
//} else if ([key isEqualToString:@"ipasaspazimes"]) {
//	return @"Īpašas pazīmes";
//} else {
//	return @"";
//}
@end
