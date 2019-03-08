//
//  HTSaleProductRankListController.h
//  YS_zhtx
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTShopSaleReportModel.h"
#import "HTCommonViewController.h"

@interface HTSaleProductRankListController : HTCommonViewController

@property (nonatomic,strong) HTShopSaleReportModel *model;

@property (nonatomic,strong) NSString *companyId;
@property (nonatomic, strong) NSString *ids;
@end
