//
//  HTAgencyMainDataModel.h
//  有术
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTAgencyMainDataModel : NSObject

//品牌
@property (nonatomic,strong) NSString *brand;
//门店数
@property (nonatomic,strong) NSString *merchants;
//最优店铺
@property (nonatomic,strong) NSString *best;
//最差店铺
@property (nonatomic,strong) NSString *worst;
//销售数量
@property (nonatomic,strong) NSString *salesNum;
//销售额
@property (nonatomic,strong) NSString *salesAmount;
//今日销售额
@property (nonatomic,strong) NSString *todaySalesAmount;
//今日销售件数
@property (nonatomic,strong) NSString *todaySalesNum;

@property (nonatomic,strong) NSString *salesOrders;

@property (nonatomic,strong) NSString *todayProfit;

@property (nonatomic,strong) NSString *todaySalesOrders;

@property (nonatomic,strong) NSString *totalProfit;

@property (nonatomic,strong) NSString *yearProfit;

@property (nonatomic,strong) NSString *yearSalesAmount;

@property (nonatomic,strong) NSString *yearSalesNum;

@property (nonatomic,strong) NSString *yearSalesOrders;
//年月日的都是它
@property (nonatomic, strong) NSString *profit;

@end
