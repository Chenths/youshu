//
//  UIView+layerMaker.m
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "UIView+layerMaker.h"

@implementation UIView (layerMaker)

-(void)changeCornerRadiusWithRadius:(CGFloat)radius{
    self.layer.cornerRadius  = radius;
    self.layer.masksToBounds = YES;
}
-(void)changeBorderStyleColor:(UIColor *)color withWidth:(CGFloat)width{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}
-(void)setGradientColorWithBeginColor:(UIColor *)beginColor beginPoint:(CGPoint) begin  andEndColor:(UIColor *)endColor endPoint:(CGPoint) end{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)beginColor.CGColor,
                       (id)endColor.CGColor,nil];
    gradient.startPoint = begin;
    gradient.endPoint = end;
    [self.layer addSublayer:gradient];
    [self.layer insertSublayer:gradient atIndex:0];
}
@end
