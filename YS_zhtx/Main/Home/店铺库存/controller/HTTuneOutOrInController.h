//
//  HTTuneOutOrInController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTStyleInventoryModel.h"
#import "HTCommonViewController.h"
typedef NS_ENUM(NSInteger, HTTurnOutOrInType) {
    HTTurnOut,
    HTTurnIn,
};
@interface HTTuneOutOrInController : HTCommonViewController

@property (nonatomic,assign) HTTurnOutOrInType turnType;

@property (nonatomic,strong) HTStyleInventoryModel *inventoryModel;

@property (nonatomic,strong) NSArray *sizeList;

@end
