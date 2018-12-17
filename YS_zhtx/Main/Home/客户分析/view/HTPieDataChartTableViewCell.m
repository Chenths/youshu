//
//  HTPieDataChartTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#define PIEWIDTH 183.0
#import "PNChart.h"
#import "HTPieDataChartTableViewCell.h"
@interface HTPieDataChartTableViewCell()<PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *PieReportBackView;

@property (nonatomic,strong) NSArray *colorsArray;

@property (nonatomic,strong) PNPieChart *pieChart;


@property (nonatomic,strong) NSMutableArray *dataArray;

@end
@implementation HTPieDataChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)createChart{
    if (self.pieChart) {
        [self.pieChart removeFromSuperview];
    }
    NSMutableArray *items  = [NSMutableArray array];
    if (self.dataArray.count == 0) {
        return;
    }
    for (HTPieDataItem *model in self.dataArray) {
        [items addObject:[PNPieChartDataItem dataItemWithValue:model.data.floatValue color:model.color description:model.name]];
    }
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((HMSCREENWIDTH - PIEWIDTH) / 2 , 25 , PIEWIDTH , PIEWIDTH ) items:items];
    self.pieChart.delegate = self;
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.pieTitelText = self.model.title;
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self. pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = YES;
    self.pieChart.innerCircleRadius = (PIEWIDTH - 68 ) * 0.5;
    self.pieChart.outerCircleRadius = PIEWIDTH * 0.5;
    [self.pieChart strokeChart];
    [self.contentView addSubview:self.pieChart];
}
#pragma
-(void)setModel:(HTPiesModel *)model{
    _model = model;
    [self setDataArr:model.data];
}
-(void)setDataArr:(NSArray *)dataArr{
    [self.dataArray removeAllObjects];
    for (int i = 0; i < dataArr.count ;i++ ) {
        HTPieDataItem *item = dataArr[i];
        item.color = [UIColor colorWithHexString:( i < self.colorsArray.count ?  self.colorsArray[i] : self.colorsArray[i % self.colorsArray.count])];
        [self.dataArray addObject:item];
    }
    [self createChart];
}
- (NSArray *)colorsArray{
    if (!_colorsArray) {
        _colorsArray = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    }
    return _colorsArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
