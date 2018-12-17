//
//  HTHoldCustomerEventManger.m
//  YS_zhtx
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTStoreMoneyViewController.h"
#import "HTEditVipViewController.h"
#import "HTNoticeCenterViewController.h"
#import "HTHoldCustomerEventManger.h"
#import "HTBillsViewController.h"
#import "JCHATConversationViewController.h"
@implementation HTHoldCustomerEventManger

+(void)callCustomerWithCustomerPhone:(NSString *)telPhone{
    
}
+ (void)chatWithCustomerWithCustomerId:(NSString *)customerId customerName:(NSString *)customerName andOpenId:(NSString *)openId {
    
    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    [MBProgressHUD showMessage:@"请稍等。。。"];
    [JMSGConversation createSingleConversationWithUsername:customerId appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [MBProgressHUD hideHUD];
            sendMessageCtl.conversation = resultObject;
            sendMessageCtl.modelId = customerId;
            sendMessageCtl.chatName = customerName;
            [[HTShareClass shareClass].getCurrentNavController pushViewController:sendMessageCtl animated:YES];
        } else {
            NSDictionary *dic1 = @{
                                   @"companyId":[HTShareClass shareClass].loginModel.companyId,
                                   @"customerId":[HTHoldNullObj getValueWithUnCheakValue:customerId],
                                   };
            [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"message/regist.html"] params:dic1 success:^(id json) {
                [MBProgressHUD hideHUD];
                sendMessageCtl.conversation = resultObject;
                sendMessageCtl.modelId = customerId;
                sendMessageCtl.chatName = customerName;
                [[HTShareClass shareClass].getCurrentNavController pushViewController:sendMessageCtl animated:YES];
            } error:^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:SeverERRORSTRING] ;
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请检查你的网络"];
            }];
        }
    }];
}
+ (void)editCustomerWithCustomerId:(NSString *)customerId{
    HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
    vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:customerId];
    for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
        if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
            vc.customerFollowRecordId = [mode.moduleId stringValue];
        }
        if ([mode.moduleName isEqualToString:@"customer"]) {
            vc.moduleModel = mode;
        }
    }
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
+(void)storedForCustomerWithCustomerPhone:(NSString *)tel;{
    HTStoreMoneyViewController *vc = [[HTStoreMoneyViewController alloc] init];
    vc.handType = HAND_TYPE_STORED;
    for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
        if ([mode.moduleName isEqualToString:@"customer"]) {
            vc.moduleId = [mode.moduleId stringValue];
            break;
        }
    }
    vc.phoneNumber = [HTHoldNullObj getValueWithUnCheakValue:tel];
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
+(void)deduedForCustomerWithCustomerPhone:(NSString *)tel;{
    HTStoreMoneyViewController *vc = [[HTStoreMoneyViewController alloc] init];
    vc.handType = HAND_TYPE_DEDUED;
    for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
        if ([mode.moduleName isEqualToString:@"customer"]) {
            vc.moduleId = [mode.moduleId stringValue];
            break;
        }
    }
    vc.phoneNumber = [HTHoldNullObj getValueWithUnCheakValue:tel];
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
+(void)addTimerForCustomerWithCustomerId:(NSString *)customerId{
    HTNoticeCenterViewController *vc = [[HTNoticeCenterViewController alloc] init];
    for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
        if ([mode.moduleName isEqualToString:@"customer"]) {
            vc.moduleId = [mode.moduleId stringValue];
            break;
        }
    }
    vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:customerId];
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
+(void)lookCustomerBillListWithCustomerId:(NSString *)customerId andCustModel:(HTCustModel *)cust {
    HTBillsViewController *vc = [[HTBillsViewController alloc] init];
    vc.custId = [HTHoldNullObj getValueWithUnCheakValue:customerId];
    vc.cust = cust;
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}


@end
