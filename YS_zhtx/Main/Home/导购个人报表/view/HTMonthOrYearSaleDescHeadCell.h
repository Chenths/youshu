//
//  HTMonthSaleDescHeadCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderMonthModel.h"
#import "HTGuiderYearModel.h"
#import "HTDateSaleDescModel.h"
#import <UIKit/UIKit.h>
#import "HTGuiderReportModel.h"

@interface HTMonthOrYearSaleDescHeadCell : UITableViewCell

@property (nonatomic,strong) NSString  *monthDate;

@property (nonatomic,strong) NSString  *yearDate;

@property (nonatomic,strong) HTDateSaleDescModel *model;

@property (nonatomic,strong) HTGuiderMonthModel *monthModel;

@property (nonatomic,strong) HTGuiderYearModel *yearModel;

@property (nonatomic,strong) HTGuiderReportModel *guideModel;
@end
