//
//  HTChangePrinterBrandController.h
//  有术
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
typedef void(^SELECTEDBRAND)(int versions);
@protocol SelectPrinterBrandDelegate <NSObject>

- (void)selectedPrinterBrandWithVerison:(int) versions;

- (void)cancelSelectedBrand;

- (void)neverNoticeSelectedBrand;

@end

#import "HTCommonViewController.h"

@interface HTChangePrinterBrandController : HTCommonViewController

@property (nonatomic,copy) SELECTEDBRAND selcetedBrand;

@property (nonatomic,assign) BOOL isAddPrint;


@property (nonatomic,weak) id <SelectPrinterBrandDelegate> delegate;

@end
