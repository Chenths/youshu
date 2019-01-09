//
//  HTGSaleReportViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTChooseDateTableViewCell.h"
#import "HTBossSaleBasicInfoCell.h"
#import "HTBarGraphTableViewCell.h"
#import "HTSaleContributionInfoCell.h"
#import "HTGuideSaleInfoTableViewCell.h"
#import "HTGudieSaleRankListCell.h"
#import "HTSaleProductInfoCell.h"
#import "HTSeasonChooseHeaderCell.h"
#import "HTGSaleReportViewController.h"
#import "HTSeemoreFooterView.h"
#import "HTDefaulTitleHeadView.h"
#import "HTSeemoreHeaderView.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTIndexesBox.h"
#import "HTIndexsModel.h"
#import "HTGuideSaleDescInfoController.h"
#import "HTBossReportBasciModel.h"
#import "HTShopSaleReportModel.h"
#import "HTLineDataReportTableViewCell.h"
#import "HcdDateTimePickerView.h"
#import "HTChooseBetweenDateCell.h"
#import "HTSaleProductRankListController.h"
#import "HTUnderstockListAlertView.h"
#import "NSDate+Manager.h"
@interface HTGSaleReportViewController ()<UITableViewDelegate,UITableViewDataSource,HTSeemoreHeaderViewDelegate,HTNewPieCellTableViewCellDelegate,HTSeasonChooseHeaderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableArray *headArray;

@property (nonatomic,strong) NSMutableArray *footArray;

@property (nonatomic,strong) HTIndexesBox *indexBox;

@property (nonatomic,strong) HTShopSaleReportModel *reportModel;

@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *warningDescBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btHeight;



@end

@implementation HTGSaleReportViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"销售报表";
    [self configDate];
    [self createTb];
    [self loadData];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reportModel.bascArray.count == 0 ? 0 : self.cellsName.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *cells = self.cellsName[section];
    return  self.reportModel.bascArray.count == 0 ? 0 : [cells count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *names = self.cellsName[indexPath.section];
    NSString *cellName = names[indexPath.row];
    
    if ([cellName isEqualToString:@"HTChooseDateTableViewCell"]) {
        HTChooseDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel;
        return  cell;
    }else if ([cellName isEqualToString:@"HTBossSaleBasicInfoCell"]) {
        HTBossSaleBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleBasicInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel.bascArray[indexPath.row];
        return  cell;
    }else if ([cellName isEqualToString:@"HTLineDataReportTableViewCell"]) {
        HTLineDataReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLineDataReportTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isDefual = YES;
        cell.dataArray = self.reportModel.amountList;
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleContributionInfoCell"]) {
        HTSaleContributionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleContributionInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel.employeeContribution;
        return  cell;
    }else if ([cellName isEqualToString:@"HTGuideSaleInfoTableViewCell"]) {
        HTGuideSaleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTGuideSaleInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTGuideSaleInfoModel *model = self.reportModel.employeeContribution.data[indexPath.row];
        model.index = indexPath;
        cell.model = self.reportModel.employeeContribution.data[indexPath.row];
        return  cell;
    }else if ([cellName isEqualToString:@"HTGudieSaleRankListCell"]) {
        HTGudieSaleRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTGudieSaleRankListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTBigOrderModel *model = self.reportModel.bigOrderMap[indexPath.row];
        model.index = indexPath;
        cell.model = model;
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleProductInfoCell"]) {
        HTSaleProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleProductInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.reportModel.productRank[indexPath.row - 2];
        return  cell;
    }else if([cellName isEqualToString:@"HTNewPieCellTableViewCell"]){
        HTNewPieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPieCellTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.beginTime = [HTHoldNullObj getValueWithUnCheakValue:self.reportModel.beginTime];
        cell.endTime = [HTHoldNullObj getValueWithUnCheakValue:self.reportModel.endTime];
        cell.companyId = self.companyId;
        cell.model = indexPath.section == 6 ? self.reportModel.categrieModel : self.reportModel.customTypeModel;
        cell.delegate = self;
        return  cell;
    }else if ([cellName isEqualToString:@"HTChooseBetweenDateCell"]){
        HTChooseBetweenDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseBetweenDateCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.reportModel = self.reportModel;
        return cell;
    }
    else{
        HTSeasonChooseHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSeasonChooseHeaderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = self.reportModel;
        return  cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSString *footer = self.footArray[section];
    if (footer.length == 0) {
        return 0.001f;
    }else{
        return 48;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *header = self.headArray[section];
    if (header.length == 0) {
        return 0.001f;
    }else{
        return 48;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *footer = self.footArray[section];
    if (footer.length == 0) {
        return nil;
    }else{
        HTSeemoreFooterView *footer = [[NSBundle mainBundle] loadNibNamed:@"HTSeemoreFooterView" owner:nil options:nil].lastObject;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seemore:)];
        footer.tag = 500 + section;
        [footer addGestureRecognizer:tap];
        return footer;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.indexBox.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:section];
    NSString *header =  self.headArray[section];
    if (header.length == 0) {
        return nil;
    }else{
        if (section == 4 ) {
            HTSeemoreHeaderView *head = [[NSBundle mainBundle] loadNibNamed:@"HTSeemoreHeaderView" owner:nil options:nil].lastObject;
            head.delegate = self;
            return head;
        }else{
            HTDefaulTitleHeadView *head = [[NSBundle mainBundle] loadNibNamed:@"HTDefaulTitleHeadView" owner:nil options:nil].lastObject;
            head.title = self.headArray[section];
            return head;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTChooseDateTableViewCell class]]) {
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self)  weakSelf = self;
        dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.reportModel.beginTime = beginTime;
            strongSelf.reportModel.endTime = endTime;
            [strongSelf loadData];
        } ;
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTChooseBetweenDateCell class]]) {
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self)  weakSelf = self;
        dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.reportModel.productBeginTime = beginTime;
            strongSelf.reportModel.productEndTime = endTime;
            [strongSelf loadSeasonData];
        } ;
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= 100) {
        if (self.indexBox.hidden) {
            self.indexBox.alpha = 0.0;
            self.indexBox.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.indexBox.alpha = 1;
            }];
        }
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.indexBox.alpha = 0;
        } completion:^(BOOL finished) {
            self.indexBox.hidden = YES;
        }];
    }
}

