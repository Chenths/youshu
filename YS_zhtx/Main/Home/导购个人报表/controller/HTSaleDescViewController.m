//
//  HTSaleDescViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTMonthSaleDescTableViewCell.h"
#import "HTYearSaleDescTableViewCell.h"
#import "HTTodayOrderItemCell.h"
#import "HTMonthSaleDescTableViewCell.h"
#import "HTDaySaleDescHeadCell.h"
#import "HTMonthOrYearSaleDescHeadCell.h"
#import "HTSaleDescViewController.h"
#import "HTBaceNavigationController.h"
#import "HTGuiderReportModel.h"
#import "HcdDateTimePickerView.h"
#import "HTOrderDetailViewController.h"
#import "HTGuiderDayModel.h"
#import "HTGuiderMonthModel.h"
#import "HTGuiderYearModel.h"
#import "HTOrderListModel.h"
@interface HTSaleDescViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;



@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) HTGuiderDayModel *dayModel;

@property (nonatomic,strong) HTGuiderMonthModel *monthModel;

@property (nonatomic,strong) HTGuiderYearModel *yearModel;

@end

@implementation HTSaleDescViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createNav];
    [self initNav];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#ffffff"]];
}

#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *datas = self.typeModel.dataType == HTSaleDataDescTypeDay ? self.dayModel.Model : (self.typeModel.dataType == HTSaleDataDescTypeMonth ? self.monthModel.detail : self.yearModel.detail);
    if (self.typeModel.dataType == HTSaleDataDescTypeDay) {
        if (indexPath.section == 0) {
            HTDaySaleDescHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDaySaleDescHeadCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.date = self.singleDate;
            cell.model = self.dayModel;
            return cell;
        }else{
            HTTodayOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTodayOrderItemCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = datas[indexPath.row];
            return cell;
        }
    }
    if (self.typeModel.dataType == HTSaleDataDescTypeMonth) {
        if (indexPath.section == 0) {
            HTMonthOrYearSaleDescHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMonthOrYearSaleDescHeadCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.monthModel = self.monthModel;
            cell.monthDate = self.monthDate;
            cell.model = self.typeModel;
            return cell;
        }else{
            HTMonthSaleDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMonthSaleDescTableViewCell" forIndexPath:indexPath];
            cell.model = datas[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (self.typeModel.dataType == HTSaleDataDescTypeYear) {
        if (indexPath.section == 0) {
            HTMonthOrYearSaleDescHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMonthOrYearSaleDescHeadCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yearModel = self.yearModel;
            cell.yearDate = self.yearDate;
            cell.model = self.typeModel;
            return cell;
        }else{
            HTYearSaleDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTYearSaleDescTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = datas[indexPath.row];
            return cell;
        }
    }
    HTMonthSaleDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMonthSaleDescTableViewCell" forIndexPath:indexPath];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *datas = self.typeModel.dataType == HTSaleDataDescTypeDay ? self.dayModel.Model : (self.typeModel.dataType == HTSaleDataDescTypeMonth ? self.monthModel.detail : self.yearModel.detail);
    return section == 0 ? 1 : datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.typeModel.dataType == HTSaleDataDescTypeDay) {
            HTGuiderDayItmeModel *item = self.dayModel.Model[indexPath.row];
            HTOrderDetailViewController *vc = [[HTOrderDetailViewController alloc] init];
            vc.orderId = item.orderid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (self.typeModel.dataType == HTSaleDataDescTypeMonth) {
            HTDateSaleDescModel *model = [[HTDateSaleDescModel alloc] init];
            model.dataType = HTSaleDataDescTypeDay;
            HTGuiderMonthIterModel *item = self.monthModel.detail[indexPath.row];
            HTSaleDescViewController *vc = [[HTSaleDescViewController alloc] init];
            vc.typeModel = model;
            vc.singleDate = item.date;
            vc.guideId = self.guideId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (self.typeModel.dataType == HTSaleDataDescTypeYear) {
            HTDateSaleDescModel *model = [[HTDateSaleDescModel alloc] init];
            model.dataType = HTSaleDataDescTypeMonth;
            HTGuiderYearItmeModel *item = self.yearModel.detail[indexPath.row];
            HTSaleDescViewController *vc = [[HTSaleDescViewController alloc] init];
            vc.typeModel = model;
            vc.monthDate = item.date1;
            vc.guideId = self.guideId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse
-(void)dateClicked:(UIButton *)sender{
   
    if (self.typeModel.dataType == HTSaleDataDescTypeDay) {
      
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
            __weak typeof(self) weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.singleDate = dateTimeStr;
        [strongSelf.tab.mj_header beginRefreshing];
        };
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
      }
    if (self.typeModel.dataType == HTSaleDataDescTypeMonth) {
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerYearMonthMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self) weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.monthDate = dateTimeStr;
            [strongSelf.tab.mj_header beginRefreshing];
        };
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
    if (self.typeModel.dataType == HTSaleDataDescTypeYear) {
        
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerYearMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self) weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.yearDate = dateTimeStr;
            [strongSelf.tab.mj_header beginRefreshing];
        };
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
    
}
#pragma mark -private methods
-(void)createNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#3C3A43"]];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.backImg = @"g-whiteback";
    
}
-(void)initNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-calenderWhite" highImageName:@"g-calenderWhite" target:self action:@selector(dateClicked:)];
}
-(void)loadDayDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"userId":[HTHoldNullObj getValueWithUnCheakValue:self.guideId],
                          @"date":self.singleDate,
                          @"page":@(page),
                          @"rows":@"10"
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadPersonPersonalTodayReport] params:dic success:^(id json) {
        
        self.title = [NSString stringWithFormat:@"%@_销售情况",self.singleDate];
        NSMutableArray *arr = [NSMutableArray array];
        if (self.page == 1) {
        }else{
            [arr addObjectsFromArray:self.dayModel.Model];
        }
        self.dayModel = [HTGuiderDayModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [arr addObjectsFromArray:self.dayModel.Model];
        self.dayModel.Model = arr;
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        self.page--;
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        self.page--;
    }];
}
-(void)loadMonthDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"userId":[HTHoldNullObj getValueWithUnCheakValue:self.guideId],
                          @"date":self.monthDate,
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadPersonPersonalMonthReport] params:dic success:^(id json) {

        self.title = [NSString stringWithFormat:@"%@_销售情况",self.monthDate];
        self.monthModel = [HTGuiderMonthModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        self.page--;
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        self.page--;
    }];
}
-(void)loadYearDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"userId":[HTHoldNullObj getValueWithUnCheakValue:self.guideId],
                          @"date":self.yearDate,
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadPersonPersonalYearReport] params:dic success:^(id json) {
        self.title = [NSString stringWithFormat:@"%@_销售情况",self.yearDate];
        self.yearModel = [HTGuiderYearModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        self.page--;
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        self.page--;
    }];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTMonthSaleDescTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTMonthSaleDescTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTYearSaleDescTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTYearSaleDescTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTodayOrderItemCell" bundle:nil] forCellReuseIdentifier:@"HTTodayOrderItemCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTMonthSaleDescTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTMonthSaleDescTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTDaySaleDescHeadCell" bundle:nil] forCellReuseIdentifier:@"HTDaySaleDescHeadCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTMonthOrYearSaleDescHeadCell" bundle:nil] forCellReuseIdentifier:@"HTMonthOrYearSaleDescHeadCell"];
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        if (self.typeModel.dataType == HTSaleDataDescTypeDay) {
            [self loadDayDataWithPage:self.page];
        }else if (self.typeModel.dataType == HTSaleDataDescTypeMonth){
            [self loadMonthDataWithPage:self.page];
        }else if (self.typeModel.dataType == HTSaleDataDescTypeYear){
            [self loadYearDataWithPage:self.page];
        }
    }];
    if (self.typeModel.dataType == HTSaleDataDescTypeDay) {
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.typeModel.dataType == HTSaleDataDescTypeDay) {
            self.page++;
            [self loadDayDataWithPage:self.page];
        }
    }];
    }
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters

-(NSString *)singleDate{
    if (!_singleDate) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        _singleDate = today;
    }
    return _singleDate;
}
-(NSString *)monthDate{
    if (!_monthDate) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        _monthDate = today;
    }
    return _monthDate;
}
-(NSString *)yearDate{
    if (!_yearDate) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        _yearDate = today;
    }
    return _yearDate;
}
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
