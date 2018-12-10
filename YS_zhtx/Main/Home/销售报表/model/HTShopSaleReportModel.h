//
//  HTShopSaleReportModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTSingleLineReportModel.h"
#import "HTPiesModel.h"
#import "HTBigOrderModel.h"
#import "EmployeeContributionModel.h"
#import "HTProductRankInfoModel.h"
#import <Foundation/Foundation.h>

@interface HTShopSaleReportModel : NSObject

@property (nonatomic,strong) NSArray *bascArray;

@property (nonatomic,strong) NSArray *amountList;

@property (nonatomic,strong) HTPiesModel *categrieModel;
@property (nonatomic,strong) HTPiesModel *customTypeModel;

@property (nonatomic,strong) EmployeeContributionModel *employeeContribution;

@property (nonatomic,strong) NSArray *bigOrderMap;

@property (nonatomic,strong) NSArray *productRank;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,strong) NSString *productBeginTime;

@property (nonatomic,strong) NSString *productEndTime;

@property (nonatomic,strong) NSString *season;


@end
