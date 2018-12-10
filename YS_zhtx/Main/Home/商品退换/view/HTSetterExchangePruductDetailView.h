//
//  HTSetterExchangePruductDetailView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTSetterExchangePruductDetailViewDelegate <NSObject>

-(void)coloseBtClicekd;

@end
@interface HTSetterExchangePruductDetailView : UIView

- (instancetype)initWithDetailFrame:(CGRect)frame;


@property (nonatomic,strong) NSArray *returnProducts;

@property (nonatomic,strong) NSArray *changeProducts;

@property (nonatomic,strong) NSString *orderPrice;

@property (nonatomic,weak) id <HTSetterExchangePruductDetailViewDelegate> delegate;

@end
