//
//  HTBossCustomerReportCompareController.m
//  有术
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossSaleBasicContrastCell.h"
#import "HTMultitermBossContrastCell.h"
#import "HTSectionOpenModel.h"
#import "HTBossSectionReportView.h"
#import "HTBossCustomerReportCompareController.h"
#import "NSDate+Manager.h"
#import "HTBossSaleBasicCompareModel.h"
#import "HTBossMulitCompareModel.h"
#import "HTBossMulitSingleCompareModel.h"
#import "HTBrokenLinesReportCell.h"
#import "HTBossVipFrequencyModel.h"
#import "HTBossHeadModel.h"
#import "HTCompareHeadView.h"
#import "HTBossSelecteTimeController.h"
#import "HTBossSelecteCompareTimeController.h"
#import "HTBossSelecteShopsController.h"
#import "HTBossSelectedTimeModel.h"
@interface HTBossCustomerReportCompareController ()<UITableViewDelegate,UITableViewDataSource,HTCompareHeadViewDeleage>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSMutableArray *sectionTitleArray;
//第一组数据
@property (nonatomic,strong) NSMutableArray *firstSectionArray;
//第2组数据
@property (nonatomic,strong) NSMutableArray *secondSectionArray;
////第3组数据
@property (nonatomic,strong) NSMutableArray *thirdSectionArray;
////第4组数据
@property (nonatomic,strong) NSMutableArray *fourthSectionArray;
@property (nonatomic,strong) HTCompareHeadView *headerView;
@property (nonatomic,strong) HTBossHeadModel *headModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstion;
@property (weak, nonatomic) IBOutlet UIButton *toTopBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstains;


@end

@implementation HTBossCustomerReportCompareController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self createTime];
    [self createData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[HTShareClass shareClass].getCurrentNavController setNavigationBarHidden:NO];
}

