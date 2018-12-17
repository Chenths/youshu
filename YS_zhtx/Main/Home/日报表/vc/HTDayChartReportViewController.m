//
//  HTDayChartReportViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/10/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTBossReportBasciModel.h"
#import "HTChangeTypeTableCell.h"
#import "HTOrderHeadTableCell.h"
#import "HTChooseDateTableViewCell.h"
#import "HTBossSaleBasicInfoCell.h"
#import "HTDefaulProductViewCell.h"
#import "HTDayChartReportViewController.h"
#import "HcdDateTimePickerView.h"
#import "HTOrderDetailModel.h"
@interface HTDayChartReportViewController ()<UITableViewDelegate,UITableViewDataSource,HTChangeTypeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableArray *baseArray;

@property (nonatomic,strong) NSMutableArray *orderArray;

@property (nonatomic,strong) NSMutableArray *exchangeArray;

@property (nonatomic,strong) NSString *type;

@end

@implementation HTDayChartReportViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = @"1";
    self.title = @"日报表";
    [self createTb];
    [self loadDataWithDate:self.reportDate];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *names = self.cellsName[indexPath.section];
    NSString *cellName = names[indexPath.row];
    if ([cellName isEqualToString:@"HTChooseDateTableViewCell"]) {
        HTChooseDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.reportDate = self.reportDate;
        return  cell;
    }else if ([cellName isEqualToString:@"HTBossSaleBasicInfoCell"]) {
        HTBossSaleBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleBasicInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.baseArray[indexPath.row];
        return  cell;
        
    }else if ([cellName isEqualToString:@"HTOrderHeadTableCell"]){
        HTOrderHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderHeadTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTOrderDetailModel *model = [[HTOrderDetailModel alloc] init];
        if ([self.type isEqualToString:@"1"]) {
          model = self.orderArray[indexPath.section - 3];
        }else{
          model = self.exchangeArray[indexPath.section - 3];
        }
        cell.model = model;
        return cell;
        
    }else if ([cellName isEqualToString:@"HTChangeTypeTableCell"]){
        HTChangeTypeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChangeTypeTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else{
        HTDefaulProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDefaulProductViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTOrderDetailModel *model = [[HTOrderDetailModel alloc] init];
        if ([self.type isEqualToString:@"1"]) {
            model = self.orderArray[indexPath.section - 3];
        }else{
            model = self.exchangeArray[indexPath.section - 3];
        }
        NSMutableArray *products = [NSMutableArray array];
        for (HTOrderDetailProductModel *obj in model.product) {
            [products addObject:obj];
        }
        for (HTOrderDetailExchangesModel *obj in model.returnandexchangeproduct) {
            for (HTOrderDetailExchangesModel *obj1 in  obj.data) {
                [products addObject:obj1];
            }
        }
        cell.orderProductModel = products[indexPath.row - 1];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.cellsName[section];
    return  [arr count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.baseArray.count == 0 ? 0 : self.cellsName.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[HTChooseDateTableViewCell class]]) {
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        formate.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formate dateFromString:self.reportDate];
        HcdDateTimePickerView * dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:date WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self)  weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.reportDate = dateTimeStr;
            [strongSelf loadDataWithDate:strongSelf.reportDate];
        };
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
#pragma mark -CustomDelegate
-(void)nomorlClick{
    if (![self.type isEqualToString:@"1"]) {
      self.type = @"1";
      [MBProgressHUD showMessage:@""];
      [self.cellsName removeAllObjects];
      [self.cellsName addObject:@[@"HTChooseDateTableViewCell"]];
      NSMutableArray *cellArr = [NSMutableArray array];
      for (int  i = 0; i < self.baseArray.count; i++) {
          [cellArr addObject:@"HTBossSaleBasicInfoCell"];
      }
      [self.cellsName addObject:cellArr];
      [self.cellsName addObject:@[@"HTChangeTypeTableCell"]];
      for (HTOrderDetailModel *mm in self.orderArray) {
          NSMutableArray *arr = [NSMutableArray array];
          [arr addObject:@"HTOrderHeadTableCell"];
          for (HTOrderDetailProductModel *obj in mm.product) {
              NSLog(@"%@",obj.createdate);
              [arr addObject:@"HTDefaulProductViewCell"];
          }
          for (HTOrderDetailExchangesModel *obj in mm.returnandexchangeproduct) {
              for (int i = 0; i < obj.data.count; i++) {
                  [arr addObject:@"HTDefaulProductViewCell"];
              }
          }
          [self.cellsName addObject:arr];
        }
        [MBProgressHUD hideHUD];
        [self.tab reloadData];
    }
}
-(void)changeClick{
    if (![self.type isEqualToString:@"2"]) {
        [MBProgressHUD showMessage:@""];
        self.type = @"2";
        [self.cellsName removeAllObjects];
        [self.cellsName addObject:@[@"HTChooseDateTableViewCell"]];
        NSMutableArray *cellArr = [NSMutableArray array];
        for (int  i = 0; i < self.baseArray.count; i++) {
            [cellArr addObject:@"HTBossSaleBasicInfoCell"];
        }
        [self.cellsName addObject:cellArr];
        [self.cellsName addObject:@[@"HTChangeTypeTableCell"]];
        for (HTOrderDetailModel *mm in self.exchangeArray) {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"HTOrderHeadTableCell"];
            for (HTOrderDetailProductModel *obj in mm.product) {
                NSLog(@"%@",obj.createdate);
                [arr addObject:@"HTDefaulProductViewCell"];
            }
            for (HTOrderDetailExchangesModel *obj in mm.returnandexchangeproduct) {
                for (int i = 0; i < obj.data.count; i++) {
                    [arr addObject:@"HTDefaulProductViewCell"];
                }
            }
            [self.cellsName addObject:arr];
        }
        [MBProgressHUD hideHUD];
        [self.tab reloadData];
    }
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)loadDataWithDate:(NSString *)date{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"beginDate":[HTHoldNullObj getValueWithUnCheakValue:date],
                          @"endDate":[HTHoldNullObj getValueWithUnCheakValue:date],
                          };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleSaleReport,loadSaleDataTodayReport] params:dic success:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.baseArray removeAllObjects];
        [strongSelf.orderArray removeAllObjects];
        [strongSelf.exchangeArray removeAllObjects];
        [strongSelf.cellsName removeAllObjects];
        [strongSelf.cellsName addObject:@[@"HTChooseDateTableViewCell"]];
        strongSelf.title = [NSString stringWithFormat:@"%@_报表",strongSelf.reportDate];
        NSArray *titles1 = @[@"利润",@"销量",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费"];
        NSArray *titles2 = @[@"营业额",@"换货数量",@"VIP销售占比",@"退货率",@"客单价",@"新增标签",@"支付宝支付"];
        NSArray *titles3 = @[@"退换差额",@"退货数量",@"折扣",@"换货率",@"件单价",@"新增储值",@"微信支付"];
        NSArray *keys1 = @[@"profit",@"orderProducts",@"orderCount",@"related",@"flowCountIn",@"backUpRate",@"consumeStore"];
        NSArray *keys2 = @[@"saleAmount",@"exchangeProducts",@"vipSaleScale",@"returnRate",@"customerTransaction",@"tagCount",@"aliPay"];
        NSArray *keys3 = @[@"exchangeAndReturnAmount",@"returnProducts",@"discount",@"exchangeRate",@"piecePrice",@"store",@"weChat"];
        NSArray *prefix1 = @[@"￥",@"",@"",@"",@"",@"",@"￥"];
        NSArray *prefix2 = @[@"￥",@"",@"",@"",@"￥",@"",@"￥"];
        NSArray *prefix3 = @[@"￥",@"",@"",@"",@"￥",@"￥",@"￥"];
        NSArray *suffix1  = @[@"",@"件",@"单",@"",@"人",@"%",@""];
        NSArray *suffix2  = @[@"",@"件",@"%",@"%",@"",@"",@""];
        NSArray *suffix3  = @[@"",@"件",@"折",@"%",@"",@"",@""];
        NSArray *imageName  = @[@"利润",@"矢量智能对象5",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费"];
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *cellArr = [NSMutableArray array];
        for (int  i = 0; i < titles1.count; i++) {
            HTBossReportBasciModel *model = [[HTBossReportBasciModel alloc] init];
            model.title1 = titles1[i];
            model.title2 = titles2[i];
            model.title3 = titles3[i];
            model.value1 = [json[@"data"][@"todayReport"] getStringWithKey:keys1[i]];
            model.value2 = [json[@"data"][@"todayReport"] getStringWithKey:keys2[i]];
            model.value3 = [json[@"data"][@"todayReport"] getStringWithKey:keys3[i]];
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
        [self.baseArray addObjectsFromArray:arr];
        [self.cellsName addObject:cellArr];
        [self.cellsName addObject:@[@"HTChangeTypeTableCell"]];
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"normalModels"]) {
            NSMutableArray *arr = [NSMutableArray array];
            HTOrderDetailModel *mm = [HTOrderDetailModel yy_modelWithJSON:dic];
            [arr addObject:@"HTOrderHeadTableCell"];
            for (HTOrderDetailProductModel *obj in mm.product) {
                NSLog(@"%@",obj.createdate);
                [arr addObject:@"HTDefaulProductViewCell"];
            }
            for (HTOrderDetailExchangesModel *obj in mm.returnandexchangeproduct) {
                for (int i = 0; i < obj.data.count; i++) {
                    [arr addObject:@"HTDefaulProductViewCell"];
                }
            }
            if ([self.type isEqualToString:@"1"]) {
              [self.cellsName addObject:arr];
            }
            [self.orderArray addObject:mm];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"exchangeModels"]) {
            NSMutableArray *arr = [NSMutableArray array];
            HTOrderDetailModel *mm = [HTOrderDetailModel yy_modelWithJSON:dic];
            [arr addObject:@"HTOrderHeadTableCell"];
            for (HTOrderDetailProductModel *obj in mm.product) {
                NSLog(@"%@",obj.createdate);
                [arr addObject:@"HTDefaulProductViewCell"];
            }
            for (HTOrderDetailExchangesModel *obj in mm.returnandexchangeproduct) {
                for (int i = 0; i < obj.data.count; i++) {
                    [arr addObject:@"HTDefaulProductViewCell"];
                }
            }
            if ([self.type isEqualToString:@"2"]) {
              [self.cellsName addObject:arr];
            }
            [self.exchangeArray addObject:mm];
        }
        [MBProgressHUD hideHUD];
        [self.tab reloadData];
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
    [self.tab registerNib:[UINib nibWithNibName:@"HTOrderHeadTableCell" bundle:nil] forCellReuseIdentifier:@"HTOrderHeadTableCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTChangeTypeTableCell" bundle:nil] forCellReuseIdentifier:@"HTChangeTypeTableCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTDefaulProductViewCell" bundle:nil] forCellReuseIdentifier:@"HTDefaulProductViewCell"];
    
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [_cellsName addObject:@[@"HTChooseDateTableViewCell"]];
        [_cellsName addObject:@[@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell",@"HTBossSaleBasicInfoCell"]];
    }
    return _cellsName;
}
-(NSString *)reportDate{
    if (!_reportDate) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        _reportDate = [yearF1 stringFromDate:[NSDate date]];
    }
    return _reportDate;
}
-(NSMutableArray *)baseArray{
    if (!_baseArray) {
        _baseArray = [NSMutableArray array];
    }
    return _baseArray;
}
-(NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}
-(NSMutableArray *)exchangeArray{
    if (!_exchangeArray) {
        _exchangeArray = [NSMutableArray array];
    }
    return _exchangeArray;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}

@end
