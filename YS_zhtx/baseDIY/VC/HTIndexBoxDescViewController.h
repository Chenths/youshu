//
//  HTIndexBoxDescViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^SelectedIndex)(NSUInteger index);
#import "HTCommonViewController.h"

@interface HTIndexBoxDescViewController : HTCommonViewController

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,copy) SelectedIndex selectedIndex;

@end
