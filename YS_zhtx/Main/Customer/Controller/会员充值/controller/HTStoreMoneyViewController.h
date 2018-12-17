//
//  HTStoreMoneyViewController.h
//  24小助理
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
typedef enum : NSUInteger {
    HAND_TYPE_STORED,//充值
    HAND_TYPE_DEDUED,//扣除

} HANDMONEYTYPE;

#import "HTCommonViewController.h"

@interface HTStoreMoneyViewController : HTCommonViewController

@property (nonatomic,assign) HANDMONEYTYPE  handType;

@property (nonatomic,strong) NSString *phoneNumber;

@property (nonatomic,strong) NSString *moduleId;

@property (nonatomic,strong) NSString *custId;

@end
