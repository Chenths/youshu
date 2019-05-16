//
//  HTShopInfoCell.m
//  有术
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTShopInfoCell.h"
@interface HTShopInfoCell(){
    UIBezierPath *bPath;
}
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (weak, nonatomic) IBOutlet UILabel *upOrDownPresentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lirunLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upOrDownImg;
@property (weak, nonatomic) IBOutlet UIView *circleBackView;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) CADisplayLink *displayLink;

@property (weak, nonatomic) IBOutlet UILabel *todaySaleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleNumOrCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSaleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSaleNumOrCountLabel;


@property (nonatomic,strong) NSString *up;

@end
@implementation HTShopInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *bPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(HMSCREENWIDTH - 42 - 10, 68.0) radius:84 * 0.5 startAngle:0 endAngle:360 clockwise:YES];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.lineWidth = 4;
    shaperLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shaperLayer.fillColor = nil;
    shaperLayer.path = bPath1.CGPath;
    [self.layer addSublayer:shaperLayer];
    // 配置CAShapeLayer
    [self configShapeLayer];
    
    self.discountLabel.layer.borderWidth = 0.5;
    self.discountLabel.layer.borderColor = [UIColor colorWithHexString:@"#F77106"].CGColor;
    self.discountLabel.textColor = [UIColor colorWithHexString:@"#F77106"];
    
 
    
}
- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 4;
    
    _shapeLayer.fillColor = nil;
    [self.layer addSublayer:_shapeLayer];
}

- (void)setModel:(HTSingleShopDataModel *)model{
    _model = model;
    if ([[HTHoldNullObj getValueWithUnCheakValue:model.max] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:model.min]] && [[HTHoldNullObj getValueWithUnCheakValue:model.max] isEqualToString:@"0"] ) {
        self.holdLabel.hidden = YES;
    }else if ([[HTHoldNullObj getValueWithUnCheakValue:model.max] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:model.profit]]){
        self.holdLabel.hidden = NO;
        self.holdLabel.text = @"利润最高";
        self.holdLabel.layer.borderWidth = 0.5;
        self.holdLabel.layer.borderColor = [UIColor colorWithHexString:@"#59B4A5"].CGColor;
        self.holdLabel.textColor = [UIColor colorWithHexString:@"#59B4A5"];
    }else if ([[HTHoldNullObj getValueWithUnCheakValue:model.min] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:model.profit]]){
        self.holdLabel.hidden = NO;
        self.holdLabel.text = @"利润最低";
        self.holdLabel.layer.borderWidth = 0.5;
        self.holdLabel.layer.borderColor = [UIColor colorWithHexString:@"#FC5C7D"].CGColor;
        self.holdLabel.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }else{
        self.holdLabel.hidden = YES;
    }
//    店铺名
    self.shopNameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.merchantName];
//    今日营业额
    self.todaySaleAmountLabel.text = [NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.todaySalesAmount]];
//    今日单量件数
    self.todaySaleNumOrCountLabel.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.todaySalesOrders],[HTHoldNullObj getValueWithUnCheakValue:model.todaySalesNum]];
    //    本月营业额
    self.monthSaleAmountLabel.text = [NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.salesAmount]];
    //    本月单量件数
    self.monthSaleNumOrCountLabel.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.salesOrders],[HTHoldNullObj getValueWithUnCheakValue:model.salesNum]];
//    折扣
    self.discountLabel.text =[NSString stringWithFormat:@"%@" ,_model.discount.floatValue == 0 ? @"月平均10折" : _model.discount.floatValue < 0 ? @"月平均／折" : [NSString stringWithFormat:@"月平均%@折",[HTHoldNullObj getValueWithUnCheakValue:model.discount]]];
//单量
//    利润
    self.lirunLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:model.profit] isEqualToString:@"0"] ? @"无数据" : [HTHoldNullObj getValueWithUnCheakValue:model.profit]  ;
//上升下降比例
    self.upOrDownPresentLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[NSString stringWithFormat:@"%.2lf%@",fabsf([model.up floatValue]),@"%"]];
    self.upOrDownImg.hidden = NO;
    self.upOrDownPresentLabel.hidden = NO;
    
    if (![[HTHoldNullObj getValueWithUnCheakValue:model.up] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue:self.up]]) {
        [self createCircleWithIp:model.up.intValue];
        self.up = model.up;
    }
    
    if (model.up.intValue > 0) {
        self.upOrDownImg.image = [UIImage imageNamed:@"上升"];
        _shapeLayer.strokeColor = [UIColor colorWithHexString:@"#6A82FB"].CGColor;
        _lirunLabel.hidden = YES;
    }else if(model.up.intValue < 0){
        self.upOrDownImg.image = [UIImage imageNamed:@"下降"];
        _shapeLayer.strokeColor = [UIColor colorWithHexString:@"#FC5C7D"].CGColor;
        _lirunLabel.hidden = YES;
    }else{
        self.upOrDownImg.hidden = YES;
        self.upOrDownPresentLabel.hidden = YES;
        _lirunLabel.hidden = NO;
        _lirunLabel.text = @"无数据";
        
    }
    _discountLabel.hidden = YES;
    _holdLabel.hidden = YES;
}
-(void)createCircle{
    [self createCircleWithIp:self.model.up.intValue];
}
-(void)createCircleWithIp:(int) upOrDow{

    int absup = abs(upOrDow);
    CGFloat s =  M_PI * -0.5;
    CGFloat e =  M_PI * 1.5;
    if (upOrDow >= 0) {
        CGFloat holf = 2 * M_PI * absup / 100;
        e = s + holf;
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
    [bPath addArcWithCenter:CGPointMake(HMSCREENWIDTH - 42 - 10, 68.0)
                    radius:84 *0.5
                startAngle:s
                  endAngle:e
                  clockwise: upOrDow >= 0 ?  YES : NO];

    _shapeLayer.path = bPath.CGPath;
}



@end
