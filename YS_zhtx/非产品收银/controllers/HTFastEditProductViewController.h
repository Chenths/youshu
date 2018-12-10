//
//  HTFastEditProductViewController.h
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTFastPrudoctModel.h"
#import "HTCommonViewController.h"
typedef void(^DELETEPROUCT)(void);
typedef void(^SelectedFastModel)(HTFastPrudoctModel *model);
@interface HTFastEditProductViewController : HTCommonViewController

@property (nonatomic,strong) HTFastPrudoctModel *editModel;

@property (nonatomic,copy) SelectedFastModel selectedProductModel;
@property (nonatomic,copy) DELETEPROUCT deleteProuct;
@end
