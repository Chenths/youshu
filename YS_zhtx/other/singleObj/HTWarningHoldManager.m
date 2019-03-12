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
    
    if ([warningTitle isEqualToString:@"折扣率"]) {
        [self showAlartWithTitle:DISCOUNTWARNING([HTShareClass shareClass].reportWarnStandard.zkl,value)  andFinalUrl:basezkl];
    }else if ([warningTitle isEqualToString:@"连带率"]){
        [self showAlartWithTitle:SERUILWARNING([HTShareClass shareClass].reportWarnStandard.ldl,value) andFinalUrl:baseldl];
    }else if ([warningTitle isEqualToString:@"换货率"]){
        [self showAlartWithTitle:HHLWARNING([HTShareClass shareClass].reportWarnStandard.ldl,value) andFinalUrl:basehhl];
    }else if ([warningTitle isEqualToString:@"退货率"]){
        [self showAlartWithTitle:THLWARNING([HTShareClass shareClass].reportWarnStandard.ldl,value) andFinalUrl:basethl];
    }else if ([warningTitle isEqualToString:@"VIP销售占比"] || [warningTitle isEqualToString:@"VIP贡献率"]){
        [self showAlartWithTitle:VIPWARNING([HTShareClass shareClass].reportWarnStandard.vipgxl,value) andFinalUrl:basehygxl];
    }else if ([warningTitle isEqualToString:@"活跃会员"] || [warningTitle isEqualToString:@"活跃会员占比"]){
        [self showAlartWithTitle:ACTIVEVIPWARNING([HTShareClass shareClass].reportWarnStandard.hyhy,value) andFinalUrl:basehyhy];
    }else if ([warningTitle isEqualToString:@"VIP新增数"] || [warningTitle isEqualToString:@"新增会员"] || [warningTitle isEqualToString:@"新增VIP数量"]){
        [self showAlartWithTitle:NEWVIPWARNING([HTShareClass shareClass].reportWarnStandard.AnewMonthVIPNum,value) andFinalUrl:basexzhy];
    }else if ([warningTitle isEqualToString:@"老VIP成交数"] || [warningTitle isEqualToString:@"会员成交人数"]){
        [self showAlartWithTitle:OLDVIPWARNING([HTShareClass shareClass].reportWarnStandard.MonthlyTurnover4OldVIPNum,value) andFinalUrl:baselvipycjs];
    }else if ([warningTitle isEqualToString:@"营业额"] || [warningTitle isEqualToString:@"销售额 (元)"] || [warningTitle isEqualToString:@"店铺目标"]){
        [self showAlartWithTitle:MonthSaleWARNING([HTShareClass shareClass].reportWarnStandard.monthTarget,value) andFinalUrl:basedpyxse];
    }else if ([warningTitle isEqualToString:@"单量"]){
        [self showAlartWithTitle:DLWARNING([HTShareClass shareClass].reportWarnStandard.dl,value) andFinalUrl:basedl];
    }else if ([warningTitle isEqualToString:@"销量"] || [warningTitle isEqualToString:@"销量 (件)"]){
        [self showAlartWithTitle:XLWARNING([HTShareClass shareClass].reportWarnStandard.xl,value) andFinalUrl:basexl];
    }else if ([warningTitle isEqualToString:@"客单价"]){
        [self showAlartWithTitle:KDJWARNING([HTShareClass shareClass].reportWarnStandard.kdj,value) andFinalUrl:basekdj];
    }else if ([warningTitle isEqualToString:@"VIP回头率"] || [warningTitle isEqualToString:@"回头率"]){
        [self showAlartWithTitle:HTLWARNING([HTShareClass shareClass].reportWarnStandard.hyhtl,value) andFinalUrl:basehyhtl];
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