#pragma mark -CustomDelegate
-(void)seemoreClickedWithCell:(HTNewPieCellTableViewCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:5];
}
-(void)moreClicked{
    HTGuideSaleDescInfoController *vc = [[HTGuideSaleDescInfoController alloc] init];
    vc.dataArray = self.reportModel.employeeContribution.data;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectedSeasonWithIndex:(NSInteger)index{
    self.reportModel.season = [NSString stringWithFormat:@"%ld",index];
    [self loadSeasonData];
}
#pragma mark -EventResponse
-(void)seemore:(UITapGestureRecognizer *)tap{
    UIView *vv = tap.view;
    NSInteger index = vv.tag - 500;
//    销售贡献查看更多
    if (index == 4) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.reportModel.employeeContribution.data.count; i++) {
            [arr addObject:@"HTGuideSaleInfoTableViewCell"];
        }
        [self.cellsName replaceObjectAtIndex:4 withObject:arr];
        [self.footArray replaceObjectAtIndex:4 withObject:@""];
    }
//    大单排行查看更多
    if (index == 5) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.reportModel.bigOrderMap.count; i++) {
            [arr addObject:@"HTGudieSaleRankListCell"];
        }
        [self.cellsName replaceObjectAtIndex:5 withObject:arr];
        [self.footArray replaceObjectAtIndex:5 withObject:@""];
    }
