//
//  HTBossLineReportCell.m
//  有术
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "PNChart.h"
#import "HTBossLineReportCell.h"
@interface HTBossLineReportCell()<PNChartDelegate>
@property (nonatomic,strong) PNBarChart *barChart;
@property (weak, nonatomic) IBOutlet UIScrollView *backSorllerView;
@property (nonatomic,strong) NSMutableArray *yLabels;
@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) NSString *begintime;
@property (nonatomic,strong) NSString *endtime;

@end
@implementation HTBossLineReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
//    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 180, 120)];
//
//    self.barChart.backgroundColor = [UIColor clearColor];
//
//    self.barChart.yChartLabelWidth = 20;
//    self.barChart.chartMarginLeft = 25.0;
//    self.barChart.chartMarginRight = 5.0;
//    self.barChart.chartMarginTop = 5.0;
//    self.barChart.chartMarginBottom = 5.0;
//    self.barChart.barWidth = 25.0;
//    self.barChart.labelMarginTop = 5.0;
//    [self.backSorllerView addSubview:self.barChart];
}
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr  = dataArr;
    self.tipLabel.hidden = YES;
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    if ([[HTHoldNullObj getValueWithUnCheakValue:self.endtime] isEqualToString:[[dataArr lastObject] getStringWithKey:@"time"]] &&[[HTHoldNullObj getValueWithUnCheakValue:self.begintime] isEqualToString:[[dataArr firstObject] getStringWithKey:@"time"]]) {
        return;
    }else{
        self.begintime = [[dataArr firstObject] getStringWithKey:@"time"];
        self.endtime = [[dataArr lastObject] getStringWithKey:@"time"];
    }
    if (self.barChart) {
        [self.barChart removeFromSuperview];
    }
    self.barChart = [[PNBarChart alloc] initWithFrame: CGRectMake(5, 5, dataArr.count / 10.0 * (HMSCREENWIDTH - 10), 250)];
    self.barChart.isDefaul = YES;
    self.barChart.yChartLabelWidth = 20;
    self.barChart.chartMarginLeft = 25.0;
    self.barChart.chartMarginRight = 5.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 5.0;
    self.barChart.barWidth = 25.0;
    self.barChart.labelMarginTop = 5.0;
    [self.backSorllerView addSubview:self.barChart];
    self.backSorllerView.contentSize = CGSizeMake( dataArr.count / 10.0 * (HMSCREENWIDTH - 10), 240);
    NSMutableArray *xLabels = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    int max = 0;
    for (NSDictionary *dic in dataArr) {
        NSMutableString *time = [[dic getStringWithKey:@"time"] mutableCopy];
        if ([dic getFloatWithKey:@"count"] >= max) {
            max = [dic getFloatWithKey:@"count"];
        }
        if (time.length == 10) {
            [xLabels addObject:[time substringWithRange:NSMakeRange(5, 5)]];
            [self.yLabels addObject:[dic getStringWithKey:@"count"]];
            [colors addObject:PNGreen];
        }
    }
    max = max * 1.1;
    [self.barChart setXLabels:xLabels];
    [self.barChart setYValues:self.yLabels];
    //    [self.barChart setYValues:@[@(0).stringValue,@(max / 5).stringValue,@(2* max / 5).stringValue,@(3*max / 5).stringValue,@(4 * max / 5).stringValue,@(5*max/5).stringValue]];
    self.barChart.isGradientShow = YES;
    self.barChart.isShowNumbers = NO;
    [self.barChart strokeChart];
    self.barChart.delegate = self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (NSMutableArray *)yLabels{
    if (!_yLabels) {
        _yLabels = [NSMutableArray array];
    }
    return  _yLabels;
}
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex{
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    for (PNBar * b in self.barChart.bars) {
        b.barColor = PNGreen;
    }
    bar.barColor = PNRed;
    bar.isShowNumber = YES;
    [self.barChart updateChartData:self.yLabels];
    self.tipLabel.text = [NSString stringWithFormat:@"￥%@  ",self.yLabels[barIndex]];
     CGFloat width = [[NSString stringWithFormat:@"￥%@  ",self.yLabels[barIndex]] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width  + 30;
    self.tipLabel.frame = CGRectMake(bar.x - (width - 25) / 2, bar.y  - 20  +  bar.height * 0.5 , width, 18);
    self.tipLabel.hidden = NO;
    [self.barChart insertSubview:self.tipLabel atIndex:self.barChart.subviews.count - 1];
}
- (UILabel *)tipLabel{
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor =  PNWhite;
        self.tipLabel.numberOfLines = 0 ;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.backgroundColor = [UIColor colorWithHexString:@"#FC5C7D"];
        
        [self.barChart addSubview:_tipLabel];
        self.tipLabel.hidden = YES;
    }
    return _tipLabel;
    
}
@end
