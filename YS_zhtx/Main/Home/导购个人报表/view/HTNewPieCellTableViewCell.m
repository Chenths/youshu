//
//  HTNewPieCellTableViewCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#define PIEWIDTH 183.0
//#import "HTLengedModel.h"
#import "PNChart.h"
#import "HTBossLegendTableViewCell.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTLegendTableViewCell.h"
#import "HTSeemoreFooterView.h"
#import "HTCustomerViewController.h"
#import "HTInventoryInfoDescCell.h"
#import "HTStockProductListController.h"
#import "HTCustomerProductListController.h"
@interface HTNewPieCellTableViewCell()<UITableViewDataSource,UITableViewDelegate,PNChartDelegate>

@property (weak, nonatomic) IBOutlet UIView *PieReportBackView;
@property (weak, nonatomic) IBOutlet UITableView *LegendTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *colorsArray;
@property (nonatomic,strong) NSString *beginData;
@property (nonatomic,strong) NSString *endData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *legendHeight;

@property (nonatomic,strong) PNPieChart *pieChart;

@end
@implementation HTNewPieCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUi];
}
-(void)createUi{
    self.LegendTableView.delegate = self;
    self.LegendTableView.dataSource = self;
    UIView *footView = [[UIView alloc] init];
    self.LegendTableView.scrollEnabled = NO;
    footView.backgroundColor = [UIColor clearColor];
    self.LegendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.LegendTableView registerNib:[UINib nibWithNibName:@"HTLegendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTLegendTableViewCell"];
    [self.LegendTableView registerNib:[UINib nibWithNibName:@"HTBossLegendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTBossLegendTableViewCell"];
    [self.LegendTableView registerNib:[UINib nibWithNibName:@"HTInventoryInfoDescCell" bundle:nil] forCellReuseIdentifier:@"HTInventoryInfoDescCell"];
    
    self.LegendTableView.tableFooterView = footView;
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
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTPieDataItem *model = self.dataArray[indexPath.row];
    if ([HTHoldNullObj getValueWithUnCheakValue:model.finalprice].length > 0) {
        HTBossLegendTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossLegendTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        if ([HTHoldNullObj getValueWithUnCheakValue:model.costPrice].length > 0) {
            HTInventoryInfoDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTInventoryInfoDescCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isBoss = self.isBoos;
            cell.model = self.dataArray[indexPath.row];
            return cell;
        }else{
            HTLegendTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLegendTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.dataArray[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count > 5) {
        return self.model.isSeemore ? self.dataArray.count : 5;
    }else{
        return self. self.dataArray.count;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.model.data.count <= 5) {
        return 0.0f;
    }
    return 48.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (self.model.data.count <= 5) {
        return nil;
    }
    HTSeemoreFooterView *footer = [[NSBundle mainBundle] loadNibNamed:@"HTSeemoreFooterView" owner:nil options:nil].lastObject;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seemore:)];
    footer.tag = 500 + section;
    footer.tapLabel.text = self.model.isSeemore ? @"收起" : @"展开更多";
    [footer addGestureRecognizer:tap];
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTInventoryInfoDescCell class] ]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        HTPieDataItem *model = self.dataArray[indexPath.row];
        HTStockProductListController *vc = [[HTStockProductListController alloc] init];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.name] forKey:self.model.searchKey];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.userId] forKey:@"userId"];
        vc.requestDic = dic;
        vc.title = model.name;
        vc.companyId = self.companyId;
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }else if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTBossLegendTableViewCell class] ]){
        HTPieDataItem *model = self.dataArray[indexPath.row];
        if ([self.model.title isEqualToString:@"销售大类占比"]) {
            HTCustomerProductListController *vc = [[HTCustomerProductListController alloc] init];
            vc.beginDate = [HTHoldNullObj getValueWithUnCheakValue:self.beginTime];
            vc.endDate = [HTHoldNullObj getValueWithUnCheakValue:self.endTime];
            vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
            vc.category = [HTHoldNullObj getValueWithUnCheakValue:model.itemId];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }else if ([self.model.title isEqualToString:@"销售品类占比"]){
            HTCustomerProductListController *vc = [[HTCustomerProductListController alloc] init];
            vc.beginDate = [HTHoldNullObj getValueWithUnCheakValue:self.beginTime];
            vc.endDate = [HTHoldNullObj getValueWithUnCheakValue:self.endTime];
            vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
            vc.customType = [HTHoldNullObj getValueWithUnCheakValue:model.name];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
    }else{
        HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
        HTPieDataItem *model = self.dataArray[indexPath.row];
        vc.backImg = @"g-back";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.companyId] forKey:@"companyId"];
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.userId] forKey:@"userId"];
        if ([self.model.title isEqualToString:@"会员活跃度"]) {
            [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:model.name.length >= 4 ? [model.name substringWithRange:NSMakeRange(0, 4)] : model.name] forKey:@"active"];
            vc.sendDic = dic;
            vc.title = model.name.length >= 4 ? [model.name substringWithRange:NSMakeRange(0, 4)] : model.name;
            if ([[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"AGENT"]||[[[HTShareClass shareClass].loginModel.company getStringWithKey:@"type"] isEqualToString:@"BOSS"]) {
                [MBProgressHUD showError:@"请登录该店铺查看相关数据"];
                return;
            }else{
                [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
            }
        }
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)seemore:(UITapGestureRecognizer *)tap{
    if (self.dataArray.count > 5) {
        self.model.isSeemore = !self.model.isSeemore;
        self.legendHeight.constant = self.model.isSeemore ?  (self.dataArray.count  + 1)* 48 : 6 * 48 ;
        [self.LegendTableView reloadData];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(seemoreClickedWithCell:)]) {
        [self.delegate seemoreClickedWithCell:self];
    }
}
#pragma mark - getters and setters
-(void)setModel:(HTPiesModel *)model{
    _model = model;
    [self setDataArr:model.data];
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.dataArray removeAllObjects];
    for (int i = 0; i < dataArr.count ;i++ ) {
        HTPieDataItem *item = dataArr[i];
        if (i == 0) {
            if ([HTHoldNullObj getValueWithUnCheakValue:item.costPrice].length > 0) {
                HTPieDataItem *mm = [[HTPieDataItem alloc] init];
                NSMutableString *str = [NSMutableString stringWithString:self.model.title];
                NSRange rang = [str rangeOfString:@"占比"];
                [str replaceCharactersInRange:rang withString:@""];
                mm.data = @"占比";
                mm.name = str;
                mm.total = @"数量";
                mm.costPrice = @"成本额";
                mm.finalPrice = @"吊牌额";
                mm.isFirst = YES;
                [self.dataArray addObject:mm];
            }
        }
        item.color = [UIColor colorWithHexString:( i < self.colorsArray.count ?  self.colorsArray[i] : self.colorsArray[i % self.colorsArray.count])];
        item.suffix = @"人";
        [self.dataArray addObject:item];
    }
    self.legendHeight.constant = self.model.data.count <= 5 ? self.dataArray.count * 48 : self.model.isSeemore ? self.dataArray.count * 48  : 5 * 48 ;
    [self createChart];
    [self.LegendTableView reloadData];
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
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}
@end