//    产品销量榜
    if (index == 8) {
        HTSaleProductRankListController *vc = [[HTSaleProductRankListController alloc] init];
        vc.model = self.reportModel;
        vc.companyId = self.companyId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:0];
}
- (IBAction)seeWaningDescClicked:(id)sender {
    [HTUnderstockListAlertView  showAlertWithWarningArray:self.warningArr tilte:@"该模块中存在下列预警" btsArray:@[@"取消",@"确定"] okBtclicked:^{
    } cancelClicked:^{
    } andInClick:^(NSIndexPath *index) {
        HTWarningModel *mm = self.warningArr[index.row];
       [self.tab scrollToRowAtIndexPath:mm.waringIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }];
}
- (IBAction)colseWarningView:(id)sender {
    self.warningView.hidden = YES;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    [self.tab layoutIfNeeded];
}
#pragma mark -private methods
-(void)configDate{
    if ([self.dateMode isEqualToString:@"month"] && self.dateStr.length > 0) {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"YYYY-MM-dd"];
        if ([self.dateStr isEqualToString:[formate stringFromDate:[NSDate date]]]) {
           self.reportModel.beginTime = [NSString stringWithFormat:@"%@-01",[self.dateStr substringWithRange:NSMakeRange(0, 7)]];
           self.reportModel.endTime = self.dateStr;
        }else{
            self.reportModel.beginTime = [NSString stringWithFormat:@"%@-01",[self.dateStr substringWithRange:NSMakeRange(0, 7)]];
            NSDate *date = [formate dateFromString:self.dateStr];
            NSDate *futureMonth = [date dateByAddingMonths:1];
            NSString *futureDate = [formate stringFromDate:futureMonth];
            NSString *futureFirstDay =  [NSString stringWithFormat:@"%@-01",[futureDate substringWithRange:NSMakeRange(0, 7)]];
            NSDate *futureFirstDayDate = [formate dateFromString:futureFirstDay];
            self.reportModel.endTime =[formate stringFromDate: [futureFirstDayDate dateBySubingDays:-1]];
        }
    }else if ([self.dateMode isEqualToString:@"weak"] && self.dateStr.length > 0){
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSDate *date1 = [yearF1 dateFromString:self.dateStr];
        //今天
        //这周一
        NSString *firstWeakDay = [yearF1 stringFromDate: [date1 dateBySubingDays:-6]];
        self.reportModel.beginTime = firstWeakDay;
        self.reportModel.endTime = self.dateStr;
    }
}
-(void)loadSeasonData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"beginDate":[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.productBeginTime],
                          @"endDate":[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.productEndTime],
                          @"season":[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.season]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleSaleReport,loadSaleProductRankReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSMutableArray *products = [NSMutableArray array];
        for (NSDictionary *dic in json[@"data"]) {
            [products addObject:[HTProductRankInfoModel yy_modelWithJSON:dic]];
        }
        self.reportModel.productRank =  products;
        NSMutableArray *arr1 = [NSMutableArray array];
        [arr1 addObject:@"HTChooseBetweenDateCell"];
        [arr1 addObject:@"HTSeasonChooseHeaderCell"];
        for (int i = 0; i < self.reportModel.productRank.count; i++) {
            [arr1 addObject:@"HTSaleProductInfoCell"];
        }
        [self.cellsName replaceObjectAtIndex:8 withObject:arr1];
        [self.footArray replaceObjectAtIndex:8 withObject:@"产品销量榜"];
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:8] withRowAnimation:0];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"beginDate":[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.beginTime],
                          @"endDate":[HTHoldNullObj getValueWithUnCheakValue:self.reportModel.endTime],
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleSaleReport,loadSaleDataReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *begin = [HTHoldNullObj getValueWithUnCheakValue:self.reportModel.beginTime];
        NSString *end = [HTHoldNullObj getValueWithUnCheakValue:self.reportModel.endTime];
        self.reportModel = [HTShopSaleReportModel yy_modelWithJSON:json[@"data"]];
        NSArray *titles1 = @[@"利润",@"销量",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费", @""];
        NSArray *titles2 = @[@"营业额",@"换货数量",@"VIP销售占比",@"退货率",@"客单价",@"新增标签",@"支付宝支付", @"VIP新增数"];
        NSArray *titles3 = @[@"退换差额",@"退货数量",@"折扣",@"换货率",@"件单价",@"新增储值",@"微信支付", @"老VIP成交数"];
        NSArray *keys1 = @[@"profit",@"orderProducts",@"orderCount",@"related",@"flowCountIn",@"backUpRate",@"consumeStore", @""];
        NSArray *keys2 = @[@"saleAmount",@"exchangeProducts",@"vipSaleScale",@"returnRate",@"customerTransaction",@"tagCount",@"aliPay", @"newCustomerCount"];
        NSArray *keys3 = @[@"exchangeAndReturnAmount",@"returnProducts",@"discount",@"exchangeRate",@"piecePrice",@"store",@"weChat", @"oldCustomerCount"];
        NSArray *prefix1 = @[@"￥",@"",@"",@"",@"",@"",@"￥", @""];
        NSArray *prefix2 = @[@"￥",@"",@"",@"",@"￥",@"",@"￥", @""];
        NSArray *prefix3 = @[@"￥",@"",@"",@"",@"￥",@"￥",@"￥", @""];
        NSArray *suffix1  = @[@"",@"件",@"单",@"",@"人",@"%",@"", @""];
        NSArray *suffix2  = @[@"",@"件",@"%",@"%",@"",@"",@"", @"人"];
        NSArray *suffix3  = @[@"",@"件",@"折",@"%",@"",@"",@"", @"人"];
        NSArray *imageName  = @[@"利润",@"矢量智能对象5",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费", @""];
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *cellArr = [NSMutableArray array];
        for (int  i = 0; i < titles1.count; i++) {
            HTBossReportBasciModel *model = [[HTBossReportBasciModel alloc] init];
            model.title1 = titles1[i];
            model.title2 = titles2[i];
            model.title3 = titles3[i];
            model.value1 = [json[@"data"] getStringWithKey:keys1[i]];
            model.value2 = [json[@"data"] getStringWithKey:keys2[i]];
            model.value3 = [json[@"data"] getStringWithKey:keys3[i]];
            model.suffix1 = suffix1[i];
            model.suffix2 = suffix2[i];
            model.suffix3 = suffix3[i];
            model.prefix1 = prefix1[i];
            model.prefix2 = prefix2[i];
            model.prefix3 = prefix3[i];
            model.imgName = imageName[i];
            [arr addObject:model];
            [cellArr addObject:@"HTBossSaleBasicInfoCell"];
        }
        [self.cellsName replaceObjectAtIndex:1 withObject:cellArr];
        self.reportModel.bascArray = arr;
//        配置销售排行榜数据
        if (self.reportModel.employeeContribution.data.count > 3) {
            [self.cellsName replaceObjectAtIndex:4 withObject:@[@"HTGuideSaleInfoTableViewCell",@"HTGuideSaleInfoTableViewCell",@"HTGuideSaleInfoTableViewCell"]];
            [self.footArray replaceObjectAtIndex:4 withObject:@"销售排行榜"];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.reportModel.employeeContribution.data.count; i++) {
                [arr addObject:@"HTGuideSaleInfoTableViewCell"];
            }
            [self.cellsName replaceObjectAtIndex:4 withObject:arr];
            [self.footArray replaceObjectAtIndex:4 withObject:@""];
        }
//        配置大单排行
        if (self.reportModel.bigOrderMap.count > 3) {
            [self.cellsName replaceObjectAtIndex:5 withObject:@[@"HTGudieSaleRankListCell",@"HTGudieSaleRankListCell",@"HTGudieSaleRankListCell"]];
            [self.footArray replaceObjectAtIndex:5 withObject:@"大单排行榜"];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.reportModel.bigOrderMap.count; i++) {
                [arr addObject:@"HTGudieSaleRankListCell"];
            }
            [self.cellsName replaceObjectAtIndex:5 withObject:arr];
            [self.footArray replaceObjectAtIndex:5 withObject:@""];
        }
