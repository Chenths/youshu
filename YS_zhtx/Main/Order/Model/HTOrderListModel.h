//
//  HTOrderListModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderListProductModel.h"
#import <Foundation/Foundation.h>

@interface HTOrderListModel : NSObject

@property (nonatomic,strong) NSString *createDate ;
@property (nonatomic,strong) NSString *creator ;
@property (nonatomic,strong) NSString *custLevel ;
@property (nonatomic,strong) NSString *customer ;
@property (nonatomic,strong) NSString *finalPrice;
@property (nonatomic,strong) NSString *headImg;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *name ;
@property (nonatomic,strong) NSArray *orderDetails;
@property (nonatomic,strong) NSString *orderStatus;
@property (nonatomic,strong) NSString *totalPrice;

@property (nonatomic,strong) NSString *paytype;
@property (nonatomic,strong) NSString *ordertype;
@property (nonatomic,strong) NSString *hasmodifiedprice;
@property (nonatomic,strong) NSString *edit_date;

@property (nonatomic,strong) NSString *isdelivery;



@property (nonatomic,assign) BOOL isedit;
@property (nonatomic,assign) BOOL isdel;


@end
