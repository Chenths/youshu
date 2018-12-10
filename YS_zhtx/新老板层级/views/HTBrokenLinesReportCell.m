//
//  HTBrokenLinesReportCell.m
//  有术
//
//  Created by mac on 2018/4/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "PNLineChart.h"
#import "HTLineTools.h"
#import "HTBrokenLinesReportCell.h"

@interface HTBrokenLinesReportCell(){
    HTLineTools *linetool;
    PNLineChart *lineChart;
}
@property (weak, nonatomic) IBOutlet UIScrollView *backSorrllerView;
@end

@implementation HTBrokenLinesReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDataArr:(NSArray *)dataArr{
    if (dataArr == _dataArr) {
        return;
    }
    _dataArr = dataArr;
    if (!linetool) {
        linetool = [[HTLineTools alloc] init];
    }
    linetool.showTipType = showSale;
    [lineChart removeFromSuperview];
        lineChart = [linetool lineChartWithArrays:dataArr andFrame:CGRectMake(0, 0 , HMSCREENWIDTH * 2,HMSCREENWIDTH * 9 / 16 - 31) withKey:self.key];
        [self.backSorrllerView addSubview:lineChart];
        self.backSorrllerView.contentSize = CGSizeMake(lineChart.frame.size.width,  lineChart.frame.size.height );
        self.backSorrllerView.showsHorizontalScrollIndicator = NO;
        self.backSorrllerView.showsVerticalScrollIndicator = NO;

        UIView *legend = [lineChart getLegendWithMaxWidth:100];
        [legend setFrame:CGRectMake(HMSCREENWIDTH - legend.frame.size.width - 10 , 30, legend.frame.size.width, legend.frame.size.height)];
        //        [self.contentView addSubview:legend];

}
-(NSArray *)upLoadWith:(NSArray *)dataArray {
    int max = 0 ;
    int min = 0  ;


    NSMutableArray * dataArray1                 = [[NSMutableArray alloc] init];
    [dataArray1 addObjectsFromArray:dataArray];
    NSMutableArray *lineDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *LineXLabels   = [[NSMutableArray alloc] init];
    for (NSArray * arr in dataArray1) {

        NSMutableArray *data01Array = [[NSMutableArray array] init];

        for (NSDictionary * dic in arr) {
            [data01Array addObject:dic[self.key]];

            if ([dic[self.key] intValue] > max) {
                max = [dic[self.key] intValue];
            }

            if ([dic[self.key] intValue] < min) {
                min = [dic[self.key] intValue];
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
    NSArray *sscolors = @[[UIColor colorWithHexString:@"#6A82FB"],[UIColor colorWithHexString:@"#59B4A5"],[UIColor colorWithHexString:@"#FDB00B"]];
    for (NSMutableArray * obj in lineDataArray) {
        PNLineChartData *data01 = [PNLineChartData new];
//        data01.dataTitle = titleArray[i];
        data01.color = sscolors[i];
        data01.alpha = 1.0f;
        data01.itemCount = obj.count;
        data01.inflexionPointColor = sscolors[i];
//        PNLineChartPointStyleNone = 0,
//        PNLineChartPointStyleCircle = 1,
//        PNLineChartPointStyleSquare = 3,
//        PNLineChartPointStyleTriangle = 4
        data01.inflexionPointStyle = PNLineChartPointStyleCircle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [obj[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };

        [chartData addObject:data01];
        i++;
    }

    return chartData;
}


@end
