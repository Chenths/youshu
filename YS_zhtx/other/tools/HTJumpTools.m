//
//  HTJumpTools.m
//  24小助理
//
//  Created by mac on 16/9/20.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.

#import "HTJumpTools.h"
#import "HTBaceNavigationController.h"
#import "HTBirthDayCustomerCenterController.h"
#import "HTFestivalViewController.h"
#import "HTTurnListDescInfoController.h"
#import "HTSaleGoodOrBadDetailController.h"
#import "HTMyShopCustomersCenterController.h"
#import "HTEditVipViewController.h"
#import "HTCustomerReportViewController.h"
#import "HTOrderDetailViewController.h"
#import "HTDayChartReportViewController.h"
#import "HTGSaleReportViewController.h"
#import "HTOrderViewController.h"
#import "HTWarningWebViewController.h"
@implementation HTJumpTools

+ (void)jumpWithStr:(NSString *)type withDic:(NSDictionary *)dataDic{
    
    
    NSString *jsonStr = [dataDic getStringWithKey:@"noticeParams"];
    NSDictionary *paramsDic = [jsonStr dictionaryWithJsonString];
    UINavigationController *nac = [[HTShareClass shareClass] getCurrentNavController];
    if ([type isEqualToString:@"VIP_FEEDBACK"] || [type isEqualToString:@"VIP_REPORT"]) {
//       各种详情
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
        model.custId = [dataDic getStringWithKey:@"modelId"];
        vc.model = model;
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"MODEL"]){
        for (HTMenuModle *model  in [HTShareClass shareClass].menuArray) {
            if (model.moduleId.integerValue == [dataDic[@"moduleId"] integerValue]) {
                if ([model.moduleName isEqualToString:@"customer"]) {
                    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
                    HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
                    model.custId = [dataDic getStringWithKey:@"modelId"];
                    vc.model = model;
                    [nac pushViewController:vc animated:YES];
                }else if ([model.moduleName isEqualToString:@"order"]){
                    HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
                    vc.orderId =  [dataDic getStringWithKey:@"modelId"];
                    [nac pushViewController:vc animated:YES];
                }
                break;
            }
        }
    }else if ([type isEqualToString:@"NEW_ORDER"]){
        HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
        vc.orderId =  [dataDic getStringWithKey:@"modelId"];
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"EDITE_CUSTOMER"]){
//      编辑客户
        HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
        vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:dataDic[@"modelId"]];
        for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
            if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                vc.customerFollowRecordId = [mode.moduleId stringValue];
            }
            if ([mode.moduleName isEqualToString:@"customer"]) {
                vc.moduleModel = mode;
            }
        }
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"DAY_REPORT"]){
//       日报表
        HTDayChartReportViewController *vc = [[HTDayChartReportViewController alloc] init];
        NSString *date = [dataDic getStringWithKey:@"date"];
        if (date.length >= 11) {
            vc.reportDate = [date substringWithRange:NSMakeRange(0, 11)];
        }
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"WEEK_REPORT"]){
//        周报表
        HTGSaleReportViewController *vc = [[HTGSaleReportViewController alloc] init];
        NSString *date = [dataDic getStringWithKey:@"date"];
        if (date.length >= 10) {
            vc.dateStr = [date substringWithRange:NSMakeRange(0, 10)];
        }
        vc.dateMode = @"weak";
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"MONTH_REPORT"]){
//       月报表
        HTGSaleReportViewController *vc = [[HTGSaleReportViewController alloc] init];
        NSString *date = [dataDic getStringWithKey:@"date"];
        if (date.length >= 10) {
            vc.dateStr = [date substringWithRange:NSMakeRange(0, 10)];
        }
        vc.dateMode = @"month";
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"ORDER_DATA"]){
//       老板层级 下单报表推送
        HTDayChartReportViewController *vc = [[HTDayChartReportViewController alloc] init];
        NSString *date = [dataDic getStringWithKey:@"date"];
        vc.companyId = [paramsDic getStringWithKey:@"companyId"];
        vc.companyName = [paramsDic getStringWithKey:@"companyName"];
        if (date.length >= 11) {
            vc.reportDate = [date substringWithRange:NSMakeRange(0, 11)];
        }
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"NEW_WECHAT_ORDER"]){
//        在线订单
        HTOrderViewController *vc = [[HTOrderViewController alloc] init];
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"ACCOUNT_BILL"]){
//       账单
    }else if ([type isEqualToString:@"PAY_SETTLEMENT"]){
//       账单详情
        
    }else if ([type isEqualToString:@"TUNE_MANIFEST_OUT"]||[type isEqualToString:@"TUNE_MANIFEST_OUT_RETURN_GOODS"]||[type isEqualToString:@"TUNE_MANIFEST_OUT_RETURN_DAMAGE"]||[type isEqualToString:@"TUNE_MANIFEST_OUT_SWAP_OTHER"]){
//        调货单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"TUNE_MANIFEST_IN"]){
//      调货单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"PURCHASE_MANIFEST"]){
//        调货单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"SUPPLEMENT_MANIFEST"]){
//        补货单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        vc.title = @"补货单";
        [nac pushViewController:vc animated:YES];

    }else if ([type isEqualToString:@"TRANSSHIPMENT_MANIFEST"]){
//        调货单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        vc.title = @"调入单";
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"INVENTORY_WARNING"]){
//        库存历史
        HTSaleGoodOrBadDetailController *vc = [[HTSaleGoodOrBadDetailController alloc] init];
        vc.title = @"库存预警";
        ;
        vc.barcode = [[[dataDic getStringWithKey:@"noticeParams"] dictionaryWithJsonString] getStringWithKey:@"barcode"];
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"TUNE_MANIFEST_FEEDBACK"]){
//        调货单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        vc.title = @"调货单收货反馈";
        [nac pushViewController:vc animated:YES];

    }else if ([type isEqualToString:@"STOCK_TAKING"]){
//        盘点单详情
        HTTurnListDescInfoController *vc = [[HTTurnListDescInfoController alloc] init];
        vc.noticeId = [dataDic getStringWithKey: @"noticeId"];;
        vc.title =  @"盘点确认";
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"FESTIVAL_REMIND"]){
//        节日提醒
        HTFestivalViewController *vc = [[HTFestivalViewController alloc] init];
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"BIRTHDAY_REMIND"]){
//        生日提醒
        HTBirthDayCustomerCenterController *vc = [[HTBirthDayCustomerCenterController alloc] init];
        [nac pushViewController:vc animated:YES];
    }else if([type isEqualToString:@"VIP_REPORT"]){
//        进店客户
        HTMyShopCustomersCenterController *vc = [[HTMyShopCustomersCenterController alloc] init];
        [nac pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"LINK_SKIP"]){
        HTWarningWebViewController *vc = [[HTWarningWebViewController alloc] init];
        vc.finallUrl = [paramsDic objectForKey:@"linkUrl"];
        [nac pushViewController:vc animated:YES];
    }
   [HTShareClass shareClass].jumpType = @"";
}


@end
