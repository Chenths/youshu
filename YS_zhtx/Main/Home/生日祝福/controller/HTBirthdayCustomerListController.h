//
//  HTBirthdayCustomerListController.h
//  有术
//
//  Created by mac on 2018/1/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef NS_OPTIONS(NSUInteger, HTBirthTodayOrNear) {
    HTBirthToday ,
    HTBirthNear
};
typedef void(^SelecetNear)(void);
#import "HTCommonViewController.h"

@interface HTBirthdayCustomerListController : HTCommonViewController

@property (nonatomic,assign) HTBirthTodayOrNear htbirthTodayType;

@property (nonatomic,copy) SelecetNear selectectNear;

@end
