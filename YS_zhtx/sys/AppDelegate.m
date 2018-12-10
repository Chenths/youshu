//
//  AppDelegate.m
//  YOUSHU_zhtx
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTFaceComingAlertView.h"
#import "JKNotifier.h"
#import "HTAccountTool.h"
#import "HTMenuModle.h"
#import "AppDelegate.h"
#import <JMessage/JMessage.h>
#import "HTFaceVipModel.h"
#import "HTLoginVienController.h"
#import "JCHATConversationViewController.h"
#import "HTJumpTools.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "IQKeyboardManager.h"
#import "HTBaceNavigationController.h"

static NSString *appKey = @"5094545990eb415462160e31";
static NSString *channel = @"App Store";
#ifndef __OPTIMIZE__
//这里执行的是debug模式下
static BOOL isProduction = YES ;
#else
static BOOL isProduction = YES;
#endif
@interface AppDelegate ()<JMessageDelegate,JPUSHRegisterDelegate>
{
    BOOL isfirst;
    BOOL isPushMessage;
}

@property (nonatomic,strong) NSString *messageContent;

@property (nonatomic,assign)  BOOL isLaunchedByNotification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *remoteNotification = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (remoteNotification != nil) {
        self.isLaunchedByNotification = YES;
    }else{
        self.isLaunchedByNotification = NO;
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UIViewController alloc] init];
    [HTAccountTool choiceVC];
    [HTAccountTool shareSdkSet];
    [self configScrollViewAdapt4IOS11];//适配iOS 11
    [self configJPushWith:launchOptions and:application];
    [self configJMsgWith:launchOptions];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    return YES;
}
-(void)applicationDidBecomeActive:(UIApplication *)application{
   
}
//配置极光推送
-(void)configJPushWith:(NSDictionary *)launchOptions and:(UIApplication *)application {
    
      NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidLoginMessage:) name:kJPFNetworkDidLoginNotification object:nil];
    
    application.applicationIconBadgeNumber = 0 ;
    [JPUSHService setBadge:application.applicationIconBadgeNumber];
}
//配置极光im
-(void)configJMsgWith:(NSDictionary *)launchOptions{
    [JMessage addDelegate:self withConversation:nil];
  
    //Required
    [JMessage setupJMessage:launchOptions
                     appKey:appKey
                    channel:channel
           apsForProduction:NO
                   category:nil
             messageRoaming:YES];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    }
     [JMessage resetBadge];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    isfirst = YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (isfirst) {
        [HTAccountTool loginWillEnterForeground:^{
            [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
        } Succes:^(id json) {
        }];
    }
     isfirst = NO;
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    //    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginId].length == 0 ||![HTShareClass shareClass].loginId) {
        return;
    }
    if ([[userInfo getStringWithKey:@"_j_type"] isEqualToString:@"jmessage"]) {
        if([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
            isPushMessage = YES;
        }
        self.messageContent =  userInfo[@"aps"][@"alert"];
        return;
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
#warning 请求未读数量
            if ([[userInfo getStringWithKey:@"type"] isEqualToString:@"VIP_REPORT"]) {
                [self loadFaceDataWithModelId:userInfo];
            }
            [JKNotifier showNotifer:userInfo[@"aps"][@"alert"]];
            [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
                [HTShareClass shareClass].badge = [NSString stringWithFormat:@"%d",(int)[[HTShareClass shareClass].badge integerValue] - 1 ];
                [HTShareClass shareClass].jumpType = userInfo[@"type"];
                [HTShareClass shareClass].jumpDic  = userInfo;
                [notifier dismiss];
                [HTJumpTools jumpWithStr:[HTShareClass shareClass].jumpType withDic:[HTShareClass shareClass].jumpDic];
            }];
        }else{
//            跳转相关推送页面
            [HTShareClass shareClass].jumpType = userInfo[@"type"];
            [HTShareClass shareClass].jumpDic  = userInfo;
            if ( [UIApplication sharedApplication].applicationIconBadgeNumber > 0 ) {
                [UIApplication sharedApplication].applicationIconBadgeNumber--;
                [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
            }
            if (self.isLaunchedByNotification) {
            }else{
                [HTJumpTools jumpWithStr:[HTShareClass shareClass].jumpType withDic:[HTShareClass shareClass].jumpDic];
            }
//
        }
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

//
//// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    [JMessage registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    //    NSString *jsonStr = [userInfo getStringWithKey:@"noticeParams"];
    
    //    NSDictionary *paramsDic = [jsonStr dictionaryWithJsonString];
    if ([NSString stringWithFormat:@"%@",[HTShareClass shareClass].loginId].length == 0||![HTShareClass shareClass].loginId) {
        return;
    }
    if ([[userInfo getStringWithKey:@"_j_type"] isEqualToString:@"jmessage"]) {
        if (application.applicationState != UIApplicationStateActive) {
            isPushMessage = YES;
        }
        self.messageContent =  userInfo[@"aps"][@"alert"];
        return;
    }
    
    if (application.applicationState == UIApplicationStateActive) {
#warning 加载未读消息
        if ([[userInfo getStringWithKey:@"type"] isEqualToString:@"VIP_REPORT"]) {
//          人脸识别
            [self loadFaceDataWithModelId:userInfo];
        }
        [JKNotifier showNotifer:userInfo[@"aps"][@"alert"]];
        [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
            [HTShareClass shareClass].badge = [NSString stringWithFormat:@"%d",(int)[[HTShareClass shareClass].badge integerValue] - 1 ];
            [HTShareClass shareClass].jumpType = userInfo[@"type"];
            [HTShareClass shareClass].jumpDic  = userInfo;
            [notifier dismiss];
            [HTJumpTools jumpWithStr:[HTShareClass shareClass].jumpType withDic:[HTShareClass shareClass].jumpDic];
        }];
    }else{
        [HTShareClass shareClass].jumpType = userInfo[@"type"];
        [HTShareClass shareClass].jumpDic  = userInfo;
        if ( application.applicationIconBadgeNumber > 0 ) {
            application.applicationIconBadgeNumber--;
            [JPUSHService setBadge:application.applicationIconBadgeNumber];
        }
        if (self.isLaunchedByNotification) {
        }else{
            [HTJumpTools jumpWithStr:[HTShareClass shareClass].jumpType withDic:[HTShareClass shareClass].jumpDic];
        }
    }
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)configScrollViewAdapt4IOS11{
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
}

