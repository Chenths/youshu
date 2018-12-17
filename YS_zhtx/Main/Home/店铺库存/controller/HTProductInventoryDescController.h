//
//  HTProductInventoryDescController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCommonViewController.h"

@interface HTProductInventoryDescController : HTCommonViewController

@property (nonatomic,strong) NSString *barcode;

@property (nonatomic,strong) NSArray *sizeList;

@property (nonatomic,strong) NSArray *colorList;


@property (nonatomic,strong) NSString *companyId;
@end
