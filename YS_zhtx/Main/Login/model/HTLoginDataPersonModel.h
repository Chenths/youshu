//
//  HTLoginDataPersonModel.h
//  
//
//  Created by 123 on 16/3/25.
//  Copyright (c) 2016 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLoginDataPersonModel : NSObject {
    NSNumber *active;
    NSString *activeStr;
    NSString *address;
    id birthday;
    id company;
    NSString *companyCode;
    NSNumber *companyId;
    NSString *companyName;
    NSString *email;
    NSString *fax;
    NSArray *groups;
    NSNumber *hTLoginDataPersonModelId;
    NSString *idCard;
    NSNumber *level;
    NSString *loginError;
    NSString *loginName;
    BOOL loginSuccess;
    NSString *mobile;
    NSString *msn;
    NSString *name;
    NSNumber *orderNumber;
    NSString *password;
    NSString *qq;
    NSNumber *roleId;
    NSString *roleName;
    NSString *sex;
    NSString *sexStr;
    NSString *telephone;
    NSString *zipcode;
}

@property (nonatomic, copy) NSNumber *active;
@property (nonatomic, copy) NSString *activeStr;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, retain) id birthday;
@property (nonatomic, retain) id company;
@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSNumber *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *fax;
@property (nonatomic, copy) NSArray *groups;
@property (nonatomic, copy) NSNumber *hTLoginDataPersonModelId;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSNumber *level;
@property (nonatomic, copy) NSString *loginError;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, assign) BOOL loginSuccess;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *msn;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *orderNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSNumber *roleId;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *sexStr;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *unionId;
@property (nonatomic,copy) NSString *nickname;

+ (HTLoginDataPersonModel *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
