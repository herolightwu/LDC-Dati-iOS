//
//  AnimalObj.m
//  ldc
//
//  Created by Nikita Work on 17/03/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "AnimalObj.h"
#import "validator.h"

@implementation AnimalObj


- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
	if (self) {
        NSLog(@"data %@", data);
        NSDictionary* text = [data objectForKey:@"b:Suga"];
		self.animalType = validateObject(text[@"text"]);
        NSDictionary* idDic = [data objectForKey:@"b:Identifikatori"];
        NSObject* dzObj = [idDic objectForKey:@"b:DzivniekaIdentifikators"];
        if([dzObj isKindOfClass:[NSArray class]]){
            NSArray* dzArray = (NSArray*)dzObj;
            NSDictionary* aprakstsDic = [dzArray[0] objectForKey:@"b:Apraksts"];
            self.idString = validateObject(aprakstsDic[@"text"]);
        } else{
            NSDictionary* dzDic = (NSDictionary*)dzObj;
            NSDictionary* aprakstsDic = [dzDic objectForKey:@"b:Apraksts"];
            self.idString = validateObject(aprakstsDic[@"text"]);
        }
        
        text = [data objectForKey:@"b:Vards"];
        self.name = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Dzimums"];
		self.gender = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Skirne"];
		self.species = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Asiniba"];
		self.blood = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:DzimsanasDatums"];
		self.bornDate = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:IzslegsanasDatums"];
		self.liquidationDate = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:IzslegsanasIemesls"];
        self.liquidationReason = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Ganampulks"];
		self.fold = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Novietne"];
		self.placement = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Pote"];
		self.pote = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Aizliegumi"];
		self.aizliegumi = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:MajasDzivnieks"];
		self.majasDzivnieks = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Status"];
		self.status = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:TuresanasAdrese"];
		self.adress = validateObject(text[@"text"]);
        text = [data objectForKey:@"b:Vakcinacijas"];
        self.vakcinacijas = validateObject(text[@"text"]);
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
		}
		if (self.pote) {
			[mutableArray addObject:@{@"title": @"Pote", @"value": self.pote}];
		}
		if (self.aizliegumi) {
			[mutableArray addObject:@{@"title": @"Aizliegumi", @"value": self.aizliegumi}];
		}
		if (self.majasDzivnieks) {
			[mutableArray addObject:@{@"title": @"MajasDzivnieks", @"value": self.majasDzivnieks}];
		}
		if (self.status) {
			[mutableArray addObject:@{@"title": @"Status", @"value": self.status}];
		}
		if (self.adress) {
			[mutableArray addObject:@{@"title": @"TuresanasAdrese", @"value": self.adress}];
		}
		if (self.vakcinacijas) {
			[mutableArray addObject:@{@"title": @"Vakcinacijas", @"value": self.vakcinacijas}];
		}
		_publicRows = [mutableArray copy];
	}

	return _publicRows;
}

+ (NSArray<NSString *> *)ignoredProperties
{
	return @[@"publicRows"];
}

/*
 [0]    (null)    @"b:Pote" : 1 key/value pair
 [1]-    (null)    @"b:IzslegsanasDatums" : 1 key/value pair
 [2]    (null)    @"b:Aizliegumi" : 0 key/value pairs
 [3]-    (null)    @"b:DzimsanasDatums" : 1 key/value pair
 [4]    (null)    @"b:MajasDzivnieks" : 1 key/value pair
 [5]-    (null)    @"b:Novietne" : 1 key/value pair
 [6]    (null)    @"xmlns:b" : @"http://schemas.datacontract.org/2004/07/Muvis.WebServices.MobileServiceActions"
 [7]-    (null)    @"b:Asiniba" : 1 key/value pair
 [8]    (null)    @"b:Status" : 1 key/value pair
 [9]-    (null)    @"b:Skirne" : 1 key/value pair
 [10-]    (null)    @"b:Vards" : 1 key/value pair
 [11]    (null)    @"xmlns:i" : @"http://www.w3.org/2001/XMLSchema-instance"
 [12]-    (null)    @"b:Suga" : 1 key/value pair
 [13]-    (null)    @"b:Ganampulks" : 1 key/value pair
 [14]    (null)    @"b:IzslegsanasIemesls" : 1 key/value pair
 [15]    (null)    @"b:TuresanasAdrese" : 1 key/value pair
 [16]    (null)    @"b:Vakcinacijas" : 1 key/value pair
 [17]    (null)    @"b:Identifikatori" : 1 key/value pair
 [18]    (null)    @"b:Dzimums" : 1 key/value pair
 */
@end
