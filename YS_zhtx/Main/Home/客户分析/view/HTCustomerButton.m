//
//  HTCustomerButton.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define cirRadio 3
#define lineW 16
#define bordWidth 1.0f

#import "HTCustomerButton.h"

@implementation HTCustomerButton

- (instancetype)initCustomerWithFrame:(CGRect)frame andColor:(UIColor *)bordColor
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = bordColor;
        CAShapeLayer *triangleLayer = [CAShapeLayer layer];
        triangleLayer.strokeColor = color.CGColor;
        triangleLayer.fillColor = nil;
        triangleLayer.lineWidth = bordWidth;
        
        CGPoint tmpPoint0 = CGPointMake(self.width - cirRadio, self.height);
        CGPoint tmpPoint1 = CGPointMake(lineW, self.height);
        CGPoint tmpPoint2 = CGPointMake(0, self.height *0.5);
        CGPoint tmpPoint3 = CGPointMake(lineW, 0);
        CGPoint tmpPoint4 = CGPointMake(self.width - cirRadio, 0);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint: tmpPoint0];
        [path addLineToPoint: tmpPoint1];
        [path addLineToPoint: tmpPoint2];
        [path addLineToPoint: tmpPoint3];
        [path addLineToPoint: tmpPoint4];
//        [path closePath];//闭合曲线
        triangleLayer.path = path.CGPath;
        [self.layer addSublayer:triangleLayer];
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.strokeColor = color.CGColor;
        circleLayer.fillColor = nil;
        circleLayer.lineWidth = bordWidth;
        
        circleLayer.path = ([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width - cirRadio, cirRadio) radius:cirRadio startAngle:M_PI * 1.5 endAngle:2*M_PI clockwise:YES]).CGPath;
        [self.layer addSublayer:circleLayer];

        CAShapeLayer *triangleLayer1 = [CAShapeLayer layer];
        triangleLayer1.strokeColor = color.CGColor;
        triangleLayer1.fillColor = nil;
        triangleLayer1.lineWidth = bordWidth;
        
        CGPoint tmpPoint00 = CGPointMake(self.width, cirRadio);
        CGPoint tmpPoint10 = CGPointMake(self.width, self.height - cirRadio);
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint: tmpPoint00];
        [path1 addLineToPoint: tmpPoint10];
        triangleLayer1.path = path1.CGPath;
        [self.layer addSublayer:triangleLayer1];
        
        CAShapeLayer *circleLayer1 = [CAShapeLayer layer];
        circleLayer1.strokeColor = color.CGColor;
        circleLayer1.fillColor = nil;
        circleLayer1.lineWidth = bordWidth;
        
        circleLayer1.path = ([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width - cirRadio,self.height - cirRadio) radius:cirRadio startAngle:0 endAngle:0.5*M_PI clockwise:YES]).CGPath;
        [self.layer addSublayer:circleLayer1];
    }
    return self;
}
@end
