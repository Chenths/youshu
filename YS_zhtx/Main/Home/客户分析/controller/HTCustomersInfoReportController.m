//
//  HTCustomersInfoReportController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTRankDataoboutCustomerCell.h"
#import "HTManyLineBarDataTableViewCell.h"
#import "HTDefaulDataLineTableViewCell.h"
#import "HTDataPropressLineCell.h"
#import "HTChooseBetweenDateCell.h"
#import "HTLineDataReportTableViewCell.h"
#import "HTCustomersReportBaceInfoCell.h"
#import "HTTotleVipNumsTableViewCell.h"
#import "HTAgeAndeSexInfoReportCell.h"
#import "HTCustomersInfoReportController.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTSeemoreFooterView.h"
#import "HTSeemoreHeaderView.h"
#import "HTDefaulTitleHeadView.h"
#import "HTCustomersInfoReprotModel.h"
#import "HcdDateTimePickerView.h"
#import "NSDate+Manager.h"
#import "HTCustomerReportViewController.h"
@interface HTCustomersInfoReportController ()<UITableViewDelegate,UITableViewDataSource,HTLineDataReportTableViewCellDelegate,HTNewPieCellTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (nonatomic,strong) NSMutableArray *cellsName;
@property (nonatomic,strong) NSMutableArray *headArray;
@property (nonatomic,strong) NSMutableArray *footerArray;
@property (nonatomic,strong) HTCustomersInfoReprotModel *customersModel;

@property (nonatomic,strong) NSString *sBeginTime;

@property (nonatomic,strong) NSString *sEndTime;

@end

