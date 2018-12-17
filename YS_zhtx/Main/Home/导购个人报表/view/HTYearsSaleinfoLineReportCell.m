//
//  HTYearsSaleinfoLineReportCell.m
//  YS_zhtx
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "JBLineChartView.h"
#import "HTGuiderYeartLineData.h"
#import "HTYearsSaleinfoLineReportCell.h"

@interface HTYearsSaleinfoLineReportCell()<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *reportBack;

@property (weak, nonatomic) IBOutlet UILabel *legend1;

@property (weak, nonatomic) IBOutlet UILabel *legend2;

@property (nonatomic,strong) NSArray *chartData;

@property (nonatomic, strong) JBLineChartView *lineChartView;

@property (nonatomic,strong) NSArray *colors;

@property (weak, nonatomic) IBOutlet UILabel *firstLegend;

@property (weak, nonatomic) IBOutlet UILabel *secondLegend;

@end

@implementation HTYearsSaleinfoLineReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.reportBack.showsVerticalScrollIndicator = NO;
    self.reportBack.showsHorizontalScrollIndicator = NO;
    self.lineChartView = [[JBLineChartView alloc] init];
   
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = 20;
    self.lineChartView.backgroundColor = [UIColor whiteColor];
    [self.reportBack addSubview:self.lineChartView];
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
    HTGuiderYeartLineData *model = [dataArray firstObject];
    self.lineChartView.frame = CGRectMake(0, 0, HMSCREENWIDTH * model.value.count / 8  ,self.reportBack.height);
    self.reportBack.contentSize = CGSizeMake( HMSCREENWIDTH * model.value.count / 8  ,self.reportBack.height);
    for (int i = 0; i < dataArray.count;i++) {
        HTGuiderYeartLineData *model = dataArray[i];
        if (i == 0) {
            self.firstLegend.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
        }else if(i == 1){
            self.secondLegend.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
        }
        NSMutableArray *mutableChartData = [NSMutableArray array];
        for (NSString *value in model.value) {
         [mutableChartData addObject:[NSNumber numberWithFloat:value.floatValue]];
        }
         [mutableLineCharts addObject:mutableChartData];
    }
    self.chartData = [NSArray arrayWithArray:mutableLineCharts];
    [self.lineChartView reloadData];
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return [self.chartData count];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [[self.chartData objectAtIndex:lineIndex] count];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}
- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dimmedSelectionOpacityAtLineIndex:(NSUInteger)lineIndex{
    return 1;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return [[[self.chartData objectAtIndex:lineIndex] objectAtIndex:horizontalIndex] floatValue];
}
-(NSString *)lineChartView:(JBLineChartView *)lineChartView verticalXValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{

    if (horizontalIndex >= self.xArray.count) {
        return @"";
    }else{
        return self.xArray[horizontalIndex];
    }
}
-(UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex{
    return [UIColor colorWithHexString:self.colors[lineIndex]];
}
-(UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return [UIColor colorWithHexString:self.colors[lineIndex]];
}
- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
     return [UIColor colorWithHexString:self.colors[lineIndex]];
}
-(UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex{
    return lineIndex == 0 ? [UIColor colorWithRed:1 green:0.34 blue:0.49 alpha:0.5] : [UIColor colorWithRed:0.5 green:0.49 blue:0.71 alpha:0.5];
}
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex{
    return 1;
}
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return 3;
}
- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView{
    return 1;
}
- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    
    
}
- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}
#pragma mark -getter setter
-(NSArray *)colors{
    if (!_colors) {
        _colors = @[@"#FC5C7D",@"#786BB5"];
    }
    return _colors;
}

@end
