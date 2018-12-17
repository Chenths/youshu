//
//  HTGuideSaleInfoModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTGuideSaleInfoModel : NSObject
//销售金额
@property (nonatomic,strong) NSString *amount;
//工号
@property (nonatomic,strong) NSString *amountre;
//导购名
@property (nonatomic,strong) NSString *discount;
//单量
@property (nonatomic,strong) NSString *finalfinalprice;
//销量
@property (nonatomic,strong) NSString *jobnum;
//销售占比
@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *finalordercount;

@property (nonatomic,strong) NSString *ordernum;

@property (nonatomic,strong) NSString *ordernumre;

@property (nonatomic,strong) NSString *ralt;

@property (nonatomic,strong) NSString *finalsalevolume;

@property (nonatomic,strong) NSString *salesvolumere;

@property (nonatomic,strong) NSString *salevolume;

@property (nonatomic,strong) NSString *serialup;

@property (nonatomic,strong) NSString *totalprice;

@property (nonatomic,strong) NSString *totalpricecurrent;

@property (nonatomic,strong) NSString *totalpricere;

@property (nonatomic,strong) NSIndexPath *index;

//@property (nonatomic,strong) NSString *totalmoneycurrent;
//
//@property (nonatomic,strong) NSString *totalmoneyre;
//
///**
// 
// */
//@property (nonatomic,strong) NSString *totalre;

@end
