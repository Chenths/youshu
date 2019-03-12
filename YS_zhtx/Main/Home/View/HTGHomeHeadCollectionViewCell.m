//
//  HTGHomeHeadCollectionViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTWarningHoldManager.h"
#import "HTGHomeHeadCollectionViewCell.h"

#define layerRadius 65

#define thinWidth 10

#define strongWidth 20

@interface HTGHomeHeadCollectionViewCell(){
    UIBezierPath *bPath;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthSaleAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthFinshPresentLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthOrderNums;

@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleProductNums;

@property (weak, nonatomic) IBOutlet UILabel *exchangePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *relatedLabel;

@property (weak, nonatomic) IBOutlet UIView *saleBackView;

@property (weak, nonatomic) IBOutlet UIButton *guiderBt;

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) UIImageView *endPoint;


@property (weak, nonatomic) IBOutlet UIButton *ldBt;

@property (weak, nonatomic) IBOutlet UIButton *discountBt;



@end

@implementation HTGHomeHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.guiderBt changeCornerRadiusWithRadius:15];
    
    [self createBaceShapeLayer];
    [self configShapeLayer];
    [self createCircleWithIp:0];
    _endPoint = [[UIImageView alloc] init];
    _endPoint.hidden = NO;
    _endPoint.image = [UIImage imageNamed:@"endpoint"];
    [self.saleBackView addSubview:_endPoint];
    _endPoint.frame = [self getEndPointFrameWithProgress:0];

}
-(void)createBaceShapeLayer{
    UIBezierPath *bPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70) radius:layerRadius startAngle:0 endAngle:360 clockwise:YES];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.lineWidth = strongWidth;
    shaperLayer.strokeColor = [UIColor colorWithHexString:@"f8f8f8"].CGColor;
    shaperLayer.fillColor = nil;
    shaperLayer.path = bPath1.CGPath;
    [self.saleBackView.layer addSublayer:shaperLayer];
    
    UIBezierPath *bPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 70) radius:layerRadius startAngle:0 endAngle:360 clockwise:YES];
    CAShapeLayer *shaperLayer1 = [CAShapeLayer layer];
    shaperLayer1.lineWidth = thinWidth;
    shaperLayer1.strokeColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    shaperLayer1.fillColor = nil;
    shaperLayer1.path = bPath2.CGPath;
    [self.saleBackView.layer addSublayer:shaperLayer1];
}

- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = thinWidth;
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = [UIColor colorWithHexString:@"222222"].CGColor;
    [self.saleBackView.layer addSublayer:_shapeLayer];
}
-(void)createCircleWithIp:(int) upOrDow{

    int absup = abs(upOrDow);
    CGFloat s = M_PI * -0.5;
    CGFloat e =  M_PI * 1.5 ;
    if (upOrDow >= 0) {
        CGFloat holf = 2 * M_PI * absup / 100;
        e = s + holf;
        e = e >  2 * M_PI ? e - 2 * M_PI : e   ;
    }else{
        CGFloat holf = 2 * M_PI * absup / 100;
        e  = s - holf;
        if (e >= 0) {
        }else{
            e = 2 * M_PI + e ;
        }
    }
    bPath = [[UIBezierPath alloc] init];
    [bPath addArcWithCenter:CGPointMake(70, 70)
                     radius:layerRadius
                 startAngle:s
                   endAngle:e
                  clockwise: upOrDow >= 0 ?  YES : NO];
    _shapeLayer.path = bPath.CGPath;
}
-(CGRect)getEndPointFrameWithProgress:(float)progress
{
    CGFloat angle = M_PI*2.0*progress;//将进度转换成弧度
    float radius = layerRadius;//半径
    int index = (angle)/M_PI_2;//用户区分在第几象限内
    float needAngle = angle - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 0:
            
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    //为了让圆圈的中心和圆环的中心重合
    x -= thinWidth / 2;
    y -= thinWidth / 2;;
    //更新圆环的frame
    return  CGRectMake(x , y, 20, 20);
}

-(void)setModel:(HTHomeDataModel *)model{
    _model = model;
    self.ldBt.hidden = YES;
    self.discountBt.hidden = YES;
//    退换货差价
    self.exchangePriceLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.exchangeAndReturn];
//    名字
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
//    本月销售
    self.monthSaleAmountLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.money];
//    折扣
    self.discountLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:model.discount] isEqualToString:@"0"] ? @"0折" : model.discount.floatValue < 0 ? @"/折" :[NSString stringWithFormat:@"%@折",[HTHoldNullObj getValueWithBigDecmalObj:model.discount]];
//    销量
    self.saleProductNums.text = [HTHoldNullObj getValueWithUnCheakValue:model.total];
//    单量
    self.monthOrderNums.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderNum];
//    吊牌价
    self.saleMoneyLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.totalMoney];
//    连带率
    self.relatedLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.serialUP];
    if (model.serialUP.floatValue < [HTShareClass shareClass].reportWarnStandard.ldl.floatValue) {
        self.ldBt.hidden = NO;
    }
    if (model.discount.floatValue < [HTShareClass shareClass].reportWarnStandard.zkl.floatValue) {
        self.discountBt.hidden = NO;
    }
}

- (IBAction)guiderBtClicked:(id)sender {
    if (self.delegate) {
        [self.delegate guiderBtClicked];
    }
}
- (IBAction)discountClicked:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:@"折扣率" andWarningValue:[HTHoldNullObj getValueWithUnCheakValue:self.model.discount]];
}
- (IBAction)ldClicked:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:@"连带率" andWarningValue:[HTHoldNullObj getValueWithUnCheakValue:self.model.serialUP]];
}


@end
