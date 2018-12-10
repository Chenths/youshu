//
//  HTMonthSaleDescHeadCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMonthOrYearSaleDescHeadCell.h"
#define thinWidth 10

#define strongWidth 10

#define layerRadius 97 * 0.5


@interface HTMonthOrYearSaleDescHeadCell(){
    UIBezierPath *bPath;
}
@property (weak, nonatomic) IBOutlet UILabel *saleTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderAndPruductCount;

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

@property (weak, nonatomic) IBOutlet UILabel *finshPresentLabel;

@property (weak, nonatomic) IBOutlet UILabel *datelabel;

@property (weak, nonatomic) IBOutlet UIView *cirlceBackView;

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
@implementation HTMonthOrYearSaleDescHeadCell


#pragma mark -life cycel
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBaceShapeLayer];
    [self configShapeLayer];
}
-(void)createBaceShapeLayer{
    UIBezierPath *bPath1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(layerRadius, layerRadius) radius:layerRadius startAngle:0 endAngle:360 clockwise:YES];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.lineWidth = strongWidth;
    shaperLayer.strokeColor = [UIColor colorWithHexString:@"#333333"].CGColor;
    shaperLayer.fillColor = nil;
    shaperLayer.path = bPath1.CGPath;
    [self.cirlceBackView.layer addSublayer:shaperLayer];
}
- (void)configShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = thinWidth;
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = [UIColor colorWithHexString:@"#BBBBBB"].CGColor;
    [self.cirlceBackView.layer addSublayer:_shapeLayer];
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
    [bPath addArcWithCenter:CGPointMake(layerRadius, layerRadius)
                     radius:layerRadius
                 startAngle:s
                   endAngle:e
                  clockwise: upOrDow >= 0 ?  YES : NO];
    _shapeLayer.path = bPath.CGPath;
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods

#pragma mark - getters and setters

-(void)setMonthModel:(HTGuiderMonthModel *)monthModel{
    _monthModel = monthModel;
    self.saleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:monthModel.salesAmount]];
    self.orderAndPruductCount.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:monthModel.salesCount],[HTHoldNullObj getValueWithUnCheakValue:monthModel.salesVolume]];
    if ([monthModel.targetSales isEqualToString:@"0"]||[HTHoldNullObj getValueWithUnCheakValue:monthModel.targetSales].length == 0) {
        self.goalLabel.text = @"无数据";
    }else{
        self.goalLabel.text  = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithUnCheakValue:monthModel.targetSales]];
    }
     self.finshPresentLabel.text =  [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithUnCheakValue:monthModel.completion],@"%"];
    [self createCircleWithIp:monthModel.completion.intValue];
}

-(void)setYearModel:(HTGuiderYearModel *)yearModel{
    _yearModel = yearModel;
    self.saleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:yearModel.salesAmount]];
    self.orderAndPruductCount.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:yearModel.salesCount],[HTHoldNullObj getValueWithUnCheakValue:yearModel.salesVolume]];
    if ([yearModel.targetSales isEqualToString:@"0"]) {
        self.goalLabel.text = @"无数据";
    }else{
        self.goalLabel.text  = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithUnCheakValue:yearModel.targetSales]];
    }
    
    self.finshPresentLabel.text =  [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithUnCheakValue:yearModel.completion],@"%"];
    [self createCircleWithIp:yearModel.completion.intValue];
}

-(void)setModel:(HTDateSaleDescModel *)model{
    _model = model;
    if (model.dataType == HTSaleDataDescTypeMonth) {
    self.saleTitleLabel.text = @"月营业额";
    }
    if (model.dataType == HTSaleDataDescTypeYear) {
        self.saleTitleLabel.text = @"年营业额";
    }
}
-(void)setMonthDate:(NSString *)monthDate{
    _monthDate = monthDate;
    NSArray *months = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    if (monthDate.length >= 7 ) {
        NSString *month = [monthDate substringWithRange:NSMakeRange(5, 2)];
        self.dateLabel.text = months[month.integerValue - 1];
    }else{
        self.dateLabel.text = @"";
    }
}
-(void)setYearDate:(NSString *)yearDate{
    _yearDate = yearDate;
    self.dateLabel.text = yearDate;
}
@end
