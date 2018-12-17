//
//  HTLineTools.m
//  24小助理
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTLineTools.h"
#import "HTHumLineGuideView.h"

@interface HTLineTools()<PNChartDelegate>{
    NSMutableArray *dataArray1;
}

@property (nonatomic,strong) PNLineChart * HumanTrafficChart;

@property (nonatomic,strong) HTHumLineGuideView * guideView;

@property (nonatomic,strong) NSString *key;

@end

@implementation HTLineTools


- (HTHumLineGuideView *)guideView{
    if (!_guideView) {
        _guideView = [[NSBundle mainBundle] loadNibNamed:@"HTHumLineGuideView" owner:nil
                                                 options:nil].lastObject;
        _guideView.hidden = YES;
        [self.HumanTrafficChart addSubview:_guideView];
    }
    return _guideView;
}
- (ShowType)showTipType{
    if (!_showTipType) {
        _showTipType = showDefoue;
    }
    return _showTipType;
}
- (UIButton *)changeBt{
    if (!_changeBt) {
        _changeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBt.backgroundColor = RGB(0, 0, 0, 0.2);
        [_changeBt addTarget:self action:@selector(changeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeBt.layer.masksToBounds = YES;
        _changeBt.layer.cornerRadius  = 25;
        _changeBt.hidden = YES;
        
//        if (!_disMiss) {
//            [_changeBt setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-expand"] forState:UIControlStateNormal];
//        }else{
//           [_changeBt setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-compress"] forState:UIControlStateNormal];
//        }
//        _changeBt.titleLabel.font =  [UIFont fontWithName:kFontAwesomeFamilyName size:35];
//        [_changeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
    }
    return _changeBt;
}
/**
 *  跳转至旋转全屏
 *
 *  @param sender bt
 */
- (void)changeBtClicked:(UIButton *) sender{
    
    if (_disMiss) {
        _disMiss();
        return;
    }
//    HTHumanTraViewController *vc = [HTHumanTraViewController new];
//
//
//    HTMainNavgationController *vc1 = (id)[[HTShareClass shareClass] getCurrentNavController];
//
//    [vc1 presentViewController:vc animated:YES completion:nil];
//
}



- (PNLineChart *)lineChartWithArrays:(NSArray *)dataArray andFrame:(CGRect)rect withKey:(NSString *)key{
    int max = 0 ;
    int min = 0  ;
    self.key = [HTHoldNullObj getValueWithUnCheakValue:key];
    dataArray1                 = [[NSMutableArray alloc] init];
    [dataArray1 addObjectsFromArray:dataArray];
    NSArray *titleArray = @[@"营业额"];
    float width = [dataArray.firstObject count] >= 7 ? (HMSCREENWIDTH * [dataArray.firstObject count] / 7.0  ): HMSCREENWIDTH ;
    self.HumanTrafficChart = [[PNLineChart alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)];
    self.HumanTrafficChart.yLabelFormat       = @"%1.1f";
    self.HumanTrafficChart.backgroundColor    = [UIColor clearColor];
    self.HumanTrafficChart.showCoordinateAxis = YES;
    self.HumanTrafficChart.yGridLinesColor    = [UIColor clearColor];
    self.HumanTrafficChart.showYGridLines     = YES;
    self.HumanTrafficChart.delegate           = self;
    self.HumanTrafficChart.showSmoothLines = YES;
    NSMutableArray *lineDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *LineXLabels   = [[NSMutableArray alloc] init];
    for (NSArray * arr in dataArray1) {
        
        NSMutableArray *data01Array = [[NSMutableArray array] init];
        
        for (NSDictionary * dic in arr) {
            [data01Array addObject:[dic getStringWithKey:key]];
            
            if ([[dic getStringWithKey:key] intValue] > max) {
                max = [dic[key] intValue];
            }
            
            if ([[dic getStringWithKey:key] intValue] < min) {
                min = [[dic getStringWithKey:key] intValue];
            }
            
            if (LineXLabels.count <= arr.count) {
                [LineXLabels addObject: [dic getStringWithKey: @"time"].length >=5 ? [[dic getStringWithKey: @"time"] substringFromIndex:5] : [dic getStringWithKey: @"time"]] ;
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
    self.HumanTrafficChart.yFixedValueMax = max;
    self.HumanTrafficChart.yFixedValueMin = min;
    [self.HumanTrafficChart setXLabels:LineXLabels];
    
    [self.HumanTrafficChart setYLabels:@[
                                         [NSString stringWithFormat:@"%d",min],                                      @"",
                                         @"",
                                         @"",
                                         @"",
                                         @"",
                                         [NSString stringWithFormat:@"%d",max],
                                         ]
     ];
    NSArray *sscolors = @[[UIColor colorWithHexString:@"#6A82FB"],[UIColor colorWithHexString:@"#59B4A5"],[UIColor colorWithHexString:@"#FDB00B"]];
    NSMutableArray * chartData = [[NSMutableArray alloc] init];
    int i = 0 ;
    for (NSMutableArray * obj in lineDataArray) {
        PNLineChartData *data01 = [PNLineChartData new];
//        data01.dataTitle = titleArray[i];
        data01.color = sscolors[i];
        data01.alpha = 1.0f;
        data01.itemCount = obj.count;
        data01.inflexionPointColor = sscolors[i];
        data01.inflexionPointStyle = PNLineChartPointStyleCircle;
        data01.getData = ^(NSUInteger index) {
            CGFloat yValue = [obj[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        [chartData addObject:data01];
        i++;
    }
    
    self.HumanTrafficChart.chartData = chartData;
    [self.HumanTrafficChart strokeChart];
    
    return  self.HumanTrafficChart;
    
}

- (PNLineChart *)lineChartWithArray:(NSArray *)dataArray andFrame:(CGRect)rect withKey:(NSString *)key{
    int max = 0 ;
    int min = 0  ;
    self.key = [HTHoldNullObj getValueWithUnCheakValue:key];
    dataArray1                 = [[NSMutableArray alloc] init];
    [dataArray1 addObject:dataArray];
    NSArray *titleArray = @[@"营业额"];
    float width = [dataArray count] >= 7 ? (HMSCREENWIDTH * [dataArray count] / 7.0  ): HMSCREENWIDTH ;
    self.HumanTrafficChart = [[PNLineChart alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)];
    self.HumanTrafficChart.yLabelFormat       = @"%1.1f";
    self.HumanTrafficChart.backgroundColor    = [UIColor clearColor];
    self.HumanTrafficChart.showCoordinateAxis = YES;
    self.HumanTrafficChart.yGridLinesColor    = [UIColor clearColor];
    self.HumanTrafficChart.showYGridLines     = YES;
    self.HumanTrafficChart.delegate           = self;
    
    NSMutableArray *lineDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *LineXLabels   = [[NSMutableArray alloc] init];
    for (NSArray * arr in dataArray1) {
        
        NSMutableArray *data01Array = [[NSMutableArray array] init];
        
        for (NSDictionary * dic in arr) {
            [data01Array addObject:dic[key]];
            
            if ([dic[key] intValue] > max) {
                max = [dic[key] intValue];
            }
            
            if ([dic[key] intValue] < min) {
                min = [dic[key] intValue];
            }
            
            if (LineXLabels.count <= arr.count) {
                [LineXLabels addObject: [dic getStringWithKey: @"time"].length >=5 ? [[dic getStringWithKey: @"time"] substringFromIndex:5] : [dic getStringWithKey: @"time"]] ;
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
    self.HumanTrafficChart.yFixedValueMax = max;
    self.HumanTrafficChart.yFixedValueMin = min;
    [self.HumanTrafficChart setXLabels:LineXLabels];
    
    [self.HumanTrafficChart setYLabels:@[
                                         [NSString stringWithFormat:@"%d",min],                                      @"",
                                         @"",
                                         @"",
                                         @"",
                                         @"",
                                         [NSString stringWithFormat:@"%d",max],
                                         ]
     ];
    
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
    
    self.HumanTrafficChart.chartData = chartData;
    [self.HumanTrafficChart strokeChart];
    
    return  self.HumanTrafficChart;

}
- (PNLineChart *)lineChartWithDictionary:(NSDictionary *)dataArray andFrame:(CGRect)rect{
    
    int max = 0 ;
    int min = 0  ;
    NSMutableDictionary *dataDic = [dataArray mutableCopy];
    dataArray1                 = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    
    if ([dataArray getArrayWithKey:@"irList"].count == 0) {
        NSMutableArray *dataArr = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            [dataArr addObject:@{
                                @"countIn":@"0",
                                @"dataTime":@"2016-无数据"
                                }];
            
        }
        [dataDic setObject:dataArr forKey:@"irList"];
        
    }
    if ([dataDic[@"irList"] count] > 0 ) {
        [dataArray1 addObject:dataDic[@"irList"]];
        float width = [dataDic[@"irList"] count] >= 7 ? (HMSCREENWIDTH * [dataDic[@"irList"] count] / 7.0  ): HMSCREENWIDTH ;
        self.HumanTrafficChart = [[PNLineChart alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height)];
        [titleArray addObject:@"店铺客流量"];
    }
    
    if ([dataDic[@"clList"] count] > 0 ) {
        [dataArray1 addObject:dataDic[@"clList"]];
        [titleArray addObject:@"试衣间客流"];
    }
   
    self.HumanTrafficChart.yLabelFormat       = @"%1.1f";
    self.HumanTrafficChart.backgroundColor    = [UIColor clearColor];
    self.HumanTrafficChart.showCoordinateAxis = YES;
    self.HumanTrafficChart.yGridLinesColor    = [UIColor clearColor];
    self.HumanTrafficChart.showYGridLines     = YES;
    self.HumanTrafficChart.delegate           = self;
    
    NSMutableArray *lineDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *LineXLabels   = [[NSMutableArray alloc] init];
    for (NSArray * arr in dataArray1) {
    
        NSMutableArray *data01Array = [[NSMutableArray array] init];
    
        for (NSDictionary * dic in arr) {
            [data01Array addObject:dic[@"countIn"]];
            
            if ([dic[@"countIn"] intValue] > max) {
                max = [dic[@"countIn"] intValue];
            }
            
            if ([dic[@"countIn"] intValue] < min) {
                min = [dic[@"countIn"] intValue];
            }
            
            if (LineXLabels.count <= arr.count) {
                [LineXLabels addObject:[dic[@"dataTime"] substringFromIndex:5]];
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
    self.HumanTrafficChart.yFixedValueMax = max;
    self.HumanTrafficChart.yFixedValueMin = min;
    [self.HumanTrafficChart setXLabels:LineXLabels];
    
    [self.HumanTrafficChart setYLabels:@[
                                         [NSString stringWithFormat:@"%d",min],                                      @"",
                                         @"",
                                         @"",
                                         @"",
                                         @"",
                                         [NSString stringWithFormat:@"%d",max],
                                         ]
     ];

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
    
    self.HumanTrafficChart.chartData = chartData;
    [self.HumanTrafficChart strokeChart];
    
    return  self.HumanTrafficChart;
}
-(void)reloadlineChartWithDictionary:(NSDictionary *)dataArray andFrame:(CGRect)rect{
    int max = 0 ;
    int min = 0  ;
    
    dataArray1                 = [[NSMutableArray alloc] init];
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    
    if ([dataArray[@"irList"] count] > 0 ) {
        [dataArray1 addObject:dataArray[@"irList"]];
        float width = [dataArray[@"irList"] count] >= 7 ? (HMSCREENWIDTH * [dataArray[@"irList"] count] / 7.0  ): HMSCREENWIDTH ;
        self.HumanTrafficChart.frame = CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
        [titleArray addObject:@"出入口人流"];
    }
    
    if ([dataArray[@"clList"] count] > 0 ) {
        [dataArray1 addObject:dataArray[@"clList"]];
        [titleArray addObject:@"试衣间人流"];
    }
    
    NSMutableArray *lineDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *LineXLabels   = [[NSMutableArray alloc] init];
    for (NSArray * arr in dataArray1) {
        
        NSMutableArray *data01Array = [[NSMutableArray array] init];
        
        for (NSDictionary * dic in arr) {
            [data01Array addObject:dic[@"countIn"]];
            
            if ([dic[@"countIn"] intValue] > max) {
                max = [dic[@"countIn"] intValue];
            }
            
            if ([dic[@"countIn"] intValue] < min) {
                min = [dic[@"countIn"] intValue];
            }
            if (LineXLabels.count <= arr.count) {
                [LineXLabels addObject:[dic[@"dataTime"] substringFromIndex:5]];
            }
        }
        [lineDataArray addObject:data01Array];
    }
    if (max < 10) {
        max = 10;
    }else{
        max = max + (int) max * 0.1  ;
    }
    
    self.HumanTrafficChart.yFixedValueMax = max;
    self.HumanTrafficChart.yFixedValueMin = min;
    [self.HumanTrafficChart setXLabels:LineXLabels];
    
    [self.HumanTrafficChart setYLabels:@[
                                         [NSString stringWithFormat:@"%d",min],                                         @"",
                                         @"",
                                         @"",
                                         @"",
                                         @"",
                                         [NSString stringWithFormat:@"%d",max],
                                         ]
     ];
    
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

    [self.HumanTrafficChart updateChartData:chartData];
}

- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex{
    
   
    lineIndex = dataArray1.count > 2 ? lineIndex : lineIndex % 2;
    HTHumanTraModel *model = [[HTHumanTraModel alloc] init];
    float width = 0 ;
    switch (self.showTipType) {
        case showDefoue:
        {
            NSArray *arr = dataArray1[lineIndex];
            NSDictionary *dic = arr[pointIndex];
            [model setValuesForKeysWithDictionary:dic];
            model.title = @"出入口人流";
            width = [[NSString stringWithFormat:@"出入口人流:%@",model.countIn] boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
        }
            break;
        case showSale:
        {
            NSArray *arr = dataArray1[lineIndex];
            NSDictionary *dic = arr[pointIndex];
            model.countIn = self.key.length > 0 ? [dic getStringWithKey:self.key] :  [dic getStringWithKey:@"amount"];
            model.dataTime = [dic getStringWithKey:@"time"];
            model.title = @"营业额";
            width = [[NSString stringWithFormat:@"营业额:%@",model.countIn] boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
        }
        
            break;
        case showCellSale:{
            NSArray *arr = [[dataArray1[lineIndex] getStringWithKey:@"value"] ArrayWithJsonString];
            CGFloat value = [arr[pointIndex] floatValue];
            model.countIn = [NSString stringWithFormat:@"%.0lf",value];
            
            model.dataTime = [NSString stringWithFormat:@" %@年%ld月",[dataArray1[lineIndex] getStringWithKey:@"name"], pointIndex + 1];
             model.title = @"金额";
            float Width1 = [[NSString stringWithFormat:@" %@年%ld月",[dataArray1[lineIndex] getStringWithKey:@"name"], pointIndex + 1] boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size.width + 20;
            width = [[NSString stringWithFormat:@"金额:%@",model.countIn] boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 20;
            if (Width1 > width) {
                width = Width1;
            }

        }
            break;
        default:
            break;
    }
  
    
    
    if ((point.y - 60) >= 0) {
        self.guideView.backImage.image = [UIImage imageNamed:@"圆角矩形-1-拷贝"];
        self.guideView.frame = CGRectMake(point.x - width / 2 , point.y - 63 , width, 60);
    }else{
        self.guideView.backImage.image = [UIImage imageNamed:@"圆角矩形-2-拷贝"];
        self.guideView.frame = CGRectMake(point.x - width / 2  , point.y + 3 , width, 60);

    }
    
    self.guideView.model = model;
    self.guideView.hidden = NO;
}
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    
  
}

//手指离开时，隐藏指引界面
- (void)chancelDoSomething{
    self.changeBt.hidden  = YES;
}
- (void)touchbegin{
  
        self.changeBt.hidden = NO;
  
    
}

@end
