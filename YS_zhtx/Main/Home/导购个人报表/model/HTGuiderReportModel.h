//
//  HTGuiderReportModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuideReportBaceMsgModel.h"
#import "HTGuiderDateSaleModel.h"
#import "HTGuiderYeartLineData.h"
#import "HTPieDataItem.h"
#import "HTPiesModel.h"
#import <Foundation/Foundation.h>

@interface HTGuiderReportModel : NSObject

@property (nonatomic,strong) HTGuideReportBaceMsgModel *basicMessage;

@property (nonatomic,strong) HTGuiderDateSaleModel *yearSale;

@property (nonatomic,strong) HTGuiderDateSaleModel *monthSale;

@property (nonatomic,strong) HTGuiderDateSaleModel *todaySale;

@property (nonatomic,strong) HTPiesModel *ageModel;

@property (nonatomic,strong) HTPiesModel *sexModel;

@property (nonatomic,strong) HTPiesModel *activeModel;

@property (nonatomic,strong) HTGuiderYeartLineData *lastYearOfMonth;

@property (nonatomic,strong) HTGuiderYeartLineData *yearOfMonth;

@end
