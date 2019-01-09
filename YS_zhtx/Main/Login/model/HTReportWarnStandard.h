//
//  HTReportWarnStandard.h
//  有术
//
//  Created by mac on 2017/2/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTReportWarnStandard : NSObject
//活跃vip占比标准
@property (nonatomic,strong) NSNumber *hyvip;
//连带率标准
@property (nonatomic,strong) NSString *ldl;
//vip贡献率占比标准
@property (nonatomic,strong) NSNumber *vipgxl;
//折扣率标准
@property (nonatomic,strong) NSString *zkl;

@property (nonatomic,strong) NSString *xsje; //销售金额

@property (nonatomic,strong) NSString *kdj  ;//客单价

@property (nonatomic,strong) NSString *jdl  ;//进店率

@property (nonatomic,strong) NSString *thl ;//退货率

@property (nonatomic,strong) NSString *hhl ;//换货率

@property (nonatomic,strong) NSString *xzhy ;//新增会员

@property (nonatomic,strong) NSString *hyhy ;//会员活跃

@property (nonatomic,strong) NSString *hyhtl ;//会员回头率

@property (nonatomic,strong) NSString *zxcp ;// 滞销产品

@property (nonatomic,strong) NSString *vipyxzs;//vip月新增数
@property (nonatomic,strong) NSString *lvipycjs;//老vip月成交数

@end