@implementation HTCustomersInfoReportController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客群分析";
    [self createTb];
    [self loadData];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.customersModel ?  self.cellsName.count : 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *cells = self.cellsName[section];
    return   self.customersModel ? cells.count : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *names = self.cellsName[indexPath.section];
    NSString *cellName = names[indexPath.row];
    if ([cellName isEqualToString:@"HTTotleVipNumsTableViewCell"]) {
        HTTotleVipNumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTotleVipNumsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.customersModel;
        return cell;
    }else if ([cellName isEqualToString:@"HTCustomersReportBaceInfoCell"]) {
        HTCustomersReportBaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomersReportBaceInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.customersModel;
        return cell;
    }else if ([cellName isEqualToString:@"HTDefaulDataLineTableViewCell"]) {
        HTDefaulDataLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDefaulDataLineTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.color = [UIColor colorWithHexString:@"#614DB6"];
            cell.selectedColor = [UIColor colorWithHexString:@"#A391F1"];
            cell.model = self.customersModel.custLevelCount;
            
        }
        if (indexPath.row == 1) {
            cell.color = [UIColor colorWithHexString:@"#59B4A5"];
            cell.selectedColor = [UIColor colorWithHexString:@"#86E2D3"];
            cell.model = self.customersModel.custLevelPoint;
        }
        return cell;
    }else if ([cellName isEqualToString:@"HTDataPropressLineCell"]) {
        HTDataPropressLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDataPropressLineCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.beginTime = self.customersModel.consumeTimeBegin;
        cell.endTime = self.customersModel.consumeTimeEnd;
        cell.companyId = self.companyId;
        if (indexPath.row == 2) {
            cell.title = @"频次分布";
//            cell.color = [UIColor colorWithHexString:@"#614DB6"];
            cell.secondArray = self.customersModel.customerConsumeTimeApp2;
            cell.dataArray = self.customersModel.customerConsumeTimeApp;
        }
        if (indexPath.row == 3) {
            cell.title = @"金额分布";
//            cell.color = [UIColor colorWithHexString:@"#FC5C7D"];
            cell.secondArray = self.customersModel.amountDistribute2;
            cell.dataArray = self.customersModel.amountDistribute;
        }
//        if (indexPath.row == 4) {
//            cell.title = @"频次分布";
//            cell.color = [UIColor colorWithHexString:@"#614DB6"];
//            cell.dataArray = self.customersModel.customerSecConsumeTimeApp;
//        }
//        if (indexPath.row == 5) {
//            cell.title = @"金额分布";
//            cell.color = [UIColor colorWithHexString:@"#FC5C7D"];
//            cell.dataArray = self.customersModel.amountSecDistribute;
//        }
        return cell;
    }else if ([cellName isEqualToString:@"HTChooseBetweenDateCell"]) {
        HTChooseBetweenDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseBetweenDateCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index = indexPath;
        cell.showColor = YES;
        cell.model = self.customersModel;
        return cell;
    }else if ([cellName isEqualToString:@"HTLineDataReportTableViewCell"]) {
        HTLineDataReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTLineDataReportTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = self.customersModel.addCustomer;
        cell.delegate = self;
        cell.model = self.customersModel;
        return cell;
    }else if ([cellName isEqualToString:@"HTManyLineBarDataTableViewCell"]) {
        HTManyLineBarDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTManyLineBarDataTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.customersModel.custLevelStore;
        return cell;
    }else if ([cellName isEqualToString:@"HTRankDataoboutCustomerCell"]){
        HTRankDataoboutCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTRankDataoboutCustomerCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = indexPath.section == 6 ? self.customersModel.consume[indexPath.row - 1] : self.customersModel.storeAccount[indexPath.row];
        return cell;
    }else if ([cellName isEqualToString:@"HTAgeAndeSexInfoReportCell"]) {
        
        HTAgeAndeSexInfoReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTAgeAndeSexInfoReportCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sexModel = self.customersModel.sexModel;
        cell.ageModel = self.customersModel.ageModel;
        cell.companyId = self.companyId;
        [cell createSubWithAgelist:self.customersModel.ageModel.data andSexList:self.customersModel.sexModel.data];
        return cell;
    }else if ([cellName isEqualToString:@"HTNewPieCellTableViewCell"]){
        
        HTNewPieCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewPieCellTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.customersModel.activeModel;
        cell.companyId = self.companyId;
        cell.delegate = self;
        return cell;
    } else{
        HTTotleVipNumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTTotleVipNumsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.customersModel;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSString *footer = self.footerArray[section];
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
    NSString *footer = self.footerArray[section];
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
    NSString *header =  self.headArray[section];
    if (header.length == 0) {
        return nil;
    }else{
      HTDefaulTitleHeadView *head = [[NSBundle mainBundle] loadNibNamed:@"HTDefaulTitleHeadView" owner:nil options:nil].lastObject;
      head.title = self.headArray[section];
      return head;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.tab cellForRowAtIndexPath:indexPath] isKindOfClass:[HTChooseBetweenDateCell class]]) {
        if (indexPath.section == 2) {
//            消费时间选择
            HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
            dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
            __weak typeof(self)  weakSelf = self;
            dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (indexPath.row == 0) {
                    //第一开始时间
                    self.customersModel.consumeTimeBegin = beginTime;
                    //结束
                    self.customersModel.consumeTimeEnd = endTime;
                    
                    [strongSelf loadCustomerConsumeWithBeginTime:beginTime AndEndTime:endTime andType:YES];
                }else{
                    //第二开始时间
                    self.customersModel.consumeTimeSecBegin = beginTime;
                    //第二结束时间
                    self.customersModel.consumeTimeSecEnd = endTime;
                    [strongSelf loadCustomerConsumeWithBeginTime:beginTime AndEndTime:endTime andType:NO];
                }
            } ;
            [self.view addSubview:dateTimePickerView];
            [dateTimePickerView showHcdDateTimePicker];
        }
        if (indexPath.section == 6) {
//            排行时间选择
            HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
            dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
            __weak typeof(self)  weakSelf = self;
            dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf loadCustomerConsumeRankWithBeginTime:beginTime AndEndTime:endTime];
            } ;
            [self.view addSubview:dateTimePickerView];
            [dateTimePickerView showHcdDateTimePicker];
        }
    }else if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTRankDataoboutCustomerCell class]]) {
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        HTRankReportSingleCustomerModel *model  = indexPath.section == 6 ? self.customersModel.consume[indexPath.row - 1] : self.customersModel.storeAccount[indexPath.row];
        HTCustomerListModel *mm = [[HTCustomerListModel alloc] init];
        mm.custId = [HTHoldNullObj getValueWithUnCheakValue:model.customerId].length == 0 ? [HTHoldNullObj getValueWithUnCheakValue:model.customerid] : [HTHoldNullObj getValueWithUnCheakValue:model.customerId] ;
        vc.model = mm;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -CustomDelegate
-(void)seemoreClickedWithCell:(HTNewPieCellTableViewCell *)cell{
    NSIndexPath *index = [self.tab indexPathForCell:cell];
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:index.section] withRowAnimation:5];
}
-(void)dateClicked{
    HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
    dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
    __weak typeof(self)  weakSelf = self;
    dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadAddCustomerWithBeginTime:beginTime AndEndTime:endTime];
    } ;
    [self.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
}

