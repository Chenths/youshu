//
//  HTBossSelectedShopView.h
//  有术
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTBossSelectedShopViewDelegate

- (void) selectedShopOkBtClicked;

@end

@interface HTBossSelectedShopView : UIView
- (instancetype)initWithAlertFrame:(CGRect)frame;

@property (nonatomic,strong)  NSMutableArray *dataArray;

@property (nonatomic,weak) id <HTBossSelectedShopViewDelegate> delegate;

@end