#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTBossSaleBasicContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleBasicContrastCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.firstSectionArray[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        }else{
            cell.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        }
        return cell;
    }
    if (indexPath.section == 1) {
        HTBrokenLinesReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBrokenLinesReportCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.key = @"count";
        cell.dataArr = self.secondSectionArray[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2 ||indexPath.section == 3 ) {
        HTMultitermBossContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMultitermBossContrastCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray *arr = self.dataArray[indexPath.section];
        cell.model = arr[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        }else{
            cell.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        }
        if (cell.model.isLine) {
            cell.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc ] init];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HTSectionOpenModel *model = self.sectionTitleArray[section];
    return model.isOpen ?  [self.dataArray[section] count] : 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HTBossSectionReportView *sectionView = [[HTBossSectionReportView alloc] initWithSectionFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    HTSectionOpenModel *model = self.sectionTitleArray[section];
    sectionView.titleLabel.text = model.title;
    sectionView.model = self.sectionTitleArray[section] ;
    sectionView.sectionOpenBt.tag = 500 + section;
    [sectionView.sectionOpenBt addTarget:self action:@selector(sectionOpenBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (section % 2 == 0) {
        sectionView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    }else{
        sectionView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    }
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    if (indexPath.section == 2 || indexPath.section == 3) {
        NSMutableArray *arr = self.dataArray[indexPath.section];
        HTBossMulitCompareModel *model =  arr[indexPath.row];
        return 20 + model.dataArr.count * ( model.isLine ? 34 : 30);
    }
    if (indexPath.section == 1) {
        return HMSCREENWIDTH * 9 / 16;
    }

    return 120;
}

#pragma mark -CustomDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 100) {
        [[HTShareClass shareClass].getCurrentNavController setNavigationBarHidden:YES];
        self.headerView.frame = CGRectMake(isIPHONEX ? SafeAreaBottomHeight : 0, -32, HMSCREENWIDTH, 88);
        self.topConstion.constant = 66;
        self.toTopBt.hidden = NO;
    }else{
        [[HTShareClass shareClass].getCurrentNavController setNavigationBarHidden:NO];
        self.headerView.frame = CGRectMake(isIPHONEX ? SafeAreaBottomHeight : 0, 0, HMSCREENWIDTH, 88);
        self.topConstion.constant = 88;
        self.toTopBt.hidden = YES;
    }
}
- (void)topClicked{
    if (!self.isTime) {
        HTBossSelecteCompareTimeController *vc  = [[HTBossSelecteCompareTimeController alloc] init];
        __weak typeof(self) weakSelf = self;
        vc.sendTime = ^(NSString *beginTime, NSString *endTime) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.beginTime = beginTime;
            strongSelf.endTime = endTime;
            strongSelf.headModel.selectedBeginTime = beginTime;
            strongSelf.headModel.selectedEndTime = endTime;
            strongSelf.headerView.model = strongSelf.headModel;
            for (HTSectionOpenModel *model in strongSelf.sectionTitleArray) {
                model.isOpen = NO;
            }
            [strongSelf.dataTableView reloadData];
        };
        [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    }
}
- (void)bottomClicked{
    if (!self.isTime) {
        HTBossSelecteShopsController *vc = [[HTBossSelecteShopsController alloc] init];
        vc.selectedCompanys =  self.companys;
        vc.maxSelected = 3;
        __weak typeof(self) weakSelf = self;
        vc.selectedsComs = ^(NSArray *companys) {
            __strong typeof(weakSelf) strongSelf  = weakSelf;
            strongSelf.companys = companys;
            NSMutableArray *arr = [NSMutableArray array] ;
            for (NSDictionary *dic in companys) {
                [arr addObject:[dic getStringWithKey:@"id"]];
            }
            self.ids = [arr componentsJoinedByString:@","];
            strongSelf.headModel.companys = strongSelf.companys;
            strongSelf.headerView.model = strongSelf.headModel;
            for (HTSectionOpenModel *model in strongSelf.sectionTitleArray) {
                model.isOpen = NO;
            }
            [strongSelf.dataTableView reloadData];
        };
        [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    }else{
        HTBossSelecteTimeController *vc = [[HTBossSelecteTimeController alloc] init];
        NSMutableArray *arr = [NSMutableArray array];
        HTBossSelectedTimeModel *model = [[HTBossSelectedTimeModel alloc] init];
        model.isCompany = YES;
        model.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.shopId];
        model.companyName = [HTHoldNullObj getValueWithUnCheakValue:self.shopName];
        [arr addObject:model];
        for (NSString *date in self.selectedDates) {
            HTBossSelectedTimeModel *model = [[HTBossSelectedTimeModel alloc] init];
            model.isCompany = NO;
            NSArray *dates = [date componentsSeparatedByString:@"——"];
            if (dates.count >= 2) {
                model.beginTime = dates[0];
                model.endTime = dates[1];
            }
            [arr addObject:model];
        }
        vc.selectedTimes = arr;
        __weak typeof(self) weakSelf = self;
        vc.changeselectedTime = ^(NSString *companyName, NSString *companyId, NSArray *dates) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.selectedDates = dates;
            strongSelf.shopId  = [HTHoldNullObj getValueWithUnCheakValue:companyId];
            strongSelf.shopName = [HTHoldNullObj getValueWithUnCheakValue:companyName];
            strongSelf.headModel.selecetedCompany =  [HTHoldNullObj getValueWithUnCheakValue:companyName];
            strongSelf.headModel.selectedCompanyId = [HTHoldNullObj getValueWithUnCheakValue:companyId];
            strongSelf.headModel.dates = dates;
            strongSelf.headerView.model = strongSelf.headModel;
            for (HTSectionOpenModel *model in strongSelf.sectionTitleArray) {
                model.isOpen = NO;
            }
            [strongSelf.dataTableView reloadData];
        };
        [[[HTShareClass shareClass] getCurrentNavController] pushViewController:vc animated:YES];
    }
}
#pragma mark -EventResponse
- (IBAction)toBtclicked:(id)sender {
    
    [self.dataTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)sectionOpenBtClicked:(UIButton *)sender{
    int tag = (int)sender.tag - 500;
    HTSectionOpenModel *model = self.sectionTitleArray[tag];
    NSMutableArray *arr = self.dataArray[tag];
    if (arr.count > 0 && model.isOpen) {
        model.isOpen = !model.isOpen;
        [self.dataTableView reloadData];
    }else{
        [self loadDataWithTag:tag];
    }
}
#pragma mark -private methods
-(void)createData{
    self.headModel = [[HTBossHeadModel alloc] init];
    if (self.isTime) {
        self.headModel.selecetedCompany = [HTHoldNullObj getValueWithUnCheakValue:self.shopName];
        self.headModel.selectedCompanyId = [HTHoldNullObj getValueWithUnCheakValue:self.shopId];
        self.headModel.dates = self.selectedDates;
        self.headModel.headType = HTCompareHeadTime;
        self.headerView.model = self.headModel;
    }else{
        self.headModel.selectedBeginTime = self.beginTime;
        self.headModel.selectedEndTime = self.endTime;
        self.headModel.companys = self.companys;
        self.headModel.headType = HTCompareHeadShop;
        self.headerView.model = self.headModel;
    }
    
}
-(void)loadDataWithTag:(int) tag{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.isTime) {
        NSDictionary *dic1 = @{
                               @"companyId": self.isTime ? [HTHoldNullObj getValueWithUnCheakValue:self.shopId] : [HTShareClass shareClass].loginModel.companyId,
                               @"dates":[HTHoldNullObj getValueWithUnCheakValue:self.dates],
                               @"type":[NSString stringWithFormat:@"%d",tag],
                               };
        [dic setDictionary:dic1];
    }else{
        NSDictionary *dic1 = @{
                              @"companyId": self.isTime ? [HTHoldNullObj getValueWithUnCheakValue:self.shopId] : [HTShareClass shareClass].loginModel.companyId,
                              @"beginDate":[HTHoldNullObj getValueWithUnCheakValue:self.beginTime],
                              @"endDate":[HTHoldNullObj getValueWithUnCheakValue:self.endTime],
                              @"ids":[HTHoldNullObj getValueWithUnCheakValue:self.ids],
                              @"reportType":[NSString stringWithFormat:@"%d",tag],
                              @"type":@"1"
                              };
        [dic setDictionary:dic1];
    }
    
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCusRepott,self.isTime ? @"load_boss_customer_compare_date_report_4_app.html" : @"load_boss_customer_report_4_app.html"] params:dic success:^(id json) {
        
        HTSectionOpenModel *model = self.sectionTitleArray[tag];
        if (tag == 0) {
            [self.firstSectionArray removeAllObjects];
            NSArray *titles = @[@"会员总数",@"今日新增",@"本周新增",@"本月新增",@"未录入称呼",@"本月会员储值",@"本月会员消费"];
            NSArray *keys = @[@"totalCount",@"todayTotalCount",@"weekTotalCount",@"thisMonthCount",@"notNameCustomerCount",@"thisMonthAmount",@"vipConsumeAmount"];
            //后缀
            NSArray *suf = @[@"",@"",@"",@"",@"",@"",@""];
            //            前缀
            NSArray *pre = @[@"",@"",@"",@"",@"",@"￥",@"￥"];
            for (int i = 0 ; i < titles.count; i++) {
                HTBossSaleBasicCompareModel *model = [[HTBossSaleBasicCompareModel alloc] init];
                model.title = titles[i];
                model.valueKey = keys[i];
                model.suffix1 = suf[i];
                model.prefix1 = pre[i];
                model.valueArr= [json getArrayWithKey:@"data"];
                [self.firstSectionArray addObject:model];
            }
        }
        if (tag == 1) {
            [self.secondSectionArray removeAllObjects];
            [self.secondSectionArray addObject:[json getArrayWithKey:@"data"]];
        }
        if (tag == 2) {
             [self.thirdSectionArray removeAllObjects];
            NSArray *dataArr = [json getArrayWithKey:@"data"];
            NSArray *titles = @[@"数量",@"占比"];
            NSArray *keys = @[@"total",@"data"];
            //后缀
            NSArray *suf = @[@"",@"%"];
            //前缀
            NSArray *pre = @[@"",@""];
            NSArray *firstDic = [NSArray array];
            for (NSDictionary *dic in dataArr) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObjectsFromArray:[[dic getDictionArrayWithKey:@"sexModel"] getArrayWithKey:@"data"]];
                [arr addObjectsFromArray:[[dic getDictionArrayWithKey:@"ageModel"] getArrayWithKey:@"data"]];
                if (firstDic.count <= arr.count) {
                    firstDic = arr;
                }
            }
            if (dataArr.count > 0) {
                NSMutableArray *DicArr = [NSMutableArray array];
                for (int i = 0; i < firstDic.count; i++) {
                    HTBossMulitCompareModel *model = [[HTBossMulitCompareModel alloc] init];
                    NSDictionary *mostDic = firstDic[i];
                    NSMutableArray *datasArr = [NSMutableArray array];
                    for (int j = 0; j < dataArr.count; j++) {
                        NSDictionary *holdDic = dataArr[j];
                        NSMutableArray *Datas = [NSMutableArray array];
                        NSMutableArray *CountArr = [NSMutableArray array];
                        [Datas addObjectsFromArray:[[holdDic getDictionArrayWithKey:@"sexModel"] getArrayWithKey:@"data"]];
                        [Datas addObjectsFromArray:[[holdDic getDictionArrayWithKey:@"ageModel"] getArrayWithKey:@"data"]];
                        [CountArr addObjectsFromArray:[[holdDic getDictionArrayWithKey:@"sexModel"] getArrayWithKey:@"data"]];
                        [CountArr addObjectsFromArray:[[holdDic getDictionArrayWithKey:@"ageModel"] getArrayWithKey:@"data"]];
                        NSDictionary *dic = i >= Datas.count ? @{} : Datas[i];
                        NSDictionary *dict =  i >= CountArr.count ? @{@"total":@""}  :  CountArr[i];
                        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                        model.title =  [mostDic getStringWithKey:@"name"];
                        [dic1 setObject:[dict getStringWithKey:@"total"]forKey:@"total"];
                        [dic1 setObject:[dic getStringWithKey:@"data"]forKey:@"data"];
                        [datasArr addObject:dic1];
                    }
                    [DicArr addObject:datasArr];
                    [self.thirdSectionArray addObject:model];
                }
                for (int i = 0; i < DicArr.count ; i++) {
                    HTBossMulitCompareModel *model = self.thirdSectionArray[i];
                    NSMutableArray *arrs = DicArr[i];
                    NSMutableArray *arr = [NSMutableArray array];
                    for (int j = 0; j < titles.count; j++) {
                        HTBossMulitSingleCompareModel *model = [[HTBossMulitSingleCompareModel alloc] init];
                        model.title = titles[j];
                        model.valueKey = keys[j];
                        model.suffix1 = suf[j];
                        model.prefix1 = pre[j];
                        model.valueArr = arrs;
                        [arr addObject:model];
                    }
                    model.dataArr = arr;
                }
            }
        }
        if (tag == 3) {
            [self.fourthSectionArray removeAllObjects];
            NSArray *dataArr = [json getArrayWithKey:@"data"];
            NSArray *firstDic = [NSArray array];
            for (NSDictionary *dic in dataArr) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObjectsFromArray:[dic getArrayWithKey:@"customerConsumeTimeApp"]];
                if (firstDic.count <= arr.count) {
                    firstDic = arr;
                }
            }
            NSMutableArray *DicArr = [NSMutableArray array];
            for (int i = 0; i < firstDic.count; i++) {
                NSDictionary *firstDic1 = firstDic[i];
                HTBossMulitCompareModel *model = [[HTBossMulitCompareModel alloc] init];
                model.isLine = YES;
                NSMutableArray *datasArr = [NSMutableArray array];
                model.title = [firstDic1 getStringWithKey:@"key"];
                for (int j = 0 ; j <  dataArr.count; j++) {
                    NSDictionary *d = dataArr[j];
                    NSArray *a = [d getArrayWithKey:@"customerConsumeTimeApp"];
                    [datasArr addObject: i >= a.count ? @{} : a[i]];
                }
                [DicArr addObject:datasArr];
                [self.fourthSectionArray addObject:model];
            }
            for (int i = 0; i < DicArr.count ; i++) {
                HTBossMulitCompareModel *model = self.fourthSectionArray[i];
                NSMutableArray *arrs = DicArr[i];
                CGFloat max  = 0.0;
                for (NSDictionary *dic in arrs) {
                    if ([dic getFloatWithKey:@"val"] > max) {
                        max = [dic getFloatWithKey:@"val"];
                    }
                }
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *colors = @[[UIColor colorWithHexString:@"#6A82FB"],[UIColor colorWithHexString:@"#59B4A5"],[UIColor colorWithHexString:@"#FDB00B"]];
                for (int i = 0 ; i < arrs.count ; i++) {
                    NSDictionary *dic = arrs[i];
                    HTBossVipFrequencyModel *model = [[HTBossVipFrequencyModel  alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.maxVal = [NSString stringWithFormat:@"%lf",max];
                    model.color = colors[i];
                    [arr addObject:model];
                }
                model.dataArr = arr;
            }
        }
        model.isOpen = YES;
        [MBProgressHUD hideHUD];
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:tag];
        [self.dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic]; 
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
- (void)createTb{
    
    if (isIPHONEX) {
        self.leadConstains.constant = SafeAreaBottomHeight;
    }else{
        self.leadConstains.constant = 0.0f;
    }
    
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossSaleBasicContrastCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleBasicContrastCell"];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMultitermBossContrastCell" bundle:nil] forCellReuseIdentifier:@"HTMultitermBossContrastCell"];
     [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBrokenLinesReportCell" bundle:nil] forCellReuseIdentifier:@"HTBrokenLinesReportCell"];
    //    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossDayRankListCell" bundle:nil] forCellReuseIdentifier:@"HTBossDayRankListCell"];
    self.dataTableView.tableFooterView = footView;
}
- (void)createTime{
    NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
    [yearF1 setDateFormat:@"YYYY-MM-dd"];
    NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
    [yearF2 setDateFormat:@"dd"];
    NSString *whichDay = [yearF2 stringFromDate:[NSDate date]];
    NSString *thisMonth = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-1 * (whichDay.integerValue - 1)]];
    NSString *today    = [yearF1 stringFromDate:[NSDate date]];
    self.beginTime = thisMonth;
    self.endTime = today;
}
#pragma mark - getters and setters

