//
//  HTBossCustomerInfoController.m
//  有术
//
//  Created by mac on 2018/4/19.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossCustomerBasicInfoCell.h"
#import "HTBossCustomerInfoController.h"
#import "HTNewPieCellTableViewCell.h"
#import "HTSectionOpenModel.h"
#import "HTBossSelectedShopView.h"
#import "HTBossSectionReportView.h"
#import "HTBossCustomerInfoModel.h"
#import "HTLengedModel.h"
#import "HTBossVipFrequencyCell.h"
#import "HTBossVipFrequencyModel.h"
#import "HTBrokenLineReportCell.h"
#import "NSDate+Manager.h"
#import "HTFrequencyHeaderCell.h"
#import "HcdDateTimePickerView.h"
#import "HTBossCompareViewController.h"
#import "HTAgeAndeSexInfoReportCell.h"
@interface HTBossCustomerInfoController ()<UITableViewDelegate,UITableViewDataSource,HTBrokenLineReportCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSMutableArray *sectionTitleArray;
//第一组数据
@property (nonatomic,strong) NSMutableArray *firstSectionArray;
//第2组数据
@property (nonatomic,strong) NSMutableArray *secondSectionArray;
////第3组数据
@property (nonatomic,strong) NSMutableArray *thirdSectionArray;
////第4组数据
@property (nonatomic,strong) NSMutableArray *fourthSectionArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomHeight;

@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,strong) NSString *fourbeginTime;

@property (nonatomic,strong) NSString *fourendTime;

@property (nonatomic,strong) NSString *secondbeginTime;

@property (nonatomic,strong) NSString *secondendTime;

@property (nonatomic,strong) NSMutableArray *companys;

@property (nonatomic,strong) NSArray *dataArray;



@end

@implementation HTBossCustomerInfoController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTime];
    [self createTb];
    [self loadCompanyListData];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HTSectionOpenModel *model = self.sectionTitleArray[section];
    NSArray *arr = self.dataArray[section];
    return model.isOpen ? section == 2 ? 1 : section == 3 ?   arr.count  + 1 : arr.count  : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            
        case 0:
        {
            HTBossCustomerBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossCustomerBasicInfoCell" forIndexPath:indexPath];
            HTBossCustomerInfoModel *model = self.firstSectionArray[indexPath.row];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            return cell;
        }
            break;
        case 2:
        {
            HTAgeAndeSexInfoReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTAgeAndeSexInfoReportCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.thirdSectionArray.count >= 2) {
                cell.sexModel = [self.thirdSectionArray firstObject];
                cell.ageModel = self.thirdSectionArray[1];
                [cell createSubWithAgelist:cell.ageModel.data andSexList:cell.sexModel.data];
            }
            
            return cell;
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                HTFrequencyHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTFrequencyHeaderCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.beginTime = self.fourbeginTime;
                cell.endTime = self.fourendTime;
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
                return cell;
            }else{
                HTBossVipFrequencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossVipFrequencyCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = self.fourthSectionArray[indexPath.row - 1];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                return cell;
            }
        }
            break;
        case 1:{
            HTBrokenLineReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBrokenLineReportCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.beginTime = self.secondbeginTime;
            cell.endTime = self.secondendTime;
            cell.dataArr = self.secondSectionArray[indexPath.row];
            return cell;
        }
    }
    UITableViewCell *cell = [[UITableViewCell alloc ] init];
    return cell;
    
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
    switch (indexPath.section) {
        case 0:
            {
                return 185;
            }
            break;
        case 1:{
            return  HMSCREENWIDTH * 9 / 16 + 20;
        }
            break;
        case 2:{
            HTPiesModel *mmm = self.thirdSectionArray[1];
            return 220 + 78 + mmm.data.count * 48;
        }
            break;
        case 3:{
            return 40;
        }
            break;
        default:
            break;
    }
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 && indexPath.row == 0) {
        HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self)  weakSelf = self;
        dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.fourbeginTime = beginTime;
            strongSelf.fourendTime = endTime;
            [strongSelf loadDataWithTag:indexPath.section];
        } ;
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
#pragma mark -CustomDelegate
- (void)timecliked{
    HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:YES];
    dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
    __weak typeof(self)  weakSelf = self;
    dateTimePickerView.betweenClickedOkBtn = ^(NSString *beginTime, NSString *endTime) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.secondbeginTime = beginTime;
        strongSelf.secondendTime = endTime;
        [strongSelf loadDataWithTag:1];
    } ;
    [self.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
}
#pragma mark -EventResponse
- (IBAction)compareClicked:(id)sender {
    HTBossCompareViewController *vc = [[HTBossCompareViewController alloc] init];
    if (self.pushVc) {
        self.pushVc(vc);
    }
}

-(void)sectionOpenBtClicked:(UIButton *)sender{
    
    int tag = (int)sender.tag - 500;
    HTSectionOpenModel *model = self.sectionTitleArray[tag];
    if (model.isOpen && model.isOpen) {
        model.isOpen = !model.isOpen;
        [self.dataTableView reloadData];
    }else{
        [self loadDataWithTag:tag];
    }
    
}
#pragma mark -private methods
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
    self.fourbeginTime = thisMonth;
    self.fourendTime = today;
    self.secondbeginTime = thisMonth;
    self.secondendTime = today;
}

- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossCustomerBasicInfoCell" bundle:nil] forCellReuseIdentifier:@"HTBossCustomerBasicInfoCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNewPieCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewPieCellTableViewCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBossVipFrequencyCell" bundle:nil] forCellReuseIdentifier:@"HTBossVipFrequencyCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTFrequencyHeaderCell" bundle:nil] forCellReuseIdentifier:@"HTFrequencyHeaderCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTBrokenLineReportCell" bundle:nil] forCellReuseIdentifier:@"HTBrokenLineReportCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTAgeAndeSexInfoReportCell" bundle:nil] forCellReuseIdentifier:@"HTAgeAndeSexInfoReportCell"];
//    self.tableBottomHeight.constant = SafeAreaBottomHeight + tar_height;
//    self.dataTableView.contentInset = self.dataTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight + tar_height, 0);
    self.dataTableView.tableFooterView = footView;
}
-(void)loadDataWithTag:(int) tag{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"beginDate":[HTHoldNullObj getValueWithUnCheakValue: tag == 1 ? self.secondbeginTime : tag == 3 ? self.fourbeginTime : self.beginTime],
                          @"endDate":[HTHoldNullObj getValueWithUnCheakValue:tag == 1 ? self.fourendTime : tag == 3 ? self.fourendTime :self.endTime],
                          @"ids":@"",
                          @"reportType":[NSString stringWithFormat:@"%d",tag]
                          };
    [MBProgressHUD showMessage:@"" ];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCusRepott,@"load_boss_customer_report_4_app.html"] params:dic success:^(id json) {
        
        if (tag == 0) {
            [self.firstSectionArray removeAllObjects];
            HTBossCustomerInfoModel *model = [[HTBossCustomerInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:[json getDictionArrayWithKey:@"data"] ];
            [self.firstSectionArray addObject:model];
            HTSectionOpenModel *model1= self.sectionTitleArray[tag];
            model1.isOpen = YES;
        }
        if (tag == 2) {
            [self.thirdSectionArray removeAllObjects];
            HTPiesModel *agemodel = [HTPiesModel yy_modelWithJSON:  [json[@"data"] getDictionArrayWithKey:@"ageModel"]];
            HTPiesModel *sexModel = [HTPiesModel yy_modelWithJSON:  [json[@"data"] getDictionArrayWithKey:@"sexModel"]];
//            NSString *age = [json[@"data"] getStringWithKey:@"age"];
//            NSArray *ageArr = [age ArrayWithJsonString];
//            NSArray *ageList = [json[@"data"] getArrayWithKey:@"ageList"];
//            for (int i = 0 ; i < ageList.count ;i++) {
//                NSDictionary *dic = ageList[i];
//                NSDictionary *dict = ageArr[i];
//                NSString *nameLabel = [dict getStringWithKey:@"label"];
//                NSArray *nameArr = [nameLabel componentsSeparatedByString:@"("];
//                HTLengedModel *model = [[HTLengedModel alloc] init];
//                model.finalprice = [dic getStringWithKey:@"total"];
//                model.count = [dic getStringWithKey:@"total"];
//                if (nameArr.count > 0) {
//                model.name = nameArr.firstObject;
//                }
//                model.present = [dict getStringWithKey:@"data"];
//                model.suffix = @"人";
//                model.start = [dic getStringWithKey:@"start"];
//                model.end = [dict getStringWithKey:@"end"];
//                model.title = @"年龄";
//                [arr1 addObject:model];
//            }
//            NSMutableArray *arr2 = [NSMutableArray array];
//            NSArray *sexArr = [[json[@"data"] getStringWithKey:@"sex"] ArrayWithJsonString];
//            NSArray *sexList = [json[@"data"] getArrayWithKey:@"sexList"];
//            for (int i = 0; i < sexList.count; i++) {
//                NSDictionary *dic = sexList[i];
//                NSDictionary *dict = sexArr[i];
//                HTLengedModel *model = [[HTLengedModel alloc] init];
//                model.finalprice = [dic getStringWithKey:@"total"];
//                model.count = [dic getStringWithKey:@"total"];
//                model.present = [dict getStringWithKey:@"data"];
//                model.suffix = @"人";
//                model.name = [dic getStringWithKey:@"name"];
//                model.value = [dic getStringWithKey:@"value"];
//                model.title = @"性别";
//                [arr2 addObject:model];
//            }
            [self.thirdSectionArray addObject:sexModel];
            [self.thirdSectionArray addObject:agemodel];
            HTSectionOpenModel *sectionModel = self.sectionTitleArray[tag];
            sectionModel.isOpen = YES;
        }
        if (tag == 3) {
            [self.fourthSectionArray removeAllObjects];
            CGFloat max  = 0.0;
            for (NSDictionary *dic in [json[@"data"]  getArrayWithKey:@"customerConsumeTimeApp"]) {
                if ([dic getFloatWithKey:@"val"] > max ) {
                    max = [dic getFloatWithKey:@"val"];
                }
            }
            for (NSDictionary *dic in [json[@"data"]  getArrayWithKey:@"customerConsumeTimeApp"]) {
                HTBossVipFrequencyModel *model = [[HTBossVipFrequencyModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.maxVal = [NSString stringWithFormat:@"%lf",max];
                [self.fourthSectionArray addObject:model];
            }
            HTSectionOpenModel *sectionModel = self.sectionTitleArray[tag];
            sectionModel.isOpen = YES;
            
        }
        if (tag == 1) {
            [self.secondSectionArray removeAllObjects];
            [self.secondSectionArray addObject:[json getArrayWithKey:@"data"]];
            HTSectionOpenModel *sectionModel = self.sectionTitleArray[tag];
            sectionModel.isOpen = YES;
        }
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
-(void)loadCompanyListData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@"  " toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"load_children_id_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}

#pragma mark - getters and setters
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
- (NSMutableArray *)companys{
    if (!_companys) {
        _companys = [NSMutableArray array];
    }
    return _companys;
}
@end
