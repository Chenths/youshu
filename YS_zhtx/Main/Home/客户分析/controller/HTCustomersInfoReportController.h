//
//  HTCustomersInfoReportController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTWarningModel.h"
#import "HTCommonViewController.h"

@interface HTCustomersInfoReportController : HTCommonViewController

@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,strong) NSArray *warningArr;

@property (nonatomic,strong) HTWarningModel *selectdWarning;


@end
