//
//  HTNewPayViewController.h
//  YS_zhtx
//
//  Created by mac on 2019/1/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTCommonViewController.h"
#import "HTChargeOrderModel.h"
#import "HTCustModel.h"

@interface HTNewPayViewController : HTCommonViewController
@property (nonatomic,strong) HTChargeOrderModel *orderModel;

//@property (nonatomic,strong) NSString *addUrl;
//
//@property (nonatomic,strong) NSString *payCode;

@property (nonatomic,strong) NSString *requestNum;

@property (nonatomic,strong) NSArray *products;

@property (nonatomic,strong) HTCustModel *custModel;
//如果是简易下单 
@property (nonatomic, assign) BOOL isFromFast;
@property (nonatomic, strong) NSString *bcProductStr;

@end
