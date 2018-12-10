//
//  HTBlueToothPrinterController.h
//  有术
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HLPrinter.h"
#import "HTCommonViewController.h"
#import "HTPrinterTool.h"

@interface HTBlueToothPrinterController : HTCommonViewController

@property (nonatomic,strong) HLPrinter *smallPrinter;

@property (nonatomic,strong) HLPrinter *bigPrinter;

@property (nonatomic,copy) PushNext pushNext;

@end
