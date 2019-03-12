//
//  HTCustModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustAccoutModel.h"
#import <Foundation/Foundation.h>

@interface HTCustModel : NSObject

@property (nonatomic,strong) NSString *nickname;
//店铺id
@property (nonatomic,strong) NSString *custId;
//平台id
@property (nonatomic, strong) NSString *customerid;

@property (nonatomic,strong) NSString *sex;

@property (nonatomic,strong) NSString *phone;

@property (nonatomic,strong) NSString *headImg;

@property (nonatomic,strong) NSString *birthday;

@property (nonatomic,strong) NSString *discount;

@property (nonatomic,strong) NSString *custlevel;

@property (nonatomic,strong) HTCustAccoutModel *account;

@property (nonatomic,strong) NSString *isfreestorevalueaccountactive;

@end
