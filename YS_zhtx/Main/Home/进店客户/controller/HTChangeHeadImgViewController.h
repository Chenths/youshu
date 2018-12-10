//
//  HTChangeHeadImgViewController.h
//  有术
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
typedef void(^SeleteHeadImg)(UIImage *headImg);
#import "HTCommonViewController.h"

@interface HTChangeHeadImgViewController : HTCommonViewController

@property (nonatomic,strong) NSString *uid;

@property (nonatomic,strong) NSString *headUrl;

@property (nonatomic,strong) SeleteHeadImg headImg;

@end
