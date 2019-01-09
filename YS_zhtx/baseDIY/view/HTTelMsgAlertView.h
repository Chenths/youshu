//
//  HTTelMsgAlertView.h
//  有术
//
//  Created by mac on 2018/10/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^okBtClick)(void);
#import <UIKit/UIKit.h>

@interface HTTelMsgAlertView : UIView

+(void)showAlertWithName:(NSString *)customerName andPhone:(NSString *)phone andCustomerId:(NSString *)customerId andOkBt:(okBtClick) ok;


@end
