//
//  HTOnlineCustomerListViewController.h
//  有术
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
typedef NS_ENUM(NSInteger, HTUSRTYPE) {
    HTUSRERVIP,
    HTUSRERNOTVIP,
};
#import "HTCommonViewController.h"

@interface HTOnlineCustomerListViewController : HTCommonViewController

@property (nonatomic,assign) HTUSRTYPE usrType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbTop;
@property (nonatomic, strong) NSString *sonShopId;
@property (nonatomic, assign) BOOL isBoss;
@end
