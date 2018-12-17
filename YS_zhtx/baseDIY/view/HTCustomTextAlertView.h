//
//  HTCustomTextAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancleBtClick)(void);
typedef void(^OkBtClick)(NSString *);
@interface HTCustomTextAlertView : UIView


+(void)showAlertWithTitle:(NSString *)title  holdTitle:(NSString *)hold orTextString:(NSString *)textStr okBtclicked:(OkBtClick)ok andCancleBtClicked:(CancleBtClick) cancel ;

@end
