//
//  HTManyLineBarDataTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#define marginLeft 26
#define singlebarWidth 10


#import "PNChartLabel.h"
#import "PNBarChart.h"
#import "HTManyLineBarDataTableViewCell.h"
@interface HTManyLineBarDataTableViewCell()<PNChartDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title0;
@property (weak, nonatomic) IBOutlet UILabel *value0;

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *vlaue1;

@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *vlaue2;

@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *vlaue3;

@property (weak, nonatomic) IBOutlet UIScrollView *reportBack;

@property (nonatomic,strong) UIView *legendView;

@property (nonatomic,strong) NSArray *barColors;

@property (nonatomic,strong) UIView *bottomLine;




@end
@implementation HTManyLineBarDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (int i = 0; i < 4; i++) {
        UIView *vv = [self viewWithTag:700 + i];
        [vv changeCornerRadiusWithRadius:8];
    }
}
-(void)setModel:(HTManyBarGraphModel *)model{
    _model = model;
    NSArray *titles = model.title;
    NSArray *tits = @[self.title0,self.title1,self.title2,self.title3];
    NSArray *vals = @[self.value0,self.vlaue1,self.vlaue2,self.vlaue3];
    for (int i = 0; i < titles.count; i++) {
        HTBarTitleItemModel *m = titles[i];
        if (i < tits.count) {
            UILabel *label1 = tits[i];
            UILabel *label2 = vals[i];
            label1.text = [HTHoldNullObj getValueWithUnCheakValue:m.name];
            label2.text = [HTHoldNullObj getValueWithUnCheakValue:m.sum];
        }
    }
    [self createBarCharts];
    [self.reportBack addSubview:self.legendView];
}
-(void)createBarCharts{
 
    NSArray *bars = self.model.data;
    if (bars.count == 0) {
        return;
    }
    for (UIView *vvv in self.reportBack.subviews) {
        [vvv removeFromSuperview];
    }
//    每个barchar和间隙宽度
    CGFloat barWidth = (HMSCREENWIDTH - 2 * marginLeft - 32) / 4;
    if (bars.count > 4) {
        self.reportBack.contentSize = CGSizeMake( 2 * marginLeft + barWidth * bars.count, self.reportBack.height);
    }else{
       self.reportBack.contentSize = CGSizeMake(HMSCREENWIDTH - 32, self.reportBack.height);
    }
    self.bottomLine.frame = CGRectMake(0, self.reportBack.height - 72, self.reportBack.contentSize.width, 1);
   
    CGFloat maxheigt = self.reportBack.height - 50 - 72;
    for (int i = 0; i < bars.count; i++) {
        HTBarItemModel *model = bars[i];
        PNBarChart *chart = [self configBarChart];
//        if (self.model.getItemsMaxValue == 0) {
           chart.frame = CGRectMake(marginLeft + barWidth * i ,50 + maxheigt * (1 - 1) , 43, maxheigt *  1 + 72);
//        }else{
//        chart.frame = CGRectMake(marginLeft + barWidth * i ,50 + maxheigt  /** (1 - model.getMaxVale  / self.model.getItemsMaxValue) */, 43, maxheigt /*   model.getMaxVale   / self.model.getItemsMaxValue */+ 72);
//        }
        [chart setStrokeColors:self.barColors];
        [chart setXLabels:@[@"",@"",@"",@""]];
        [chart setYValues:model.data];
        [self.reportBack addSubview:chart];
        chart.delegate = self;
        chart.tag = 500 + i;
        [chart strokeChart];
        PNChartLabel *label = [self createxLabel];
        label.text = model.name;
        label.center = CGPointMake(chart.centerX , self.reportBack.height - 35);
        [self.reportBack addSubview:label];
    }
     [self.reportBack addSubview:self.bottomLine];
}
-(PNChartLabel *)createxLabel{
    PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, (HMSCREENWIDTH - 32) / 4, 72)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"222222"];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.transform = CGAffineTransformMakeRotation( - M_PI / 4);
    return label;
}

-(PNBarChart *)configBarChart{
    PNBarChart *bar = [[PNBarChart alloc] init];
    bar.backgroundColor = [UIColor whiteColor];
    bar.yChartLabelWidth = 0.0f;
    bar.chartMarginLeft = 1.0f;
    bar.chartMarginRight = 1.0f;
    bar.chartMarginTop = 0;
    bar.chartMarginBottom = 0;
    bar.barWidth = singlebarWidth;
    bar.isGradientShow = NO;
    bar.showChartBorder = NO;
    bar.isShowNumbers = NO;
    bar.barRadius = 0.0f;
    bar.barBackgroundColor = [UIColor clearColor];
    return bar;
}

-(NSArray *)barColors{
    if (!_barColors) {
        _barColors = @[[UIColor colorWithHexString:@"#614DB6"],[UIColor colorWithHexString:@"#FC5C7D"],[UIColor colorWithHexString:@"#59B4A5"],[UIColor colorWithHexString:@"#FDB00B"]];
    }
    return _barColors;
}
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor blackColor];
    }
    return _bottomLine;
}
-(UIView *)legendView{
    if (!_legendView) {
        _legendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 85)];
        _legendView.hidden = YES;
        for (int i = 0; i < 4; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + i * 17,HMSCREENWIDTH, 17)];
            label.textColor = self.barColors[i];
            label.font = [UIFont systemFontOfSize:14];
            label.tag = 600 + i;
            label.textAlignment = NSTextAlignmentCenter;
            [_legendView addSubview:label];
        }

    }
    return _legendView;
}
-(void)userClickedOnBarAtIndex:(NSInteger)barIndex onBar:(PNBarChart *)chart{
    PNBarChart *bar = chart;
    HTBarItemModel *model = self.model.data[chart.tag - 500];
    for (int i = 0; i < model.data.count; i++) {
        NSString *str = model.data[i];
        UILabel *label = [self.reportBack viewWithTag:(600+i)];
        label.text = [HTHoldNullObj getValueWithUnCheakValue:str] ;
    }
    self.legendView.center = CGPointMake(bar.centerX, self.legendView.centerY);
    self.legendView.hidden = NO;
}
@end
