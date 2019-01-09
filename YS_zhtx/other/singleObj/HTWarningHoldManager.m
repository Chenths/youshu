//
//  HTWarningHoldManager.m
//  YS_zhtx
//
//  Created by mac on 2018/10/24.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTWarningWebViewController.h"
#import "HTWarningHoldManager.h"

@implementation HTWarningHoldManager

+(void)holdWarningWithTitle:(NSString *)warningTitle andWarningValue:(NSString *)value{
    
    if ([warningTitle isEqualToString:@"折扣"]) {
        [self showAlartWithTitle:DISCOUNTWARNING([HTShareClass shareClass].reportWarnStandard.zkl,value)  andFinalUrl:basezkl];
    }else if ([warningTitle isEqualToString:@"连带率"]){
        [self showAlartWithTitle:SERUILWARNING([HTShareClass shareClass].reportWarnStandard.ldl,value) andFinalUrl:baseldl];
    }else if ([warningTitle isEqualToString:@"换货率"]){
        [self showAlartWithTitle:HHLWARNING([HTShareClass shareClass].reportWarnStandard.ldl,value) andFinalUrl:basehhl];
    }else if ([warningTitle isEqualToString:@"退货率"]){
        [self showAlartWithTitle:THLWARNING([HTShareClass shareClass].reportWarnStandard.ldl,value) andFinalUrl:basethl];
    }else if ([warningTitle isEqualToString:@"VIP销售占比"]){
        [self showAlartWithTitle:VIPWARNING([HTShareClass shareClass].reportWarnStandard.vipgxl,value) andFinalUrl:basehygxl];
    }else if ([warningTitle isEqualToString:@"活跃会员"]){
        [self showAlartWithTitle:VIPWARNING([HTShareClass shareClass].reportWarnStandard.hyhy,value) andFinalUrl:basehyhy];
    }else if ([warningTitle isEqualToString:@"VIP新增数"]){
        [self showAlartWithTitle:NEWVIPWARNING([HTShareClass shareClass].reportWarnStandard.AnewMonthVIPNum,value) andFinalUrl:basexzhy];
    }else if ([warningTitle isEqualToString:@"老VIP成交数"]){
        [self showAlartWithTitle:OLDVIPWARNING([HTShareClass shareClass].reportWarnStandard.MonthlyTurnover4OldVIPNum,value) andFinalUrl:@"lhycjs"];
    }else if ([warningTitle isEqualToString:@"营业额"]){
        [self showAlartWithTitle:MonthSaleWARNING([HTShareClass shareClass].reportWarnStandard.monthTarget,value) andFinalUrl:@"yxs"];
    }
}

+(void)showAlartWithTitle:(NSString *)title andFinalUrl:(NSString *)finallUrl{
    
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:title btsArray:@[@"确定",@"去学习"] okBtclicked:^{
        HTWarningWebViewController *vc = [[HTWarningWebViewController alloc] init];
        vc.finallUrl = finallUrl;
        [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    } cancelClicked:nil];
    [alert show];
}


@end
