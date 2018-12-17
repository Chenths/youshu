//
//  HTPostProductStyleController.h
//  有术
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTMenuModle.h"
#import "HTCommonViewController.h"


@interface HTPostProductStyleController : HTCommonViewController

@property (nonatomic,strong) HTMenuModle *menuModel;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) NSString *type;

- (void) searchProductStyleWithDic:(NSDictionary *)dic;

@end
