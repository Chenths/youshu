//
//  HTAccountTool.h
//  shengyijing
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
typedef void(^loginSucces)(id json);
typedef void(^loginFail)();
@interface HTAccountTool : NSObject {
    Account *_userAccout;
}
/**
 *  是否已经登陆过
 *
 *  @return 是否登录
 */
+ (BOOL)isLogined;

/**
 *  退出登录
 *
 */
+ (void)exitLogin;
/**
 *  控制器跳转
 */
+ (void)choiceVC;

+ (void) shareSdkSet;

+(BOOL)cheackUnionId;

+ (void) createViewControllerWithjson:(id)json;

+ (void)bindWeChat;


+ (void)loginDoSomeThing:(loginSucces) succes WithAccount:(Account *)account;

+ (void)loginWillEnterForeground:(loginFail) fail Succes:(loginSucces) succes;

@end
