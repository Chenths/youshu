//
//  HTSaleProductRankListController.m
//  YS_zhtx
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTSaleProductInfoCell.h"
#import "HTChooseBetweenDateCell.h"
#import "HTChooseDateTableViewCell.h"
#import "HcdDateTimePickerView.h"
#import "HTProductRankInfoModel.h"
#import <MJRefresh.h>
#import "HTSaleProductRankListController.h"
#import "HTSeasonChooseHeaderCell.h"

@interface HTSaleProductRankListController ()<UITableViewDelegate,UITableViewDataSource, HTSeasonChooseHeaderCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;
@property (nonatomic, strong) NSString *season;
@end

@implementation HTSaleProductRankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.season = [self.model.season copy];
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *arr = @[@"全部",@"春季款",@"夏季款",@"秋季款",@"冬季款"];
    self.title = arr[self.model.season.integerValue];
}

-(void)selectedSeasonWithIndex:(NSInteger)index{
    self.season = [NSString stringWithFormat:@"%ld",index];
    [self loadSeasonDataWithPage:1];
}
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 2 ? self.dataArray.count : 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTSeasonChooseHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSeasonChooseHeaderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        HTShopSaleReportModel *model = [[HTShopSaleReportModel alloc] init];
        model.season = self.season;
        cell.model = model;
        return  cell;
    }else if (indexPath.section == 1) {
        HTChooseDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.reportModel = self.model;
        return cell;
    }else{
        HTSaleProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleProductInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataArray[indexPath.row];
        return  cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTChooseDateTableViewCell class]]) {
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self)  weakSelf = self;
        dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.model.productBeginTime = beginTime;
            strongSelf.model.productEndTime = endTime;
            strongSelf.page = 1;
            [strongSelf loadSeasonDataWithPage:strongSelf.page];
        } ;
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
#pragma mark -CustomDelegate

#pragma EventResponse

#pragma private methods
-(void)loadSeasonDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"companyId":[HTHoldNullObj getValueWithUnCheakValue:self.companyId],
                          @"beginDate":[HTHoldNullObj getValueWithUnCheakValue:self.model.productBeginTime],
                          @"endDate":[HTHoldNullObj getValueWithUnCheakValue:self.model.productEndTime],
                          @"season":[HTHoldNullObj getValueWithUnCheakValue:self.season],
                          @"pageNo":@(page),
                          @"pageSize":@"10",
                          @"ids":[HTHoldNullObj getValueWithUnCheakValue:self.ids]
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleSaleReport,loadSaleProductRankReport] params:dic success:^(id json) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in json[@"data"]) {
            HTProductRankInfoModel *model = [HTProductRankInfoModel yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [self.tab reloadData];
    } error:^{
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;

    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleProductInfoCell" bundle:nil] forCellReuseIdentifier:@"HTSaleProductInfoCell"];
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTChooseDateTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTChooseDateTableViewCell"];
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTSeasonChooseHeaderCell"  bundle:nil] forCellReuseIdentifier:@"HTSeasonChooseHeaderCell"];
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    __weak typeof(self) weakSelf = self;
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page = 1;
        [strongSelf loadSeasonDataWithPage:strongSelf.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.page++;
        [strongSelf loadSeasonDataWithPage:strongSelf.page];
    }];
    
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}
@end
