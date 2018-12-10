//
//  HTShareClass.m
//  shengyijing
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
//#import "JPUSHService.h"
#import "HTShareClass.h"
#import "HTBaceNavigationController.h"
#import "MainTabBarViewController.h"
#import "HTBossMainTabController.h"

@implementation HTShareClass

static HTShareClass *instance = nil;

+ (HTShareClass *)shareClass{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[HTShareClass alloc] init];
        }
    });
    
    return instance;
}
- (HTLoginDataModel *)loginModel{

    if (!_loginModel) {
        _loginModel = [[HTLoginDataModel alloc] init];
    }
    return _loginModel;
}
- (HTReportWarnStandard *)reportWarnStandard{
    if (!_reportWarnStandard) {
        _reportWarnStandard = [[HTReportWarnStandard alloc] init];
    }
    return _reportWarnStandard;
}
//- (HTDataCust *)vipCust{
//    if (!_vipCust) {
//        _vipCust = [[HTDataCust alloc] init];
//    }
//    return _vipCust;
//}
- (NSMutableArray *)menuArray{
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    return _menuArray;
    
}
- (HTPrinterModel *)printerModel{
    if (!_printerModel) {
        _printerModel = [[HTPrinterModel alloc] init];
    }
    return _printerModel;
}
- (HTSelectedImgaeObject *)selectdImg{
    if (!_selectdImg) {
        _selectdImg = [[HTSelectedImgaeObject alloc] init];
    }
    return _selectdImg;
}

- (void)setBadge:(NSString *)badge{
    _badge = badge;
    [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
}
-(BOOL)isShowAliCode{
    if (!_isShowAliCode) {
        NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"isShowAliCode"];
        if ([isshow isEqualToString:@"NO"]  ) {
            _isShowAliCode = NO;
        }
        if ([isshow isEqualToString:@"YES"]|| isshow.length == 0) {
            _isShowAliCode = YES;
        }
    }
    return _isShowAliCode;
}
- (UINavigationController *)getCurrentNavController{
    if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[MainTabBarViewController class]]) {
        MainTabBarViewController *tab = (id)[[UIApplication sharedApplication].delegate window].rootViewController;
        UINavigationController *nav = (id)tab.selectedViewController;
        return nav;
    }else if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[HTBossMainTabController class]]){
        HTBossMainTabController *tab = (id)[[UIApplication sharedApplication].delegate window].rootViewController;
        UINavigationController *nav = (id)tab.selectedViewController;
        return nav;
    }
    else{
        return [[UINavigationController alloc] init];
    }
   
}
-(NSString *)loginId{
    if (!_loginId) {
        _loginId = @"1";
    }
    return _loginId;
}
-(NSMutableArray *)faceArray{
    if (!_faceArray) {
        _faceArray = [NSMutableArray array];
    }
    return _faceArray;
}
@end