// 推送
//通知方法
- (void)networkDidLoginMessage:(NSNotification *)notification {
    
    //调用接口
    
    if ([JPUSHService registrationID]) {
        [[NSUserDefaults standardUserDefaults] setObject:[JPUSHService registrationID]forKey:@"DDRGID"];
        
        [HTAccountTool loginWillEnterForeground:^{
            //        跳转登录界面
            [[UIApplication sharedApplication].delegate window].rootViewController = [[HTLoginVienController alloc] init];
            
        } Succes:^(id json){
            if ([baseUrl isEqualToString:@"http://59.110.5.160:8090/"]) {
                [JPUSHService setAlias:[HTShareClass shareClass].loginId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                } seq:1];
            }else{
                NSArray *obj = @[@"Developer"];
                [JPUSHService setTags:[NSSet setWithArray:obj] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                } seq:1];
                [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",@"Developer",[HTShareClass shareClass].loginId] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                } seq:1];
            }
        }];
    }
    //通知后台registrationID
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}

-(void)loadMemu{
    NSDictionary *dic = @{
                          @"companyId" : [HTShareClass shareClass].loginModel.companyId
                          };
    NSMutableArray *_dataArray = [NSMutableArray array];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadMenu] params:dic success:^(id json) {
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSDictionary *dic in json[@"data"][@"menu"]) {
            HTMenuModle *model = [[HTMenuModle alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [arr addObject:model];
            [_dataArray addObject:model];
        }
        [HTShareClass shareClass].menuArray = arr;
    } error:^{
    } failure:^(NSError *error) {
    }];
}


- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        HTBaceNavigationController *mainNav = (id)[[HTShareClass shareClass] getCurrentNavController];
        if (![[mainNav.viewControllers lastObject] isKindOfClass:[JCHATConversationViewController class]]&&![[HTShareClass shareClass].msgConversation isMessageForThisConversation:message] ) {
            [JKNotifier showNotifer:@"收到一条新消息"];
            [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
                JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
                JMSGConversation *conver =  [JMSGConversation singleConversationWithUsername:message.otherSide];
                sendMessageCtl.conversation = conver;
                [[HTShareClass shareClass].getCurrentNavController pushViewController:sendMessageCtl animated:YES];
                [notifier dismiss];
            }];
        }
    }else{
        if (isPushMessage) {
            isPushMessage = NO;
            JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
            JMSGConversation *conver =  [JMSGConversation singleConversationWithUsername:message.otherSide];
            sendMessageCtl.conversation = conver;
            [[HTShareClass shareClass].getCurrentNavController pushViewController:sendMessageCtl animated:YES];
        }
    }
}

-(void)loadFaceDataWithModelId:(NSDictionary *)userInfo{
    
    NSString *noticeParams = [userInfo getStringWithKey:@"noticeParams"];
    NSArray *keys = [noticeParams componentsSeparatedByString:@"^"];
    NSMutableArray *arr = [HTShareClass shareClass].faceArray;
    HTFaceVipModel *model = [[HTFaceVipModel alloc] init];
    if (keys.count == 6) {
        model.path = [HTHoldNullObj getValueWithUnCheakValue:keys[0]];
        model.nickname_cust = keys[1];
        model.hasbuy = [keys[2] boolValue];
        model.cust_level = @{
                             @"name":keys[3]
                             };
        model.sex_cust = [keys[4] boolValue];
        model.birth = [NSString stringWithFormat:@"%@-01-01",keys[5]];
    }
    model.uid = [userInfo getStringWithKey:@"modelId"];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"HH:mm:ss"];
    model.create_time =  [formate stringFromDate:[NSDate date]];
    model.isPush = YES;
    if (arr.count < 2) {
        [arr addObject:model];
    }else{
        [arr removeObjectAtIndex:0];
        [arr addObject:model];
    }
    for (UIView *vvv in self.window.subviews) {
        if ([vvv isKindOfClass:[HTFaceComingAlertView class]]) {
            [vvv removeFromSuperview];
        }
    }
    [HTFaceComingAlertView showWithDatas:arr];
}


@end

