//
//  UIView+layerMaker.h
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (layerMaker)


-(void)changeCornerRadiusWithRadius:(CGFloat )radius;

-(void)changeBorderStyleColor:(UIColor *)color withWidth:(CGFloat)width;

-(void)setGradientColorWithBeginColor:(UIColor *)beginColor beginPoint:(CGPoint) begin  andEndColor:(UIColor *)endColor endPoint:(CGPoint) end;
@end
