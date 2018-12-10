//
//  HTAgeAndeSexInfoReportCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTRatioSliderView.h"
#import "HTAgeAndeSexInfoReportCell.h"
#import "HTLegendTableViewCell.h"
#import "PNChart.h"
#import "HTCustomerViewController.h"
#define PIEWIDTH 183.0

@interface HTAgeAndeSexInfoReportCell()<UITableViewDataSource,UITableViewDelegate,PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *PieReportBackView;
@property (weak, nonatomic) IBOutlet UITableView *LegendTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *legendHeight;

@property (weak, nonatomic) IBOutlet UIButton *holdBt;


@property (weak, nonatomic) IBOutlet UILabel *manCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *manPresent;

@property (weak, nonatomic) IBOutlet UILabel *womanCount;

@property (weak, nonatomic) IBOutlet UILabel *womanPrsent;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSArray *colorsArray;

@property (nonatomic,strong) HTRatioSliderView *sliderView;

@property (nonatomic,strong) PNPieChart *pieChart;

@end
@implementation HTAgeAndeSexInfoReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUi];
}
-(void)createSubWithAgelist:(NSArray *)agelist andSexList:(NSArray *)sexList{
    [self.dataArray removeAllObjects];
    [self.sliderView removeFromSuperview];
    for (int i = 0; i < agelist.count ;i++ ) {
        HTPieDataItem *item = agelist[i];
        item.color = [UIColor colorWithHexString:( i < self.colorsArray.count ?  self.colorsArray[i] : self.colorsArray[arc4random() % self.colorsArray.count - 2])];
        item.suffix = @"人";
        [self.dataArray addObject:item];
    }
    NSMutableArray *datas = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    for (int i = 0; i < sexList.count ;i++ ) {
        HTPieDataItem *model = sexList[i];
        [datas addObject:[HTHoldNullObj getValueWithUnCheakValue:model.data]];
        [colors addObject:(i < self.colorsArray.count ?  self.colorsArray[i] : self.colorsArray[arc4random() % self.colorsArray.count - 2])];
        if ([model.name isEqualToString:@"男"]) {
            self.manPresent.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.data],@"%"];
            self.manCountLabel.text = [NSString stringWithFormat:@"%@",model.total];
        }
        if ([model.name isEqualToString:@"女"]) {
            
            self.womanPrsent.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.data],@"%"];
            self.womanCount.text = [NSString stringWithFormat:@"%@",model.total];
        }
    }
    self.sliderView = [[HTRatioSliderView alloc] initWithFrame:CGRectMake(16, self.holdBt.y + self.holdBt.height + 10 , HMSCREENWIDTH - 32, 5) withDatas:datas andColors:colors];
    [self.contentView addSubview:self.sliderView];
    self.legendHeight.constant = self.dataArray.count * 48;
    [self createChart];
    [self.LegendTableView reloadData];
    
}
-(void)createChart{
   
    
    if (self.pieChart) {
        [self.pieChart removeFromSuperview];
    }
    NSMutableArray *items  = [NSMutableArray array];
    for (HTPieDataItem *model in self.dataArray) {
      [items addObject:[PNPieChartDataItem dataItemWithValue:model.total.floatValue color:model.color description:model.name]];
    }
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((HMSCREENWIDTH - PIEWIDTH) / 2 , 25 , PIEWIDTH , PIEWIDTH ) items:items];
    self.pieChart.delegate = self;
    self.pieChart.descriptionTextColor = [UIColor clearColor];
    self.pieChart.pieTitelText = @"年龄分布";
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self. pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = YES;
    self.pieChart.innerCircleRadius = (PIEWIDTH - 68 ) * 0.5;
    self.pieChart.outerCircleRadius = PIEWIDTH * 0.5;
    [self.pieChart strokeChart];
    [self.contentView addSubview:self.pieChart];
}

-(void)createUi{
    self.LegendTableView.delegate = self;
    self.LegendTableView.dataSource = self;
    UIView *footView = [[UIView alloc] init];
    self.LegendTableView.scrollEnabled = NO;
    footView.backgroundColor = [UIColor clearColor];
    [self.LegendTableView registerNib:[UINib nibWithNibName:@"HTLegendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTLegendTableViewCell"];
    self.LegendTableView.tableFooterView = footView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTLegendTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLegendTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTPieDataItem *model = self.dataArray[indexPath.row];
    HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
    vc.backImg = @"g-back";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.start] forKey:@"beginAge"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.end] forKey:@"endAge"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.userId] forKey:@"userId"];
    vc.title = model.name;
    vc.sendDic = dic;
    if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
        [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
        return;
    }else{
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }
}

- (IBAction)manClickeD:(id)sender {
    HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
    vc.backImg = @"g-back";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
    [dic setObject:@"1" forKey:@"sex"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.userId] forKey:@"userId"];
    vc.title = @"男";
    vc.sendDic = dic;
    if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
        [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
        return;
    }else{
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }

}

- (IBAction)womanClicked:(id)sender {
    HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
    vc.backImg = @"g-back";
    vc.title = @"女";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
    [dic setObject:@"0" forKey:@"sex"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.userId] forKey:@"userId"];
    vc.sendDic = dic;
    if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
        [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
        return;
    }else{
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSArray *)colorsArray{
    if (!_colorsArray) {
        _colorsArray = @[@"#9acc99",@"#ff9a66",@"#ff6766",@"#87ddb8",@"#9ce14b",@"#95b3ea",@"#20d574",@"#5be1c6",@"#e9aaab",@"#99cccd",@"#9183e7",@"#d3d35e",@"#dcace8",@"#eb9250"];
    }
    return _colorsArray;
}
@end
