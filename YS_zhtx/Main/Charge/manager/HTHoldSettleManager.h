//
//  HTHoldSettleManager.h
//  YS_zhtx
//
//  Created by mac on 2018/8/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^Succes)(id json);

typedef void(^Erro)(void);

#import <Foundation/Foundation.h>

@interface HTHoldSettleManager : NSObject

/**
 根据字符串创建的二维码图片

 @param value 二维码的值
 @return 二维码图片
 */
+ (UIImage *)createCodeImageWithValue:(NSString *) value;

/**
 储值支付

 @param posDic 请求的数据
 @param succes 成功回调
 */
+(void)storedPayWithPosDic:(NSDictionary *)posDic andSucces:(Succes) succes severError:(Erro)severError andError:(Erro) error ;

/**
 现金支付及刷卡支付

 @param posDic 请求的数据
 @param succes 成功的回调
 */
+(void)caishPayWithPosDic:(NSDictionary *)posDic andSucces:(Succes) succes severError:(Erro)severError andError:(Erro) error ;

/**
 店铺支付宝及微信支付

 @param posDic 请求的数据
 @param succes 成功的回调
 */
+(void)shopAliOrWechatPayWithPosDic:(NSDictionary *)posDic Succes:(Succes) succes severError:(Erro)severError andError:(Erro) error ;

/**
 刷新店铺及微信扫码支付
 
 @param posDic 请求的数据
 @param succes 成功的回调
 */
+(void)refreshAliOrWechatPayWithPosDic:(NSDictionary *)posDic Succes:(Succes) succes severError:(Erro)severError andError:(Erro) error ;

/**
 取消或关闭订单

 @param posDic 请求数据parma
 @param succes 成功的操作
 @param severError 服务器错误的处理
 @param error 网络错误的处理
 */
+(void)cancelOrCloseOrderWithPosDic:(NSDictionary *)posDic Succes:(Succes) succes severError:(Erro)severError andError:(Erro) error ;

@end
