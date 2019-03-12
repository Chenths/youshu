//
//  HTBossSaleReportCompareController.m
//  有术
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBrokenLinesReportCell.h"
#import "HTBossSaleBasicContrastCell.h"
#import "HTMultitermBossContrastCell.h"
#import "HTBossSaleReportCompareController.h"
#import "HTSectionOpenModel.h"
#import "HTBossSectionReportView.h"
#import "NSDate+Manager.h"
#import "HTBossSaleBasicCompareModel.h"
#import "HTBossMulitCompareModel.h"
#import "HTBossMulitSingleCompareModel.h"
#import "HTCompareHeadView.h"
#import "HTBossHeadModel.h"
#import "HTBossSelectedTimeModel.h"
#import "HcdDateTimePickerView.h"
#import "HTBossSelecteTimeController.h"
#import "HTBossSelecteCompareTimeController.h"
#import "HTBossSelecteShopsController.h"
@interface HTBossSaleReportCompareController ()<UITableViewDelegate,UITableViewDataSource,HTCompareHeadViewDeleage>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSMutableArray *sectionTitleArray;

@property (nonatomic,strong) NSMutableArray *firstArray;
//第2组数据
@property (nonatomic,strong) NSMutableArray *secondSectionArray;
////第3组数据
@property (nonatomic,strong) NSMutableArray *thirdSectionArray;
////第4组数据
@property (nonatomic,strong) NSMutableArray *fourthSectionArray;
//第5组数据
@property (nonatomic,strong) NSMutableArray *fifthSectionArray;

@property (nonatomic,strong) HTCompareHeadView *headerView;
@property (nonatomic,strong) HTBossHeadModel *headModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstion;

@property (weak, nonatomic) IBOutlet UIButton *toTopBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstain;


@end

@implementation HTBossSaleReportCompareController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self createTime];
    [self createData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[HTShareClass shareClass].getCurrentNavController setNavigationBarHidden:NO];
}

