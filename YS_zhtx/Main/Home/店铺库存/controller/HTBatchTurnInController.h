//
//  HTBatchTurnInController.h
//  有术
//
//  Created by mac on 2018/3/12.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^ReloadList)();
#import "HTCommonViewController.h"

@interface HTBatchTurnInController : HTCommonViewController

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) ReloadList reloadList;

@end
