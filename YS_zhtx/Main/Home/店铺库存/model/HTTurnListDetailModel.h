//
//  HTTurnListDetailModel.h
//  YS_zhtx
//
//  Created by mac on 2018/9/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTTurnListDetailProductModel.h"
#import <Foundation/Foundation.h>

@interface HTTurnListDetailModel : NSObject

@property (nonatomic,strong) NSString *handleType;
@property (nonatomic,strong) NSString *noticeType;
@property (nonatomic,strong) NSString *remarks;
@property (nonatomic,strong) NSString *signStatus;
@property (nonatomic,strong) NSString *signUserName;
@property (nonatomic,strong) NSString *swapCompanyName;

@property (nonatomic,strong) NSString *swapDate;
@property (nonatomic,strong) NSString *swapProductOrderNo;
@property (nonatomic,strong) NSString *swapStatus;
@property (nonatomic,strong) NSString *swapTotalCount;
@property (nonatomic,strong) NSString *swapUserName;
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSString *targetCompanyName;
@property (nonatomic,strong) NSString *swapCheckUserName;

@property (nonatomic,strong) NSArray *product;
@property (nonatomic,strong) NSString *opType;
@property (nonatomic,strong) NSString *batchno;
@property (nonatomic,strong) NSString *initiator;
@property (nonatomic,strong) NSString *editor;
@end
