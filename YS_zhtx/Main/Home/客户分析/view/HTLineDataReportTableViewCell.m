//
//  HTLineDataReportTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "JBLineChartView.h"
#import "HTSingleLineReportModel.h"
#import "HTLineDataReportTableViewCell.h"
@interface HTLineDataReportTableViewCell()<JBLineChartViewDelegate, JBLineChartViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *dateBt;

@property (weak, nonatomic) IBOutlet UIScrollView *reportBack;

@property (nonatomic,strong) NSArray *chartData;

@property (nonatomic, strong) JBLineChartView *lineChartView;

@property (nonatomic,strong) NSArray *colors;

@property (nonatomic,strong) NSMutableArray *xArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btHeight;

@property (weak, nonatomic) IBOutlet UIImageView *downImg;

@property (nonatomic,strong) UILabel *holdLabel;


@end
@implementation HTLineDataReportTableViewCell

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
    
    self.downImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dataClicked:)];
    [self.downImg addGestureRecognizer:tap];
}


- (IBAction)dataClicked:(id)sender {
    if (self.delegate) {
        [self.delegate dateClicked];
    }
}
#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return [self.chartData count];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    NSArray *arr = self.chartData[lineIndex];
    return [arr count];
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

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (self.isDefual) {
        self.dateBt.hidden = YES;
        self.downImg.hidden = YES;
        self.btHeight.constant = 0.0f;
    }else{
        self.dateBt.hidden = NO;
        self.downImg.hidden = NO;
        self.btHeight.constant = 33.0f;
    }
    [self.xArray removeAllObjects];
    NSMutableArray *mutableLineCharts = [NSMutableArray array];
    self.lineChartView.frame = CGRectMake(0, 0, HMSCREENWIDTH * dataArray.count / 7  ,self.reportBack.height);
    self.reportBack.contentSize = CGSizeMake( HMSCREENWIDTH * dataArray.count / 7  ,self.reportBack.height);
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i = 0; i < dataArray.count;i++) {
        HTSingleLineReportModel *model = dataArray[i];
        if (model.time.length >= 10 ) {
            [self.xArray addObject:[model.time substringWithRange:NSMakeRange(5, 5)]];
        }
        [mutableChartData addObject:[NSNumber numberWithFloat:model.count.floatValue]];
    }
    [mutableLineCharts addObject:mutableChartData];
    self.chartData = [NSArray arrayWithArray:mutableLineCharts];
    [self.lineChartView reloadData];
}

-(void)setModel:(HTCustomersInfoReprotModel *)model{
    _model = model;
    [self.dateBt setTitle:[NSString stringWithFormat:@"%@-%@",model.vipAddTimeBegin,model.vipAddTimeEnd] forState:UIControlStateNormal];
}

-(NSArray *)colors{
    if (!_colors) {
        _colors = @[@"#FC5C7D",@"#786BB5"];
    }
    return _colors;
}

-(NSMutableArray *)xArray{
    if (!_xArray) {
        _xArray = [NSMutableArray array];
    }
    return _xArray;
}

@end
