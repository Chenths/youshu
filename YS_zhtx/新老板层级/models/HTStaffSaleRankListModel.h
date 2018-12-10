//
//  HTStaffSaleRankListModel.h
//  有术
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTStaffSaleRankListModel : NSObject
//姓名
@property (nonatomic,strong) NSString *name;
//单量
@property (nonatomic,strong) NSString *orderNumCurrent;
//总金额
@property (nonatomic,strong) NSString *moneyCurrent;
//销量
@property (nonatomic,strong) NSString *totalCurrent;
//退货单
@property (nonatomic,strong) NSString *orderNumRe;


@end
