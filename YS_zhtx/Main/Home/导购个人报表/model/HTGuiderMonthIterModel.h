//
//  HTGuiderMonthIterModel.h
//  YS_zhtx
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTGuiderMonthIterModel : NSObject
//销量
@property (nonatomic,strong) NSString *volume;
//订单量
@property (nonatomic,strong) NSString *count;
//时间
@property (nonatomic,strong) NSString *date;
//销售价
@property (nonatomic,strong) NSString *amount;
//吊牌价
@property (nonatomic,strong) NSString *totalPrice;
//星期
@property (nonatomic,strong) NSString *weekName;

@end
