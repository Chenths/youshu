//
//  HTCompareHeadView.h
//  有术
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossHeadModel.h"
#import <UIKit/UIKit.h>

@protocol  HTCompareHeadViewDeleage<NSObject>

-(void)topClicked;

-(void)bottomClicked;

@end


@interface HTCompareHeadView : UIView

- (instancetype)initWithHeadFrame:(CGRect)frame;

@property (nonatomic,strong) HTBossHeadModel *model;

@property (nonatomic,weak) id <HTCompareHeadViewDeleage> delegate;

@end
