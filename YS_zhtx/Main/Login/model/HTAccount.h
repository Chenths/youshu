//
//  HTAccount.h
//  
//
//  Created by 123 on 16/3/30.
//  Copyright (c) 2016 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTAccount : NSObject {
    NSString *accountid;
    NSString *accounttype;
    NSNumber *balance;
    NSString *name;
}

@property (nonatomic, copy) NSString *accountid;
@property (nonatomic, copy) NSString *accounttype;
@property (nonatomic, copy) NSNumber *balance;
@property (nonatomic, copy) NSString *name;

+ (HTAccount *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