#pragma mark -EventResponse
-(void)seemore:(UITapGestureRecognizer *)tap{
    UIView *vv = tap.view;
    NSInteger index = vv.tag - 500;
    if (index == 6) {
        self.customersModel.consumeOpen = YES;
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"HTChooseBetweenDateCell"];
        for (int i = 0; i < self.customersModel.consume.count; i++) {
            [arr addObject:@"HTRankDataoboutCustomerCell"];
        }
        [self.cellsName replaceObjectAtIndex:index withObject:arr];
        [self.footerArray replaceObjectAtIndex:index withObject:@""];
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:0];
    }
    if (index == 7) {
        self.customersModel.stordOpen = YES;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < self.customersModel.storeAccount.count; i++) {
            [arr addObject:@"HTRankDataoboutCustomerCell"];
        }
        [self.cellsName replaceObjectAtIndex:index withObject:arr];
        [self.footerArray replaceObjectAtIndex:index withObject:@""];
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:5];
    }
}
#pragma mark -private methods
//会员增长趋势
-(void)loadAddCustomerWithBeginTime:(NSString *)beginTime AndEndTime:(NSString *)endTime{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"beginDate":beginTime,
                          @"endDate":endTime
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCustomerReport,loadAddCustomerReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
            HTSingleLineReportModel *model = [HTSingleLineReportModel yy_modelWithJSON:dic];
            [arr addObject:model];
        }
        self.customersModel.addCustomer = arr;
        self.customersModel.vipAddTimeBegin = beginTime;
        self.customersModel.vipAddTimeEnd = endTime;
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:5];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)loadCustomerConsumeWithBeginTime:(NSString *)beginTime AndEndTime:(NSString *)endTime andType:(BOOL)isFirst{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"beginDate":self.customersModel.consumeTimeBegin,
                          @"endDate":self.customersModel.consumeTimeEnd,
                          @"beginDateCom":self.customersModel.consumeTimeSecBegin,
                          @"endDateCom":self.customersModel.consumeTimeSecEnd
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCustomerReport,loadcustomerConsumeReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSArray *amount = [json[@"data"] getArrayWithKey:@"amount"];
        NSArray *amount2 = [json[@"data"] getArrayWithKey:@"amount2"];
        NSArray *time = [json[@"data"] getArrayWithKey:@"time"];
        NSArray *time2 = [json[@"data"] getArrayWithKey:@"time2"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in amount) {
            [arr addObject:[HTHorizontalReportDataModel yy_modelWithJSON:dic]];
        }
        
        NSMutableArray *arr2 = [NSMutableArray array];
        for (NSDictionary *dic in amount2) {
            [arr2 addObject:[HTHorizontalReportDataModel yy_modelWithJSON:dic]];
        }
        
          self.customersModel.amountDistribute = arr;
        
          self.customersModel.amountDistribute2 = arr2;
        
        
        NSMutableArray *arr3 = [NSMutableArray array];
        for (NSDictionary *dic in time) {
            [arr3 addObject:[HTHorizontalReportDataModel yy_modelWithJSON:dic]];
        }
        
        NSMutableArray *arr4 = [NSMutableArray array];
        for (NSDictionary *dic in time2) {
            [arr4 addObject:[HTHorizontalReportDataModel yy_modelWithJSON:dic]];
        }
        
        self.customersModel.customerConsumeTimeApp = arr3;
        self.customersModel.customerConsumeTimeApp2 = arr4;

     
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:5];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)loadCustomerConsumeRankWithBeginTime:(NSString *)beginTime AndEndTime:(NSString *)endTime{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"beginDate":beginTime,
                          @"endDate":endTime
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCustomerReport,loadcustomerConsumeRankReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        NSArray *consume = [json[@"data"] getArrayWithKey:@"consume"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in consume) {
            [arr addObject:[HTRankReportSingleCustomerModel yy_modelWithJSON:dic]];
        }
        self.customersModel.consume = arr;
        if (self.customersModel.consume.count > 4) {
            [self.cellsName replaceObjectAtIndex:6 withObject:@[@"HTChooseBetweenDateCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell"]];
            [self.footerArray replaceObjectAtIndex:6 withObject:@"会员消费榜"];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"HTChooseBetweenDateCell"];
            for (int i = 0; i < self.customersModel.consume.count; i++) {
                [arr addObject:@"HTRankDataoboutCustomerCell"];
            }
            [self.cellsName replaceObjectAtIndex:6 withObject:arr];
            [self.footerArray replaceObjectAtIndex:6 withObject:@""];
        }
        self.customersModel.rankTimeBegin = beginTime;
        self.customersModel.rankTimeEnd = endTime;
        [self.tab reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:5];
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
                          @"version":@"2"
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCustomerReport,loadCustomerReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.customersModel = [HTCustomersInfoReprotModel yy_modelWithJSON:json[@"data"]];
        
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
        [yearF2 setDateFormat:@"dd"];
        
        NSString *whichDay = [yearF2 stringFromDate:[NSDate date]];
        
        NSString *thisMonth = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-1 * (whichDay.integerValue - 1)]];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        
        
        
        self.customersModel.rankTimeBegin = thisMonth;
        self.customersModel.vipAddTimeBegin = thisMonth;
        self.customersModel.rankTimeEnd = today;
        self.customersModel.vipAddTimeEnd = today;
        //选择开始时间
        self.customersModel.consumeTimeBegin = thisMonth;
        //选择结束时间
        self.customersModel.consumeTimeEnd = today;
        
        [self getLastMonthLastDay];
        
