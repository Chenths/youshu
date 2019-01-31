//
//  HTCustomerReportModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomerReprotSaleMsgModel.h"
#import "HTGuiderYeartLineData.h"
#import "HTPiesModel.h"
#import "HTCustomerTagsModel.h"
#import <Foundation/Foundation.h>
#import "HTCustRFMMeaasge.h"
@interface HTCustomerReportModel : NSObject
//类别分类
@property (nonatomic,strong) HTPiesModel *categoriesModel;
//折扣分类
@property (nonatomic,strong) HTPiesModel *discountModel;
//颜色分类
@property (nonatomic,strong) HTPiesModel *colorModel;
//订单类型
@property (nonatomic,strong) HTPiesModel *orderTypeModel;
//价钱分类
@property (nonatomic,strong) HTPiesModel *priceModel;
//季节分类
@property (nonatomic,strong) HTPiesModel *seasonModel;
//颜色分类
@property (nonatomic,strong) HTPiesModel *sizeModel;
//去年数据
@property (nonatomic,strong) HTGuiderYeartLineData *lastYearOfMonth;
//今年数据
@property (nonatomic,strong) HTGuiderYeartLineData *yearOfMonth;
//基本消费信息
@property (nonatomic,strong) HTCustomerReprotSaleMsgModel *baseMessage;

@property (nonatomic,strong) HTCustomerTagsModel *tags;
//RFM
@property (nonatomic, strong) HTCustRFMMeaasge *custRFMMessage;

@end