#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTBossSaleBasicContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleBasicContrastCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.model = self.firstArray[indexPath.row];
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        }else{
            cell.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        }
        return cell;
    }
    if (indexPath.section == 2 ||indexPath.section == 3 ||indexPath.section == 4) {
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
        return cell;
    }
    if (indexPath.section == 1) {
        HTBrokenLinesReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBrokenLinesReportCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.key = @"count";
        cell.dataArr = self.secondSectionArray[indexPath.row];
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
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4) {
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
        self.headerView.frame = CGRectMake( isIPHONEX ? SafeAreaBottomHeight : 0, -32, HMSCREENWIDTH, 88);
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
    [MBProgressHUD showMessage:@"" ];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleMonthReport, self.isTime ? @"load_boss_compare_date_report_4_app.html" :@"load_boss_sale_report_4_app.html"] params:dic success:^(id json) {
        
        HTSectionOpenModel *model = self.sectionTitleArray[tag];
        if (tag == 0) {
            [self.firstArray removeAllObjects];
            NSArray *titles = @[@"利润",@"营业额",@"退换差额",@"销量",@"换货数量",@"退货数量",@"单量",@"VIP销售占比",@"折扣率",@"连带率",@"退货率",@"换货率",@"进店人次",@"客单价",@"件单价",@"回头率",@"新增标签",@"新增储值",@"储值消费",@"支付宝支付",@"微信支付"];
             NSArray *keys = @[@"profit",@"saleAmount",@"exchangeAmount",@"orderProducts",@"exchangeProducts",@"returnProducts",@"orderCount",@"vipSaleScale",@"discount",@"related",@"returnRate",@"exchangeRate",@"flowCountIn",@"customerTransaction",@"piecePrice",@"backUpRate",@"tagCount",@"store",@"consumeStore",@"aliPay",@"weChat"];
            //后缀
            NSArray *suf = @[@"",@"",@"",@"件",@"件",@"件",@"",@"%",@"",@"",@"%",@"%",@"",@"",@"",@"%",@"",@"",@"",@"",@""];
//            前缀
            NSArray *pre = @[@"￥",@"￥",@"￥",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"￥",@"￥",@"",@"",@"￥",@"￥",@"￥",@"￥"];
            for (int i = 0 ; i < titles.count; i++) {
                HTBossSaleBasicCompareModel *model = [[HTBossSaleBasicCompareModel alloc] init];
                model.title = titles[i];
                model.valueKey = keys[i];
                model.suffix1 = suf[i];
                model.prefix1 = pre[i];
                model.valueArr= [json getArrayWithKey:@"data"];
                [self.firstArray addObject:model];
            }
        }
        if (tag == 2) {
            [self.thirdSectionArray removeAllObjects];
            NSArray *dataArr = [json getArrayWithKey:@"data"];
            NSArray *titles = @[@"销量",@"价值",@"占比"];
            NSArray *keys = @[@"count",@"finalprice",@"data"];
            //后缀
            NSArray *suf = @[@"件",@"",@"%"];
            //前缀
            NSArray *pre = @[@"",@"￥",@""];
            NSMutableArray *firstDic = [NSMutableArray array];
            NSMutableArray *dddataArr = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                [dddataArr addObjectsFromArray:[dic getArrayWithKey:@"labelList"]];
            }
            for (NSDictionary *dic in dddataArr) {
                BOOL isIn = NO;
                for (NSDictionary *dict in firstDic) {
                    if ([[dict getStringWithKey:@"name"] isEqualToString:[dic getStringWithKey:@"name"]]) {
                        isIn = YES;
                        break;
                    }
                }
                if (!isIn) {
                    [firstDic addObject:dic];
                }
            }
            if (dataArr.count > 0) {
                NSMutableArray *DicArr = [NSMutableArray array];
                for (int i = 0; i < firstDic.count ; i++) {
                    HTBossMulitCompareModel *model = [[HTBossMulitCompareModel alloc] init];
                    NSDictionary*mostDic = firstDic[i];
                    NSMutableArray *datasArr = [NSMutableArray array];
                    for (int j = 0; j < dataArr.count; j++) {
                        NSDictionary *holdDic = dataArr[j];
                        NSArray *Datas = [[holdDic getStringWithKey:@"data"] ArrayWithJsonString];
                        NSArray *CountArr = [holdDic getArrayWithKey:@"labelList"];
                        NSDictionary *dic = [NSDictionary dictionary];
                        NSDictionary *dict =[ NSDictionary dictionary];
                        for (int t = 0; t < CountArr.count; t++ ) {
                            NSDictionary *hodic  = CountArr[t];
                            if ([[hodic getStringWithKey:@"name"] isEqualToString:[mostDic getStringWithKey:@"name"]]) {
                                dict = CountArr[t];
                                dic = Datas[t];
                                break;
                            }
                        }
                        if (dict.allKeys.count == 0 ) {
                            dict = @{@"count":@"",@"finalprice":@""} ;
                        }
                        if (dic.allKeys.count == 0) {
                            dic = @{@"data":@""} ;
                        }
                        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
                        model.title =  [mostDic getStringWithKey:@"name"];
                        [dic1 setObject:[dict getStringWithKey:@"count"]forKey:@"count"];
                        [dic1 setObject:[dict getStringWithKey:@"finalprice"]forKey:@"finalprice"];
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
            NSArray *titles = @[@"姓名",@"成交价",@"原价",@"时间"];
            NSArray *keys = @[@"pname",@"finalprice",@"totalprice",@"time"];
            //后缀
            NSArray *suf = @[@"",@"",@"",@""];
            //前缀
            NSArray *pre = @[@"",@"￥",@"￥",@""];
             NSArray *dataArr = [json getArrayWithKey:@"data"];
            NSArray *arr = [NSArray array];
            for (NSArray *obj in dataArr) {
                if (obj.count >= arr.count) {
                    arr = obj;
                }
            }
           
            NSMutableArray *DicArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                HTBossMulitCompareModel *model = [[HTBossMulitCompareModel alloc] init];
                NSMutableArray *datasArr = [NSMutableArray array];
                model.title = [NSString stringWithFormat:@"%d",i+1];
                for (int j = 0 ;  j < dataArr.count; j++) {
                    NSArray *a = dataArr[j];
                    [datasArr addObject: i >= a.count ? @{} : a[i]];
                }
                [DicArr addObject:datasArr];
                [self.fourthSectionArray addObject:model];
            }
            for (int i = 0; i < DicArr.count ; i++) {
                HTBossMulitCompareModel *model = self.fourthSectionArray[i];
                model.title = [NSString stringWithFormat:@"%d",i + 1];
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
        if (tag == 4) {
            [self.fifthSectionArray removeAllObjects];
            NSArray *titles = @[@"姓名",@"总金额",@"原价",@"销量",@"单量",@"退货量",@"退换差额",@"折扣率",@"连带率"];
            NSArray *keys = @[@"name",@"moneyCurrent",@"totalMoneyCurrent",@"totalCurrent",@"orderNumCurrent",@"orderNumRe",@"totalMoneyRe",@"discount",@"serialUP"];
            //后缀
            NSArray *suf = @[@"",@"",@"",@"",@"",@"",@"",@"",@""];
            //前缀
            NSArray *pre = @[@"",@"￥",@"￥",@"",@"",@"",@"￥",@"",@""];
            NSArray *dataArr = [json getArrayWithKey:@"data"];
            NSArray *arr = [NSArray array];
            for (NSArray *obj in dataArr) {
                if (obj.count >= arr.count) {
                    arr = obj;
                }
            }
            NSMutableArray *DicArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                HTBossMulitCompareModel *model = [[HTBossMulitCompareModel alloc] init];
                NSMutableArray *datasArr = [NSMutableArray array];
                model.title = [NSString stringWithFormat:@"%d",i+1];
                for (int j = 0 ; j <  dataArr.count; j++) {
                    NSArray *a = dataArr[j];
                    [datasArr addObject: i >= a.count ? @{} : a[i]];
                }
                [DicArr addObject:datasArr];
                [self.fifthSectionArray addObject:model];
            }
            for (int i = 0; i < DicArr.count ; i++) {
                HTBossMulitCompareModel *model = self.fifthSectionArray[i];
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
        if (tag == 1) {
            [self.secondSectionArray removeAllObjects];
            [self.secondSectionArray addObject:[json getArrayWithKey:@"data"]];
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
        self.leadConstain.constant = SafeAreaBottomHeight;
    }else{
        self.leadConstain.constant = 0.0f;
    }
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossSaleBasicContrastCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleBasicContrastCell"];
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBrokenLinesReportCell" bundle:nil] forCellReuseIdentifier:@"HTBrokenLinesReportCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTMultitermBossContrastCell" bundle:nil] forCellReuseIdentifier:@"HTMultitermBossContrastCell"];
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

- (NSMutableArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        NSArray *arr =  @[@"基本概况",@"营业趋势",@"销售品类占比",@"大单排行",@"员工销售排行榜"];
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
- (NSMutableArray *)firstArray{
    if (!_firstArray) {
        _firstArray = [NSMutableArray array];
    }
    return _firstArray;
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
- (NSMutableArray *)fifthSectionArray{
    if (!_fifthSectionArray) {
        _fifthSectionArray = [NSMutableArray array];
    }
    return _fifthSectionArray;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[self.firstArray,self.secondSectionArray,self.thirdSectionArray,self.fourthSectionArray,self.fifthSectionArray];
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
            if (isIPHONEX) {
            make.leading.mas_equalTo(self.view.mas_leading).offset(SafeAreaBottomHeight);
            }else{
             make.leading.mas_equalTo(self.view.mas_leading);
            }
            make.trailing.mas_equalTo(self.view.mas_trailing);
            make.height.mas_equalTo(@88);
        }];
    }
    return _headerView;
}

@end
