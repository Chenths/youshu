//
//  HTBuyHabitInfoCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define thinWidth 5

#define strongWidth 5

#define layerRadius 82 * 0.5
#import "HTBuyHabitInfoCollectionCell.h"
@interface HTBuyHabitInfoCollectionCell(){
    UIBezierPath *bPath;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *presentLabel;

@property (weak, nonatomic) IBOutlet UILabel *bigPresentLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTitlte;

@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *valuePresent;
@property (weak, nonatomic) IBOutlet UILabel *value1Title;
@property (weak, nonatomic) IBOutlet UIView *circleView;

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (weak, nonatomic) IBOutlet UIView *contentBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondBottomHeight;
@property (weak, nonatomic) IBOutlet UIView *secondLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTop;
@property (weak, nonatomic) IBOutlet UIView *firstLine;

@end
@implementation HTBuyHabitInfoCollectionCell

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
    [self.circleView.layer addSublayer:shaperLayer];
}
- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = thinWidth;
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = [UIColor colorWithHexString:@"#3F3D47"].CGColor;
    [self.circleView.layer addSublayer:_shapeLayer];
}
-(void)createCircleWithIp:(int) upOrDow{
    int absup = abs(upOrDow);
    CGFloat s = M_PI * -0.5;
    CGFloat e =  M_PI * 1.5 ;
    if (upOrDow >= 0) {
        CGFloat holf = 2 * M_PI * absup / 100;
        e = e + holf;
        e = e >=  2 * M_PI ? e - 2 * M_PI : e   ;
    }else{
        CGFloat holf = 2 * M_PI * absup / 100;
        e  = e - holf;
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
-(void)setModel:(HTPiesModel *)model{
    _model = model;
    self.shapeLayer.strokeColor = self.pieColor.CGColor;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    if (self.model.data.count > 0) {
        HTPieDataItem *item = [self.model.data firstObject];
        self.bigPresentLabel.text = item.name;
        self.presentLabel.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:item.data],@"%"];
        [self createCircleWithIp:item.data.intValue];
    }
    self.firstTitlte.text = @"无数据";
    self.secondTitle.text = @"无数据";
    self.valuePresent.hidden = YES;
    self.value1Title.hidden = YES;
    if (self.model.data.count > 1) {
        HTPieDataItem *item = self.model.data[1];
        self.valuePresent.hidden = NO;
        self.firstTitlte.text = item.name;
        self.valuePresent.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:item.data],@"%"];
    }
    if (self.model.data.count > 2) {
        HTPieDataItem *item = self.model.data[2];
        self.value1Title.hidden = NO;
        self.secondTitle.text = item.name;
        self.value1Title.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:item.data],@"%"];
    }
}

@end
