//
//  HTYearSaleDescTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTYearSaleDescTableViewCell.h"

#define thinWidth 5

#define strongWidth 5

#define layerRadius 54 * 0.5

@interface HTYearSaleDescTableViewCell(){
    UIBezierPath *bPath;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *finallPrice;

@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UILabel *orderAndProductCount;

@property (weak, nonatomic) IBOutlet UILabel *finshPresent;

@property (weak, nonatomic) IBOutlet UIView *circleBack;

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end
@implementation HTYearSaleDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBaceShapeLayer];
    [self configShapeLayer];
}
-(void)createBaceShapeLayer{
    UIBezierPath *bPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(layerRadius , layerRadius) radius:layerRadius startAngle:0 endAngle:360 clockwise:YES];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.lineWidth = strongWidth;
    shaperLayer.strokeColor = [UIColor colorWithHexString:@"#E6E8EC"].CGColor;
    shaperLayer.fillColor = nil;
    shaperLayer.path = bPath1.CGPath;
    [self.circleBack.layer addSublayer:shaperLayer];
}
- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = thinWidth;
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = [UIColor colorWithHexString:@"#3F3D47"].CGColor;
    [self.circleBack.layer addSublayer:_shapeLayer];
}
-(void)createCircleWithIp:(int) upOrDow{
    int absup = abs(upOrDow);
    CGFloat s = M_PI * -0.5;
    CGFloat e =  M_PI * 1.5 ;
    if (upOrDow >= 0) {
        CGFloat holf = 2 * M_PI * absup / 100;
        e = s + holf;
        e = e >=  2 * M_PI ? e - 2 * M_PI : e   ;
    }else{
        CGFloat holf = 2 * M_PI * absup / 100;
        e  = s - holf;
        if (e >= 0) {
        }else{
            e = 2 * M_PI + e ;
        }
    }
    bPath = [[UIBezierPath alloc] init];
    [bPath addArcWithCenter:CGPointMake(layerRadius , layerRadius )
                     radius:layerRadius
                 startAngle:s
                   endAngle:e
                  clockwise: upOrDow >= 0 ?  YES : NO];
    _shapeLayer.path = bPath.CGPath;
}
-(void)setModel:(HTGuiderYearItmeModel *)model{
    _model = model;
    self.dateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.date];
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.amount]];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalprice]];
    self.orderAndProductCount.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.count],[HTHoldNullObj getValueWithUnCheakValue:model.volume]];
    self.finshPresent.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithUnCheakValue:model.completion],@"%"];
    [self createCircleWithIp:model.completion.intValue];
}

@end
