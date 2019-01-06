//
//  HTCustomerReportViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomerAuth.h"
#import "HTCustomerListModel.h"
typedef NS_OPTIONS(NSUInteger, HTCustomerReportType) {
    HTCustomerReportTypeNomal,
    HTCustomerReportTypeFacePush,
};

#import "HTCommonViewController.h"
@interface HTCustomerReportViewController : HTCommonViewController

@property (nonatomic,assign) HTCustomerReportType customerType;

@property (nonatomic,strong) HTCustomerListModel *model;

@property (nonatomic,strong) HTCustomerAuth *authModel;

@property (nonatomic,strong) NSString *customerFollowRecordId;

@property (nonatomic, copy) NSString *imgUrlFromFace;
@end
