//
//  HTNewCustomerBaceInfoView.h
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
@class HTCahargeProductModel;
@protocol  HTCashierChooseSizeOrColorViewDelegate<NSObject>
- (void)dismissAlertViewFromBigView:(UIView *)alertView;
- (void)stroeMoneyClicked;
-(void)okBtClickWithProduct:(HTCahargeProductModel *)model;
-(void)delClickWithProduct:(HTCahargeProductModel *)model;

@end
//#import "HTDataCust.h"
#import <UIKit/UIKit.h>
#import "HTCahargeProductModel.h"

@interface HTCashierChooseSizeOrColorView : UIView

@property (nonatomic,weak) id <HTCashierChooseSizeOrColorViewDelegate> delegate;

+ (void)showAlertViewInView:(UIView *)bigView andDelegate:(id<HTCashierChooseSizeOrColorViewDelegate>)delegate withGoodData:(HTCahargeProductModel*) productModel;
- (void) tapCoverView;
@end

