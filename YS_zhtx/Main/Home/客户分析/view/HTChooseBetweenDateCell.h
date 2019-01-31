//
//  HTChooseBetweenDateCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomersInfoReprotModel.h"
#import "HTShopSaleReportModel.h"
#import <UIKit/UIKit.h>

@interface HTChooseBetweenDateCell : UITableViewCell
@property (nonatomic, assign) BOOL showColor;
@property (nonatomic,strong) NSIndexPath *index;

@property (nonatomic,strong) HTCustomersInfoReprotModel *model;

@property (nonatomic,strong) HTShopSaleReportModel *reportModel;
@end
