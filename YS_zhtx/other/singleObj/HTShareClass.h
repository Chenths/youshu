//
//  HTShareClass.h
//  shengyijing
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
/**
 *  全局单例
 *
 */
//#import "HTAlertManager.h"
#import <Foundation/Foundation.h>
#import "HTLoginDataModel.h"
//#import "HTDataCust.h"
#import "HTSelectedImgaeObject.h"
#import "HTPrinterModel.h"
#import "HTReportWarnStandard.h"
#import "HTBossData.h"
#import <JMessage/JMessage.h>
@interface HTShareClass : NSObject

+ (HTShareClass *) shareClass;
//人脸识别弹框数据
@property (nonatomic,strong) NSMutableArray *faceArray;
//存储 用户loginId
@property (nonatomic,copy) NSString *loginId;
//储存 用户登录返回数据
@property (nonatomic,strong) HTLoginDataModel *loginModel;
//
//@property (nonatomic,strong) HTDataCust       *vipCust;
//判断是否隐藏支付二维码
@property (nonatomic,assign) BOOL              isShowAliCode;
//判断是否提示更新
@property (nonatomic,assign) BOOL              isUpdata;

//判断是否第一次进入app
@property (nonatomic,assign) BOOL              isFirstEnter;

//储存表单菜单容器

@property (nonatomic,strong) NSMutableArray  * menuArray;
// 是否是后台
@property (nonatomic,assign) BOOL   isBackGround;

@property (nonatomic,copy)  NSString    *jumpType;

@property (nonatomic,copy)  NSDictionary *jumpDic;

@property (nonatomic,strong) HTPrinterModel *printerModel;

//@property (nonatomic,strong) HTAlertManager *alertManager;
//预警标准
@property (nonatomic,strong) HTReportWarnStandard *reportWarnStandard;

@property (nonatomic,copy) NSString  *badge;


@property (nonatomic,strong) NSString *storeStr;

//售后页面是否需要刷新页面
@property (nonatomic,assign) BOOL  returnExchangeIsNeedReloadData;


@property (nonatomic,strong) NSString *selectedBaseUrl;

@property (nonatomic,assign) BOOL face;

@property (nonatomic,assign) BOOL isTestLogin;

@property (nonatomic,strong) JMSGConversation *msgConversation;
//msg用户名
@property (nonatomic,strong) NSString *JMessageUserId;
//msg密码
@property (nonatomic,strong) NSString *JMessagePwd;

@property (nonatomic,assign) BOOL isPlatformOnlinePayActive;


@property (nonatomic,assign) BOOL isProductStockActive;

@property (nonatomic,assign) BOOL isProductActive;

@property (nonatomic,assign) BOOL isBossProductStockActive;

@property (nonatomic,assign) BOOL isBossProductActive;

@property (nonatomic,assign) BOOL isupdate;

@property (nonatomic,assign) BOOL isGuide;

@property (nonatomic,assign) NSInteger smsConfig;

@property (nonatomic,strong) HTBossData *bossData;

@property (nonatomic,assign) NSInteger seltedPhotosCount;

@property (nonatomic,strong) HTSelectedImgaeObject *selectdImg;

- (UINavigationController *) getCurrentNavController;

@end
