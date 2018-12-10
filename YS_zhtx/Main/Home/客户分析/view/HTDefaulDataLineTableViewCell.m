//
//  HTDefaulDataLineTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "PNChart.h"
#import "HTDefaulDataLineTableViewCell.h"
@interface HTDefaulDataLineTableViewCell()<PNChartDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *reportBack;

@property (nonatomic,strong) PNBarChart *barChart;

@property (weak, nonatomic) IBOutlet UIView *holdView;

@property (nonatomic,strong) UILabel *holdLabel;

@end


@implementation HTDefaulDataLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.holdView changeCornerRadiusWithRadius:8];
    self.reportBack.backgroundColor = [UIColor whiteColor];
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 50, self.reportBack.width, self.reportBack.height - 50)];
    [self.reportBack addSubview:self.barChart];
    self.barChart.backgroundColor = [UIColor whiteColor];
    self.barChart.xLabelWidth = 50;
    self.barChart.yChartLabelWidth = 0.0;
    self.barChart.chartMarginLeft = 8;
    self.barChart.chartMarginRight = 8;
    self.barChart.chartMarginTop = 5;
    self.barChart.chartMarginBottom = 0;
    self.barChart.barWidth = 27.0f;
    self.barChart.rotateForXAxisText = YES;
    self.barChart.isGradientShow = NO;
    self.barChart.showChartBorder = YES;
    self.barChart.chartBorderColor = [UIColor blackColor];
    self.barChart.isShowNumbers = NO;
    self.barChart.barBackgroundColor = [UIColor clearColor];
    self.barChart.delegate = self;

}
-(void)setModel:(HTCustomerBarGraphModel *)model{
    _model = model;
    self.holdView.backgroundColor = self.color;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.sumLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.sum];
    NSMutableArray *yValues = [NSMutableArray array];
    NSMutableArray *xLabels = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    if (model.labellist.count > 4) {
        self.barChart.frame = CGRectMake(0, 50, self.reportBack.width * model.labellist.count / 4.0, self.reportBack.height - 50);
        self.reportBack.contentSize = CGSizeMake(self.reportBack.width * model.labellist.count / 4.0, self.reportBack.height);
    }else{
        self.barChart.frame = CGRectMake(0, 50, self.reportBack.width, self.reportBack.height - 50);
        self.reportBack.contentSize = CGSizeMake(self.reportBack.width, self.reportBack.height);
    }
    for (HTBarGraphSingleModel *model in _model.labellist) {
        [yValues addObject:model.count];
        [xLabels addObject:model.name];
        [colors addObject:self.color];
    }
    if (model.labellist.count == 0) {
        return;
    }
    [self.barChart setStrokeColors:colors];
    [self.barChart setYValues:yValues];
    [self.barChart setXLabels:xLabels];
    [self.barChart strokeChart];
}
-(UILabel *)holdLabel{
    if (!_holdLabel) {
        _holdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH / 2, 20)];
        _holdLabel.textAlignment = NSTextAlignmentCenter;
        _holdLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _holdLabel.font = [UIFont systemFontOfSize:14];
        _holdLabel.hidden = YES;
        [self.reportBack addSubview:_holdView];
    }
    return _holdLabel;
}

- (void)userClickedOnBarAtIndex:(NSInteger)barIndex onBar:(PNBarChart *)chart{
    HTBarGraphSingleModel *model = self.model.labellist[barIndex];
    NSString *str = [HTHoldNullObj getValueWithUnCheakValue: model.count];
    self.holdLabel.hidden = NO;
    PNBar *bar = chart.bars[barIndex];
    [self.reportBack insertSubview:self.holdLabel aboveSubview:self.barChart];
    self.holdLabel.frame = CGRectMake( bar.centerX - HMSCREENWIDTH / 4, 72 + bar.y - 20, HMSCREENWIDTH / 2, 20);
    self.holdLabel.text = str;
}

@end
