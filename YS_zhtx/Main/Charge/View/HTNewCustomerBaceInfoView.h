//
//  HTNewCustomerBaceInfoView.h
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
@protocol  HTNewCustomerBaceInfoViewDelegate<NSObject>
- (void)dismissAlertViewFromBigView:(UIView *)alertView;
- (void)stroeMoneyClicked;
@end
//#import "HTDataCust.h"
#import "HTCustModel.h"
#import <UIKit/UIKit.h>

@interface HTNewCustomerBaceInfoView : UIView

@property (nonatomic,weak) id <HTNewCustomerBaceInfoViewDelegate> delegate;

+ (instancetype)showAlertViewInView:(UIView *)bigView andDelegate:(id<HTNewCustomerBaceInfoViewDelegate>)delegate  withCustData:(HTCustModel *) custData;
- (void) tapCoverView;
@end