//        //选择开始时间2
//        self.customersModel.consumeTimeSecBegin = thisMonth;
//        //选择结束时间2
//        self.customersModel.consumeTimeSecEnd = today;
        
        if (self.customersModel.consume.count > 4) {
            [self.cellsName replaceObjectAtIndex:6 withObject:@[@"HTChooseBetweenDateCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell"]];
            [self.footerArray replaceObjectAtIndex:6 withObject:@"会员消费榜"];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"HTChooseBetweenDateCell"];
            for (int i = 0; i < self.customersModel.consume.count; i++) {
                [arr addObject:@"HTRankDataoboutCustomerCell"];
            }
            [self.cellsName replaceObjectAtIndex:6 withObject:arr];
            [self.footerArray replaceObjectAtIndex:6 withObject:@""];
        }
        if (self.customersModel.storeAccount.count > 4) {
            [self.cellsName replaceObjectAtIndex:7 withObject:@[@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell"]];
            [self.footerArray replaceObjectAtIndex:7 withObject:@"会员储值榜"];
        }else{
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.customersModel.storeAccount.count; i++) {
                [arr addObject:@"HTRankDataoboutCustomerCell"];
            }
            [self.cellsName replaceObjectAtIndex:7 withObject:arr];
            [self.footerArray replaceObjectAtIndex:7 withObject:@""];
        }
        

//        self.customersModel.customerSecConsumeTimeApp = self.customersModel.customerConsumeTimeApp;

//        self.customersModel.amountSecDistribute = self.customersModel.amountDistribute;
        
        [self.tab reloadData];
        if (self.selectdWarning) {
            [self.tab scrollToRowAtIndexPath:self.selectdWarning.waringIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

- (void)getLastMonthLastDay{
    //日历操作工具待会儿要用
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //当前时间
    NSDate *dateNow = [NSDate date];
    //转换当前时间的格式为 XXXX-XX-XX
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:dateNow];
    NSLog(@"dateNow-->%@",dateStr);
    //获取 年月日
    NSInteger year = [[dateStr substringToIndex:4] integerValue];
    NSInteger month = [[dateStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSInteger day = [[dateStr substringFromIndex:8] integerValue];
    NSLog(@"year -> %ld month -> %ld day -> %ld",(long)year,(long)month,(long)day);
    
    //NSDateComponents这个叫什么还真不知道。 大致理解为时间元,构造时间的
    //构造当月的1号时间
    NSDateComponents *firstDayCurrentMonth = [[NSDateComponents alloc] init];
    [firstDayCurrentMonth setYear:year];
    [firstDayCurrentMonth setMonth:month];
    [firstDayCurrentMonth setDay:1];
    //当月1号
    NSDate *firstDayOfCurrentMonth = [calendar dateFromComponents:firstDayCurrentMonth];
    NSLog(@"firstDayOfCurrentMonth -> %@",firstDayOfCurrentMonth);
//    4.然后再获取上月一号时间:
    
    
    //构造上月1号时间
    month --;
    //获取上月月份 没的说
    if (month == 0) {
        month = 12;
        year--;
    }
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:1];
    //上月1号时间
    NSDate *firstDayOfLastMonth = [calendar dateFromComponents:dateComponents];
    NSLog(@"firstDayOfLastMonth -> %@",firstDayOfLastMonth);
    //上个月的最后一天的最后一秒
    NSDate *lastDayOfLastlMonth = [firstDayOfCurrentMonth dateByAddingTimeInterval:-1];
    NSLog(@"lastDayOfLastlMonth -> %@",lastDayOfLastlMonth);
    
    
    NSDateFormatter *formatterfinal = [[NSDateFormatter alloc] init];
    [formatterfinal setDateFormat:@"yyyy-MM-dd"];
    //上月最后一天
    NSString *finalEnd = [NSString stringWithFormat:@"%@", [formatterfinal stringFromDate:lastDayOfLastlMonth]];
    
    
    NSDateFormatter *formatterbegin = [[NSDateFormatter alloc] init];
    [formatterbegin setDateFormat:@"yyyy-MM"];
    //上月最后一天
    NSString *finalBegin = [NSString stringWithFormat:@"%@-01", [formatterbegin stringFromDate:lastDayOfLastlMonth]];

    //选择开始时间2
    self.customersModel.consumeTimeSecBegin = finalBegin;
    //选择结束时间2
    self.customersModel.consumeTimeSecEnd = finalEnd;
}

-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTRankDataoboutCustomerCell" bundle:nil] forCellReuseIdentifier:@"HTRankDataoboutCustomerCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTManyLineBarDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTManyLineBarDataTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTDefaulDataLineTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTDefaulDataLineTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTDataPropressLineCell" bundle:nil] forCellReuseIdentifier:@"HTDataPropressLineCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTChooseBetweenDateCell" bundle:nil] forCellReuseIdentifier:@"HTChooseBetweenDateCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTLineDataReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTLineDataReportTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTCustomersReportBaceInfoCell" bundle:nil] forCellReuseIdentifier:@"HTCustomersReportBaceInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTTotleVipNumsTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTTotleVipNumsTableViewCell"];
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTAgeAndeSexInfoReportCell" bundle:nil] forCellReuseIdentifier:@"HTAgeAndeSexInfoReportCell"];
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewPieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPieCellTableViewCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
#pragma mark - getters and setters
-(NSMutableArray *)cellsName{
    if (!_cellsName) {
        _cellsName = [NSMutableArray array];
        [_cellsName addObject:@[@"HTTotleVipNumsTableViewCell",@"HTCustomersReportBaceInfoCell"]];
        [_cellsName addObject:@[@"HTLineDataReportTableViewCell"]];
        [_cellsName addObject:@[@"HTChooseBetweenDateCell",@"HTChooseBetweenDateCell",@"HTDataPropressLineCell",@"HTDataPropressLineCell"]];
        [_cellsName addObject:@[@"HTAgeAndeSexInfoReportCell"]];
        [_cellsName addObject:@[@"HTNewPieCellTableViewCell"]];
        [_cellsName addObject:@[@"HTDefaulDataLineTableViewCell",@"HTDefaulDataLineTableViewCell",@"HTManyLineBarDataTableViewCell"]];
        [_cellsName addObject:@[@"HTChooseBetweenDateCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell"]];
        [_cellsName addObject:@[@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell",@"HTRankDataoboutCustomerCell"]];
        
    }
    return _cellsName;
}
-(NSMutableArray *)footerArray{
    if (!_footerArray) {
        _footerArray = [NSMutableArray array];
        [_footerArray addObject:@""];
        [_footerArray addObject:@""];
        [_footerArray addObject:@""];
        [_footerArray addObject:@""];
        [_footerArray addObject:@""];
        [_footerArray addObject:@""];
        [_footerArray addObject:@"会员消费榜"];
        [_footerArray addObject:@"会员储值榜"];
    }
    return _footerArray;
}
-(NSMutableArray *)headArray{
    if (!_headArray) {
        _headArray = [NSMutableArray array];
        [_headArray addObject:@"基本概况"];
        [_headArray addObject:@"会员增长趋势"];
        [_headArray addObject:@"消费分布"];
        [_headArray addObject:@"会员性别及年龄比"];
        [_headArray addObject:@"会员活跃度"];
        [_headArray addObject:@"会员等级概况"];
        [_headArray addObject:@"会员消费榜"];
        [_headArray addObject:@"会员储值榜"];
    }
    return _headArray;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [[HTShareClass shareClass].loginModel.companyId stringValue];
    }
    return _companyId;
}
@end
