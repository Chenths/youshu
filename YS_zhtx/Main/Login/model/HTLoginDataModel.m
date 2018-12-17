//
//  HTLoginDataModel.m
//  
//
//  Created by 123 on 16/3/25.
//  Copyright (c) 2016 123. All rights reserved.
//

#import "HTLoginDataModel.h"

#import "HTLoginDataPersonModel.h"

@implementation HTLoginDataModel

@synthesize companyCode;
@synthesize companyId;
@synthesize isCAdmin;
@synthesize isSuper;
@synthesize loginId;
@synthesize person;
@synthesize roleId;

- (void)dealloc {

    

}


+ (HTLoginDataModel *)instanceFromDictionary:(NSDictionary *)aDictionary {

    HTLoginDataModel *instance = [[HTLoginDataModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"person"]) {

        if ([value isKindOfClass:[NSDictionary class]]) {
            self.person = [HTLoginDataPersonModel instanceFromDictionary:value];
        }

    } else {
        [super setValue:value forKey:key];
    }

}



@end
