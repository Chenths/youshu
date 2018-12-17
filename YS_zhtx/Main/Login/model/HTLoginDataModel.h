//
//  HTLoginDataModel.h
//  
//
//  Created by 123 on 16/3/25.
//  Copyright (c) 2016 123. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLoginDataPersonModel;

@interface HTLoginDataModel : NSObject {
    id companyCode;
    NSNumber *companyId;
    BOOL isCAdmin;
    BOOL isSuper;
    NSNumber *loginId;
    HTLoginDataPersonModel *person;
    NSNumber *roleId;
}

@property (nonatomic, retain) id companyCode;
@property (nonatomic, copy) NSNumber *companyId;
@property (nonatomic, assign) BOOL isCAdmin;
@property (nonatomic, assign) BOOL isSuper;
@property (nonatomic, copy) NSNumber *loginId;
@property (nonatomic, retain) HTLoginDataPersonModel *person;
@property (nonatomic, strong) NSDictionary *company;
@property (nonatomic, strong) NSArray *printers;
@property (nonatomic, copy) NSNumber *roleId;
@property (nonatomic,copy) NSString *regId;

+ (HTLoginDataModel *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
