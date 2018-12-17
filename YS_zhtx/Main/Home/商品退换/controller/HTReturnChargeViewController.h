//
//  YHChargeViewController.h
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
#import "HTCustModel.h"
#import "HTOrderDetailModel.h"
#import "HTCommonViewController.h"

@interface HTReturnChargeViewController : HTCommonViewController

@property (nonatomic,strong) HTCustModel *custModel;

@property (nonatomic,strong) NSArray *exchangeArray;

@property (nonatomic,strong) HTOrderDetailModel *orderModel;

@end
