//
//  HTAccount.m
//  
//
//  Created by 123 on 16/3/30.
//  Copyright (c) 2016 123. All rights reserved.
//

#import "HTAccount.h"

@implementation HTAccount

@synthesize accountid;
@synthesize accounttype;
@synthesize balance;
@synthesize name;


+ (HTAccount *)instanceFromDictionary:(NSDictionary *)aDictionary {

    HTAccount *instance = [[HTAccount alloc] init] ;
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
@end
