//
//  HTSaleDescViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTDateSaleDescModel.h"
#import "HTCommonViewController.h"

@interface HTSaleDescViewController : HTCommonViewController

@property (nonatomic,strong) HTDateSaleDescModel *typeModel;

@property (nonatomic,strong) NSString *guideId;

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSString *singleDate;

@property (nonatomic,strong) NSString *monthDate;

@property (nonatomic,strong) NSString *yearDate;

@end
