//
//  HTSingleShopDataModel.h
//  有术
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTSingleShopDataModel : NSObject

//销售单量
@property (nonatomic,strong) NSString *salesOrders;
//销售数量
@property (nonatomic,strong) NSString *salesNum;
//店铺名
@property (nonatomic,strong) NSString *merchantName;
//公司id
@property (nonatomic,strong) NSString *companyId;
//销售额
@property (nonatomic,strong) NSString *salesAmount;
//升降
@property (nonatomic,strong) NSString *up;
//折扣
@property (nonatomic,strong) NSString *discount;

@property (nonatomic,strong) NSString *profitUp;

@property (nonatomic,strong) NSString *profit;

@property (nonatomic,strong) NSString *max;

@property (nonatomic,strong) NSString *min;

@property (nonatomic,strong) NSString *todaySalesAmount;

@property (nonatomic,strong) NSString *todaySalesNum;

@property (nonatomic,strong) NSString *todaySalesOrders;


@property (nonatomic,assign) BOOL isload;

@end
