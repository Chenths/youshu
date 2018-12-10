//
//  HTLoginDataPersonModel.m
//  
//
//  Created by 123 on 16/3/25.
//  Copyright (c) 2016 123. All rights reserved.
//

#import "HTLoginDataPersonModel.h"

@implementation HTLoginDataPersonModel

@synthesize active;
@synthesize activeStr;
@synthesize address;
@synthesize birthday;
@synthesize company;
@synthesize companyCode;
@synthesize companyId;
@synthesize companyName;
@synthesize email;
@synthesize fax;
@synthesize groups;
@synthesize hTLoginDataPersonModelId;
@synthesize idCard;
@synthesize level;
@synthesize loginError;
@synthesize loginName;
@synthesize loginSuccess;
@synthesize mobile;
@synthesize msn;
@synthesize name;
@synthesize orderNumber;
@synthesize password;
@synthesize qq;
@synthesize roleId;
@synthesize roleName;
@synthesize sex;
@synthesize sexStr;
@synthesize telephone;
@synthesize zipcode;



+ (HTLoginDataPersonModel *)instanceFromDictionary:(NSDictionary *)aDictionary {

    HTLoginDataPersonModel *instance = [[HTLoginDataPersonModel alloc] init] ;
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"groups"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                [myMembers addObject:valueMember];
            }

            self.groups = myMembers;

        }

    } else {
        [super setValue:value forKey:key];
    }

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"hTLoginDataPersonModelId"];
    } else {
    }

}


@end
