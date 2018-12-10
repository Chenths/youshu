//
//  HTSaleGoodOrBadCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#define thinWidth 6

#define strongWidth 6

#define layerRadius 60 * 0.5
#import "HTSaleGoodOrBadCell.h"
#import "PNCircleChart.h"
@interface HTSaleGoodOrBadCell(){
    UIBezierPath *bPath;
}

@property (weak, nonatomic) IBOutlet UILabel *styleCodeAndColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UILabel *storeNum;
@property (weak, nonatomic) IBOutlet UIView *circleBackView;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;

@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (weak, nonatomic) IBOutlet UIView *backView2;

@end
@implementation HTSaleGoodOrBadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backView1 changeCornerRadiusWithRadius:3];
    [self.backView1 changeBorderStyleColor:[UIColor colorWithHexString:@"#E6E8EC"] withWidth:1];
    
    [self.backView2 changeCornerRadiusWithRadius:3];
    [self.backView2 changeBorderStyleColor:[UIColor colorWithHexString:@"#E6E8EC"] withWidth:1];

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
    [self.circleBackView.layer addSublayer:shaperLayer];
}
- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = thinWidth;
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = [UIColor colorWithHexString:@"#3F3D47"].CGColor;
    [self.circleBackView.layer addSublayer:_shapeLayer];
}
-(void)createCircleWithIp:(int) upOrDow{
    int absup = abs(upOrDow);
    CGFloat s = -M_PI * 0.5;
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
            e = 2 * M_PI + s ;
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
-(void)setModel:(HTStackSaleProductModel *)model{
    _model = model;
    self.styleCodeAndColorLabel.text = [NSString stringWithFormat:@"%@/%@",[HTHoldNullObj getValueWithUnCheakValue:model.styleCode],[HTHoldNullObj getValueWithUnCheakValue:model.color]];
    self.dateLabel.text  = [NSString stringWithFormat:@"入库时间：%@",model.startSaleDate];
    self.saleNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.saleCount];
    self.storeNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.crtStock];
    int i =  model.sellRate.floatValue * 100;
    [self createCircleWithIp: i];
    self.presentLabel.text = [NSString stringWithFormat:@"%.2lf%@",(model.sellRate.floatValue * 100),@"%"];
}

@end
