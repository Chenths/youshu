//
//  HTUnderstockListAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^cancleBtClick)(void);
typedef void(^okBtClick)(void);

typedef void(^indexClick)(NSIndexPath *index);

#import <UIKit/UIKit.h>

@interface HTUnderstockListAlertView : UIView


+(void)showAlertWithDataArray:(NSArray *)products btsArray:(NSArray *)btTitles okBtclicked:(okBtClick) ok cancelClicked:(cancleBtClick) cancel;


+(void)showAlertWithWarningArray:(NSArray *)warns tilte:(NSString *)title btsArray:(NSArray *)btTitles okBtclicked:(okBtClick) ok cancelClicked:(cancleBtClick) cancel andInClick:(indexClick) indexclick;


@end
