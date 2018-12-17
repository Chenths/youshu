//
//  HTMineModel.h
//  YS_zhtx
//
//  Created by mac on 2018/10/23.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPersonMessageModel.h"
#import "HTSingleLineReportModel.h"
#import <Foundation/Foundation.h>

@interface HTMineModel : NSObject

@property (nonatomic,strong)  NSString  *amount;

@property (nonatomic,strong)  NSArray  *amountList;

@property (nonatomic,strong)  NSString  *monthRate;

@property (nonatomic,strong)  NSString  *monthTarget;

@property (nonatomic,strong)  NSString  *yearTarget;

@property (nonatomic,strong)  NSString  *performanceRank;
@property (nonatomic,strong)  NSString  *vipCount;
@property (nonatomic,strong)  NSString  *vipfollowCount;
@property (nonatomic,strong)  NSString  *yearRate;

@property (nonatomic,strong) HTPersonMessageModel *personMessage;

@end
