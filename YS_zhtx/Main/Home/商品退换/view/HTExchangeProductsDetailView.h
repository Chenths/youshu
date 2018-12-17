//
//  HTExchangeProductsDetailView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTExchangeProductsDetailView : UIView

- (instancetype)initWithAlertFrame:(CGRect)frame;

-(void)show;

@property (nonatomic,strong) NSArray *exchangeProducts;


@end
