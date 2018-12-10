//
//  HTBrokenLineReportCell.m
//  有术
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "PNLineChart.h"
#import "HTLineTools.h"
#import "HTBrokenLineReportCell.h"
@interface HTBrokenLineReportCell(){
    HTLineTools *linetool;
    PNLineChart *lineChart;
}
@property (weak, nonatomic) IBOutlet UIScrollView *backSorrllerView;
@property (weak, nonatomic) IBOutlet UIButton *dateLabel;

@end
@implementation HTBrokenLineReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDataArr:(NSArray *)dataArr{
    if (_dataArr == dataArr) {
        return;
    }
    _dataArr = dataArr;
    if (!linetool) {
        linetool = [[HTLineTools alloc] init];
    }

    linetool.showTipType = showSale;
    [lineChart removeFromSuperview];
//    if (lineChart) {
//        [lineChart updateChartData:[self upLoadWith:dataArr]];
//    }else{
        lineChart = [linetool lineChartWithArray:dataArr andFrame:CGRectMake(0, 0 , HMSCREENWIDTH * 2,HMSCREENWIDTH * 9 / 16 - 31) withKey:@"count"];
        [self.backSorrllerView addSubview:lineChart];
        self.backSorrllerView.contentSize = CGSizeMake(lineChart.frame.size.width,  lineChart.frame.size.height );
        self.backSorrllerView.showsHorizontalScrollIndicator = NO;
        self.backSorrllerView.showsVerticalScrollIndicator = NO;

        UIView *legend = [lineChart getLegendWithMaxWidth:100];
        [legend setFrame:CGRectMake(HMSCREENWIDTH - legend.frame.size.width - 10 , 30, legend.frame.size.width, legend.frame.size.height)];
//        [self.contentView addSubview:legend];
//    }
}
-(void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self.dateLabel setTitle:[NSString stringWithFormat:@"%@至%@",self.beginTime,self.endTime]   forState:UIControlStateNormal];
}
-(NSArray *)upLoadWith:(NSArray *)dataArray{
    int max = 0 ;
    int min = 0  ;


    NSMutableArray * dataArray1                 = [[NSMutableArray alloc] init];
    [dataArray1 addObject:dataArray];
    NSArray *titleArray = @[@"营业额"];
    float width = [dataArray count] >= 7 ? (HMSCREENWIDTH * [dataArray count] / 7.0  ): HMSCREENWIDTH ;
    NSMutableArray *lineDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *LineXLabels   = [[NSMutableArray alloc] init];
    for (NSArray * arr in dataArray1) {

        NSMutableArray *data01Array = [[NSMutableArray array] init];

        for (NSDictionary * dic in arr) {
            [data01Array addObject:dic[@"count"]];

            if ([dic[@"count"] intValue] > max) {
                max = [dic[@"count"] intValue];
            }

            if ([dic[@"count"] intValue] < min) {
                min = [dic[@"count"] intValue];
            }

            if (LineXLabels.count <= arr.count) {
                [LineXLabels addObject:[dic[@"time"] substringFromIndex:5]];
            }
        }

        [lineDataArray addObject:data01Array];
    }
    if (max < 10) {
        max = 10;
    }else{
        max = max + (int) max * 0.1  ;
    }
    // Line Chart #1

    NSMutableArray * chartData = [[NSMutableArray alloc] init];
    int i = 0 ;
    for (NSMutableArray * obj in lineDataArray) {

        PNLineChartData *data01 = [PNLineChartData new];
        data01.dataTitle = titleArray[i];
        data01.color = PNFreshGreen;
        data01.alpha = 0.3f;
        data01.itemCount = obj.count;
        data01.inflexionPointColor = PNRed;
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [obj[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        [chartData addObject:data01];
        i++;
    }

    return chartData;
}
- (IBAction)timeclicked:(id)sender {
    if (self.delegate) {
        [self.delegate timecliked];
    }
}

@end
