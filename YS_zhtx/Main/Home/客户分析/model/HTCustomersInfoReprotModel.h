//
//  HTCustomersInfoReprotModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTSingleLineReportModel.h"
#import "HTHorizontalReportDataModel.h"
#import "HTRankReportSingleCustomerModel.h"
#import "HTPiesModel.h"
#import "HTManyBarGraphModel.h"
#import "HTCustomerBarGraphModel.h"
#import <Foundation/Foundation.h>

@interface HTCustomersInfoReprotModel : NSObject

@property (nonatomic,strong) HTPiesModel *activeModel;

@property (nonatomic,strong) NSArray *addCustomer;

@property (nonatomic,strong) HTPiesModel *ageModel;

@property (nonatomic,strong) HTPiesModel *sexModel;

@property (nonatomic,strong) NSArray *amountDistribute;

@property (nonatomic,strong) NSArray *amountDistribute2;



@property (nonatomic,strong) NSArray *customerConsumeTimeApp;

@property (nonatomic,strong) NSArray *customerConsumeTimeApp2;

@property (nonatomic,strong) NSArray *consume;

@property (nonatomic,strong) NSString *notNameCustomerCount;

@property (nonatomic,strong) NSString *thisCustomerAmount;

@property (nonatomic,strong) NSString *thisMonthAmount;

@property (nonatomic,strong) NSString *thisMonthCount;

@property (nonatomic,strong) NSString *thisWeekCount;

@property (nonatomic,strong) NSString *todayCount;

@property (nonatomic,strong) NSString *totalCount;

@property (nonatomic,strong) NSString *vipConsumeAmount;

@property (nonatomic,strong) NSArray *storeAccount;

@property (nonatomic,strong) HTCustomerBarGraphModel *custLevelCount;

@property (nonatomic,strong) HTCustomerBarGraphModel *custLevelFreeStoreConsume;

@property (nonatomic,strong) HTCustomerBarGraphModel *custLevelPoint;

@property (nonatomic,strong) HTManyBarGraphModel *custLevelStore;

@property (nonatomic,strong) HTCustomerBarGraphModel *custLevelStoreConsume;

@property (nonatomic,assign) BOOL stordOpen;

@property (nonatomic,assign) BOOL consumeOpen;
//会员增长时间开始结束
@property (nonatomic,strong) NSString *vipAddTimeBegin;
@property (nonatomic,strong) NSString *vipAddTimeEnd;
//消费时间开始结束
@property (nonatomic,strong) NSString *consumeTimeBegin;
@property (nonatomic,strong) NSString *consumeTimeEnd;

//消费时间开始结束
@property (nonatomic,strong) NSString *consumeTimeSecBegin;
@property (nonatomic,strong) NSString *consumeTimeSecEnd;
//消费排行开始结束
@property (nonatomic,strong) NSString *rankTimeBegin;
@property (nonatomic,strong) NSString *rankTimeEnd;

@end
