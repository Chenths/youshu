//
//  HTCustomDefualAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^cancleBtClick)(void);
typedef void(^okBtClick)(void);
#import <UIKit/UIKit.h>

@interface HTCustomDefualAlertView : UIView
-(instancetype)initAlertWithTitle:(NSString *)title btsArray:(NSArray *)btTitles okBtclicked:(okBtClick) ok cancelClicked:(cancleBtClick) cancel;


-(instancetype)initAlertWithTitle:(NSString *)title btTitle:(NSString *)btTitle okBtclicked:(okBtClick) ok ;


-(void)notTochShow;

-(void)show;
@end
