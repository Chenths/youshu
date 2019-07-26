  //
//  HTAccountTool.m
//  shengyijing
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTAccountTool.h"
#import "HTLoginVienController.h"
#import "NSString+md5.h"
#import "HTLoginDataPersonModel.h"
#import "MainTabBarViewController.h"
#import "HTBossMainTabController.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
////腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
////微信SDK头文件
#import "WXApi.h"
////新浪微博SDK头文件
#import "WeiboSDK.h"
@implementation HTAccountTool

+ (void)shareSdkSet{
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:@"1105561286" appkey:@"EtCAahVolrw2s6pd"];
        //微信
        [platformsRegister setupWeChatWithAppId:@"wxb336e2599cc4de7a" appSecret:@"dc1c7d054821b19f3d3277b6841a9e0c"];
        
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"1523147740" appSecret:@"8ba44a401901e5338e2348fadb8c4a8d" redirectUrl:@"http://sns.whalecloud.com/sina2/callback"];
    }];
}


+ (BOOL)isLogined{

    NSString *DDNAME = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDNAME"];
    NSString *DDPWD = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDPWD"];
    //账户好密码登录
    if (DDNAME.length!=0 && DDPWD.length !=0 ){
        return YES;
    }else{
        return NO;
    }
}
//
+ (void)exitLogin{
    NSString *DDPWD = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDPWD"];
    NSString *loginUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUid"];
    [HTShareClass shareClass].loginId = @"";
    if (DDPWD.length !=0 ){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"DDPWD"];
        [[NSUserDefaults standardUserDefaults] synchronize];//强制User Defaults系统进行保存
    }
    if([NSString stringWithFormat:@"%@",loginUid].length != 0){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LoginUid"];
        [[NSUserDefaults standardUserDefaults] synchronize];//强制User Defaults系统进行保存
    }
    [HTShareClass shareClass].isTestLogin = NO;
    [HTShareClass shareClass].selectedBaseUrl = @"";
    [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
}
///**
// *用户注册点击完成，以及自动登录选择控制器
// *
// */
//#pragma mark - 用户注册点击完成，以及自动登录选择控制器
+(void)choiceVC {
    if ([HTAccountTool isLogined]) {
//         跳转到首页   同时做网络请求
           //    取出用户信息
        Account *uAccount = [self getAccout];
       [self loginDoSomeThing:^(id json){
//           第二版布局
           [HTAccountTool cheackUnionId];
           [self createViewControllerWithjson:json];
       } WithAccount:uAccount];
    } else {
//        跳转登录界面
        [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
    }
}
///**
// *  取出用户
// *
// *  @return 用户信息
// */
+ (Account *) getAccout{

    NSString *DDNAME = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDNAME"];
    NSString *DDPWD = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDPWD"];
    NSString *DDSNB  = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDSNB"];
    //    生成用户
    Account *uAccount = [[Account alloc] init];
    uAccount.userName = DDNAME;
    uAccount.passWord = DDPWD;
    uAccount.shopNumber = DDSNB;
    return uAccount;
}
//
////暂时没用
///**
// *  布局登录后的界面
// */
+ (void) createViewControllerWithjson:(id)json{
    if ([json[@"data"][@"company"][@"type" ] isEqualToString:@"AGENT"]){
        HTBossMainTabController *vc = [[HTBossMainTabController alloc] init];
        [[UIApplication sharedApplication].delegate window].rootViewController = vc;
    }else if ([json[@"data"][@"company"][@"type" ] isEqualToString:@"BOSS"]){
        HTBossMainTabController *vc = [[HTBossMainTabController alloc] init];
        [[UIApplication sharedApplication].delegate window].rootViewController = vc;
    }else if ([json[@"data"][@"company"][@"type" ] isEqualToString:@"BRAND"]){
        //        跳转登录界面
        [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
         [MBProgressHUD showError:@"店铺不存在，操作有误"];
        return;
    }else{
        [[UIApplication sharedApplication].delegate window].rootViewController = [[MainTabBarViewController alloc] init];
    }
}
/**
 *  登录
 *
 *  @param succes  登录成功后的操作，根据未登录和已登录做出改变
 *  @param account 用户信息
 */
+ (void)loginDoSomeThing:(loginSucces)succes WithAccount:(Account *)account{

    NSString *DDRGID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DDRGID"] length] > 0 ?
    [[NSUserDefaults standardUserDefaults] objectForKey:@"DDRGID"] : @"";
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    NSDictionary *dic = @{
                          @"loginName" : account.userName,
                          @"password"  : [account.passWord md5],
                          @"companyCode" : !account.shopNumber ? @"" : account.shopNumber,
                          @"regId"     : DDRGID,
                          @"clientRev":[HTHoldNullObj getValueWithUnCheakValue:currentVersion]
                          };
    [HTShareClass shareClass].storeStr = !account.shopNumber ? @"" : account.shopNumber;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middlePerson,loginUrl] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDic = json;
        if (![dataDic[@"state"] intValue]) {
            [MBProgressHUD showError:dataDic[@"msg"]];
            //        跳转登录界面
            if (![[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[HTLoginVienController class]]) {
                [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
            }
            return ;
        }
        [self holdLoginResultWithJson:json andAcount:account];
        [JMSGUser loginWithUsername:[json getStringWithKey:@"JMessageUserId"] password:[json getStringWithKey:@"JMessagePwd"] completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
            } else {
            }
        }];
        !succes ? : succes(json);
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del loadMemu];
    } error:^{
        [MBProgressHUD hideHUD];
        [JMSGUser logout:^(id resultObject, NSError *error) {
            if (!error) {
                //退出登录成功
            } else {
                //退出登录失败
            }
        }];
//        //        跳转登录界面
        if (![[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[HTLoginVienController class]]) {
            [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
        }
         [MBProgressHUD showError:@"服务器正忙"];
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
        [JMSGUser logout:^(id resultObject, NSError *error) {
            if (!error) {
                //退出登录成功
            } else {
                //退出登录失败
            }
        }];
        //        跳转登录界面
        if (![[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[HTLoginVienController class]]) {
            [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
        }
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}

/**
 *  应用从后台切换到前台来的操作
 *
 *  @param fail 登录失败后的操作
 */
+ (void)loginWillEnterForeground:(loginFail) fail Succes:(loginSucces) succes
{
    NSString *DDRGID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DDRGID"] length] > 0 ?
    [[NSUserDefaults standardUserDefaults] objectForKey:@"DDRGID"] : @"";
    //    取出用户信息
    Account *account = [self getAccout];
    if (account.passWord.length == 0 ) {
        return;
    }
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    NSDictionary *dic = @{
                          @"loginName" : account.userName ? account.userName : @"",
                          @"password"  : [account.passWord md5] ?  [account.passWord md5] :@"",
                          @"companyCode" : !account.shopNumber ? @"" : account.shopNumber,
                          @"regId"     : DDRGID,
                          @"clientRev":[HTHoldNullObj getValueWithUnCheakValue:currentVersion]
                          };
    [HTShareClass shareClass].storeStr = !account.shopNumber ? @"" : account.shopNumber;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middlePerson,loginUrl] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *dataDic = json;
        if (![dataDic[@"state"] intValue]) {
            [MBProgressHUD showError:dataDic[@"msg"]];
            !fail ? : fail();
            return ;
        }
        [self holdLoginResultWithJson:json andAcount:account];
        [JMSGUser loginWithUsername:[json getStringWithKey:@"JMessageUserId"] password:[json getStringWithKey:@"JMessagePwd"] completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
            } else {
                //                [MBProgressHUD showError:@"添加的用户不存在"];
            }
        }];
        !succes ? : succes(json);
        AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [del loadMemu];
    } error:^{
        [MBProgressHUD hideHUD];
        //        跳转登录界面
        if (![[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[HTLoginVienController class]]) {
            [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
        }
        [JMSGUser logout:^(id resultObject, NSError *error) {
            if (!error) {
                //退出登录成功
            } else {
                //退出登录失败
            }
        }];
        [MBProgressHUD showError:@"服务器繁忙"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JMSGUser logout:^(id resultObject, NSError *error) {
            if (!error) {
                //退出登录成功
            } else {
                //退出登录失败
            }
        }];
        //        跳转登录界面
        if (![[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[HTLoginVienController class]]) {
            [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
        }
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
//检查是否绑定微信
+(BOOL)cheackUnionId{
    if (![HTShareClass shareClass].loginModel.person.unionId ||[[HTShareClass shareClass].loginModel.person.unionId isNull]) {
        return NO;
    }else{
        return YES;
    }
}
////绑定微信

+(void)holdLoginResultWithJson:(id)json andAcount:(Account *)account{
    NSDictionary *dataDic = json;
    //        存储用户信息
    [[NSUserDefaults standardUserDefaults] setObject:account.userName forKey:@"DDNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:account.passWord forKey:@"DDPWD"];
    [[NSUserDefaults standardUserDefaults] setObject:account.shopNumber forKey:@"DDSNB"];
    //储存登陆记录
    NSMutableArray *shopNums = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DDSNBArr"] mutableCopy];
    if (!shopNums) {
        shopNums = [NSMutableArray array];
    }
    if (![shopNums containsObject:account.shopNumber]) {
        [shopNums addObject:account.shopNumber];
    }
    [[NSUserDefaults standardUserDefaults] setObject:shopNums forKey:@"DDSNBArr"];
    [[NSUserDefaults standardUserDefaults] setObject:dataDic[@"data"][@"loginId"] forKey:@"LoginUid"];
    //        单例纪录用户loginId
    [HTShareClass shareClass].loginId = [NSString stringWithFormat:@"%@",dataDic[@"data"][@"loginId"]];
    [HTShareClass shareClass].face = [dataDic[@"data"][@"face"] boolValue];
    [HTShareClass shareClass].hideVIPPhone = [dataDic[@"data"][@"hideVIPPhone"] boolValue];
    [HTShareClass shareClass].smsConfig = [dataDic[@"data"][@"smsConfig"] integerValue];
    if (([json[@"data"][@"company"][@"type" ] isEqualToString:@"SHOP"])) {
       [HTShareClass shareClass].isProductStockActive = [dataDic[@"data"][@"isProductStockActive"] boolValue];
       [HTShareClass shareClass].isProductActive = [dataDic[@"data"][@"isProductActive"] boolValue];
    }
    [HTShareClass shareClass].isBossProductStockActive = [dataDic[@"data"][@"isProductStockActive"] boolValue];
    [HTShareClass shareClass].isBossProductActive = [dataDic[@"data"][@"isProductActive"] boolValue];
    //        单例存储用户登录数据
    [[HTShareClass shareClass].loginModel setValuesForKeysWithDictionary:dataDic[@"data"]];
    [HTShareClass shareClass].isPlatformOnlinePayActive = [dataDic[@"data"][@"isPlatformOnlinePayActive"] boolValue];
    [HTShareClass shareClass].isGuide = [dataDic[@"data"][@"isGuide"] boolValue];//        单例储存是否隐藏二维码
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    NSString *str  =  [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //        本地版本号
    int      locationVersion = [str intValue];
    NSString *str1 = [json[@"app_version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    int       serverVersion  = [str1 intValue];
    if (locationVersion + 1 == serverVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isShowAliCode"];
        [HTShareClass shareClass].isShowAliCode = YES;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isShowAliCode"];
        [HTShareClass shareClass].isShowAliCode = NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ifShowGuideView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (locationVersion + 2 < serverVersion) {
        [HTShareClass shareClass].isUpdata = YES;
    }else{
        [HTShareClass shareClass].isUpdata      = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ifShowGuideView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[HTShareClass shareClass].reportWarnStandard setValuesForKeysWithDictionary:[json[@"data"] getDictionArrayWithKey:@"reportWarnStandard"]];
    [HTShareClass shareClass].JMessageUserId = [json getStringWithKey:@"JMessageUserId"];
    [HTShareClass shareClass].JMessagePwd = [json getStringWithKey:@"JMessagePwd"];
    
    for (UIWindow *win in [[UIApplication sharedApplication] windows]) {
        for (UIView *temp in win.subviews) {
            for (UIView *temp2 in temp.subviews) {
                for (UIView *temp3 in temp2.subviews) {
                    if ([temp3 isKindOfClass:[KLCPopup class]]) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ifShowGuideView"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([temp2 isKindOfClass:[KLCPopup class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ifShowGuideView"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if ([temp isKindOfClass:[KLCPopup class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ifShowGuideView"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    NSString *ifShowGuideView = [[NSUserDefaults standardUserDefaults] objectForKey:@"ifShowGuideView"];
    if ([HTShareClass shareClass].isUpdata && ![ifShowGuideView isEqualToString:@"0"]) {
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"检查到新版本，请及时更新" btTitle:@"更新" okBtclicked:^{
            NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/24xiao-zhu-shou/id1100109709?l=zh&ls=1&mt=8" ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        [alert notTochShow];

        
    }

}
@end

