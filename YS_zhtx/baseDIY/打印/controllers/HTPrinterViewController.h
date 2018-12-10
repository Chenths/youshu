//
//  HTPrinterViewController.h
//  24小助理
//
//  Created by mac on 16/9/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTCommonViewController.h"
#import <UIKit/UIKit.h>
typedef void(^SelectWhich)(NSString *num);

@interface HTPrinterViewController : HTCommonViewController

@property (nonatomic,copy)  SelectWhich selectWhich;
@end
