//
//  HTBossSelecteShopsController.h
//  有术
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTCompanyListModel.h"
typedef void(^HTSelectedCompany)(HTCompanyListModel *model);

typedef void(^HTSelectedCompanys)(NSArray *companys);

#import "HTCommonViewController.h"

@interface HTBossSelecteShopsController : HTCommonViewController

@property (nonatomic,assign) int maxSelected;

@property (nonatomic,copy) HTSelectedCompany selectedCompany;
@property (nonatomic,copy) HTSelectedCompanys  selectedsComs;

@property (nonatomic,strong) NSArray *selectedCompanys;

@end
