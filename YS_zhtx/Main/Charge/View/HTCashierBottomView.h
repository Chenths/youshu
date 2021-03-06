//
//  HTCashierBottomView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustModel.h"
#import <UIKit/UIKit.h>

@protocol HTCashierBottomViewDelegate<NSObject>

-(void)vipBtclicked;

-(void)settlerClicked;

@end

@interface HTCashierBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *settelBt;

@property (weak, nonatomic) IBOutlet UIButton *vipBt;

@property (nonatomic,strong) HTCustModel *custModel;

@property (nonatomic,weak) id <HTCashierBottomViewDelegate> delegate;

@property (nonatomic,strong) NSString *finallPrice;

@property (nonatomic,strong) NSString *totlePrice;

@property (nonatomic,strong) NSString *productNum;


@end