//        配置产品销量榜
        NSMutableArray *arr1 = [NSMutableArray array];
        [arr1 addObject:@"HTChooseBetweenDateCell"];
        [arr1 addObject:@"HTSeasonChooseHeaderCell"];
        for (int i = 0; i < self.reportModel.productRank.count; i++) {
            [arr1 addObject:@"HTSaleProductInfoCell"];
        }
        [self.cellsName replaceObjectAtIndex:8 withObject:arr1];
        [self.footArray replaceObjectAtIndex:8 withObject:@"产品销量榜"];
        self.reportModel.beginTime = begin;
        self.reportModel.endTime = end;
        [self.tab reloadData];
        if (self.selectdWarning) {
            [self.tab scrollToRowAtIndexPath:self.selectdWarning.waringIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTChooseDateTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTChooseDateTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTBossSaleBasicInfoCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleBasicInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTLineDataReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTLineDataReportTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleContributionInfoCell" bundle:nil] forCellReuseIdentifier:@"HTSaleContributionInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTGuideSaleInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTGuideSaleInfoTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTGudieSaleRankListCell" bundle:nil] forCellReuseIdentifier:@"HTGudieSaleRankListCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleProductInfoCell" bundle:nil] forCellReuseIdentifier:@"HTSaleProductInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSeasonChooseHeaderCell" bundle:nil] forCellReuseIdentifier:@"HTSeasonChooseHeaderCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewPieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPieCellTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTChooseBetweenDateCell" bundle:nil] forCellReuseIdentifier:@"HTChooseBetweenDateCell"];
    
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight + 48;
    self.btHeight.constant = SafeAreaBottomHeight;
    
//    配置警告视图
    [self.warningDescBt changeCornerRadiusWithRadius:3];
    [self.warningDescBt changeBorderStyleColor:[UIColor whiteColor] withWidth:1];
    
    if (self.warningArr.count > 0) {
        self.warningView.hidden = NO;
        self.warningLabel.text =  [NSString stringWithFormat:@"本页存在 %ld 处报警",self.warningArr.count];
    }else{
        self.warningView.hidden = YES;
    }
}
#pragma mark - getters and setters

-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTChooseDateTableViewCell"]];
        [_cellsName addObject:@[@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell"]];
        [_cellsName addObject:@[@"HTLineDataReportTableViewCell"]];
        [_cellsName addObject:@[@"HTSaleContributionInfoCell"]];
        [_cellsName addObject:@[@"HTGuideSaleInfoTableViewCell",@"HTGuideSaleInfoTableViewCell",@"HTGuideSaleInfoTableViewCell",@"HTGuideSaleInfoTableViewCell"]];
        [_cellsName addObject:@[@"HTGudieSaleRankListCell",@"HTGudieSaleRankListCell",@"HTGudieSaleRankListCell",@"HTGudieSaleRankListCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTSeasonChooseHeaderCell",@"HTSaleProductInfoCell",@"HTSaleProductInfoCell",@"HTSaleProductInfoCell",@"HTSaleProductInfoCell"]];
    }
    return _cellsName;
}
-(NSMutableArray *)headArray{
    if (!_headArray) {
        _headArray = [NSMutableArray array];
        [_headArray addObject:@""];
        [_headArray addObject:@"基本概况"];
        [_headArray addObject:@"营业趋势"];
        [_headArray addObject:@"销售贡献榜"];
        [_headArray addObject:@"123"];
        [_headArray addObject:@"大单排行榜"];
        [_headArray addObject:@"销售大类占比"];
        [_headArray addObject:@"销售品类占比"];
        [_headArray addObject:@"产品销量榜"];
        
    }
    return _headArray;
}
-(NSMutableArray *)footArray{
    if (!_footArray) {
        _footArray= [NSMutableArray array];
        [_footArray addObject:@""];
        [_footArray addObject:@""];
        [_footArray addObject:@""];
        [_footArray addObject:@""];
        [_footArray addObject:@"alkjdklj"];
        [_footArray addObject:@"大单排行榜"];
        [_footArray addObject:@""];
        [_footArray addObject:@""];
        [_footArray addObject:@"产品销售占比"];
    }
    return _footArray;
}
-(HTIndexesBox *)indexBox{
    if (!_indexBox) {
        NSArray *tites = @[@"基本概况",@"营业趋势",@"销售贡献榜",@"大单排行榜",@"销售品类占比",@"销售品类占比",@"产品销量榜"];
        
        NSArray *indexs = @[[NSIndexPath indexPathForRow:0 inSection:1],[NSIndexPath indexPathForRow:0 inSection:2],[NSIndexPath indexPathForRow:0 inSection:3],[NSIndexPath indexPathForRow:0 inSection:5],[NSIndexPath indexPathForRow:0 inSection:6],[NSIndexPath indexPathForRow:0 inSection:7],[NSIndexPath indexPathForRow:0 inSection:8]];
        NSMutableArray *datas = [NSMutableArray array];
        for (int i = 0; i < tites.count;i++ ) {
            HTIndexsModel *model = [[HTIndexsModel alloc] init];
            model.titles = tites[i];
            model.indexpath = indexs[i];
            [datas addObject:model];
        }
        _indexBox = [[HTIndexesBox alloc] initWithBoxFrame:CGRectMake(0, 0, HMSCREENWIDTH, 48) ];
        _indexBox.backgroundColor = [UIColor whiteColor];
        _indexBox.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _indexBox.srollerToIndex = ^(NSIndexPath *index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tab scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
        [_indexBox initSubviewswithDatas:datas];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_indexBox];
        });
    }
    return _indexBox;
}
-(HTShopSaleReportModel *)reportModel{
    if (!_reportModel) {
        _reportModel = [[HTShopSaleReportModel alloc] init];
    }
    return _reportModel;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}
@end
