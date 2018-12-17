//
//  YHInventoryViewController.h
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
@class HTCustomerListModel;
typedef void(^SEARCHCUSTITEM)(HTCustomerListModel *model);
#import "HTCommonViewController.h"

@interface HTCustomerViewController : HTCommonViewController

@property (nonatomic,copy) SEARCHCUSTITEM searchCustItme;

@property (nonatomic,strong) NSDictionary *sendDic;

@property (nonatomic,strong) NSString *companyId;

@end
