//
//  HTCustomColAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/9/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^cancleBtClick)(void);
typedef void(^okBtClick)(void);
typedef void(^addBtClick)(NSInteger index);
#import <UIKit/UIKit.h>

@interface HTCustomColAlertView : UIView




+(void)showAlertWithDataArray:(NSArray *)products btsArray:(NSArray *)btTitles okBtclicked:(okBtClick) ok cancelClicked:(cancleBtClick) cancel  addImgCliked:(addBtClick) addClicked;

@end
