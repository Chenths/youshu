//
//  HTCustAccoutModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTAccoutInfoModel.h"
#import <Foundation/Foundation.h>

@interface HTCustAccoutModel : NSObject
//储值
@property (nonatomic,strong) HTAccoutInfoModel *stored;
//积分
@property (nonatomic,strong) HTAccoutInfoModel *integral;
//储赠
@property (nonatomic,strong) HTAccoutInfoModel *storedPresented;


@end
