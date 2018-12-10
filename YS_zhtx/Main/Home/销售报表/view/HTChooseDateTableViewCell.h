//
//  HTChooseDateTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTShopSaleReportModel.h"
#import <UIKit/UIKit.h>

@interface HTChooseDateTableViewCell : UITableViewCell

@property (nonatomic,strong) HTShopSaleReportModel *model;

@property (nonatomic,strong) HTShopSaleReportModel *reportModel;

@property (nonatomic,strong) NSString *reportDate;


@end