- (NSMutableArray *)firstSectionArray{
    if (!_firstSectionArray) {
        _firstSectionArray = [NSMutableArray array];
    }
    return _firstSectionArray;
}
- (NSMutableArray *)secondSectionArray{
    if (!_secondSectionArray) {
        _secondSectionArray = [NSMutableArray array];
    }
    return  _secondSectionArray;
}
-(NSMutableArray *)thirdSectionArray{
    if (!_thirdSectionArray) {
        _thirdSectionArray = [NSMutableArray array];
    }
    return _thirdSectionArray;
}
- (NSMutableArray *)fourthSectionArray{
    if (!_fourthSectionArray) {
        _fourthSectionArray = [NSMutableArray array];
    }
    return _fourthSectionArray;
}
- (NSMutableArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        NSArray *arr =  @[@"基本概况",@"会员增长趋势",@"会员性别及年龄比",@"会员消费分布"];
        _sectionTitleArray = [NSMutableArray array];
        for (int i = 0 ; i < arr.count; i++ ) {
            HTSectionOpenModel *model = [[HTSectionOpenModel alloc] init];
            model.title = arr[i];
            model.isOpen = NO;
            [_sectionTitleArray addObject:model];
        }
        
    }
    return _sectionTitleArray;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[self.firstSectionArray,self.secondSectionArray,self.thirdSectionArray,self.fourthSectionArray];
    }
    return _dataArray;
}
- (HTCompareHeadView *)headerView{
    if (!_headerView) {
        _headerView = [[HTCompareHeadView alloc] initWithHeadFrame:CGRectMake(0, 0, HMSCREENWIDTH, 88)];
        _headerView.delegate = self;
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top);
            if (!isIPHONEX) {
              make.leading.mas_equalTo(self.view.mas_leading);
            }else{
              make.leading.mas_equalTo(self.view.mas_leading).offset(SafeAreaBottomHeight);
            }
          
            make.trailing.mas_equalTo(self.view.mas_trailing);
            make.height.mas_equalTo(@88);
        }];
    }
    return _headerView;
}
@end
