//
//  HTCustomerReprotSaleMsgModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCustomerReprotSaleMsgModel : NSObject
//平均折扣
@property (nonatomic,strong) NSString *avgdiscount;
//平均价格
@property (nonatomic,strong) NSString *avgprice;
//生日
@property (nonatomic,strong) NSString *birthday;

@property (nonatomic,strong) NSString *buyralt;
//创建时间
@property (nonatomic,strong) NSString *createdate;
//创建者 导购
@property (nonatomic,strong) NSString *creator;
//会员等级
@property (nonatomic,strong) NSString *custlevel;
//会员等级
@property (nonatomic,strong) NSString *customertype;
//未消费天数
@property (nonatomic,strong) NSString *day;
//
@property (nonatomic,strong) NSString *finalprice;
//
@property (nonatomic,strong) NSString *givestore;
//会员姓名
@property (nonatomic,strong) NSString *name;
//订单数
@property (nonatomic,strong) NSString *ordercount;
//电话
@property (nonatomic,strong) NSString *phone;
//性别
@property (nonatomic,strong) NSString *sex;
//储值
@property (nonatomic,strong) NSString *store;
//连带率
@property (nonatomic,strong) NSString *ralt;
//
@property (nonatomic,strong) NSString *salevolume;

@property (nonatomic,strong) NSString *unitprice;

@property (nonatomic,strong) NSString *headimg;

@property (nonatomic,strong) NSString *points;

@property (nonatomic,strong) NSString *openid;
@property (nonatomic,strong) NSString *isedit;
@property (nonatomic,strong) NSString *isdel;
@property (nonatomic,strong) NSString *hobby;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *remark;
//微信
@property (nonatomic,strong) NSString *wechat;
@end
