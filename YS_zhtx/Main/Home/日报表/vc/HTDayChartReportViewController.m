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
#import "HTSaleItemHeaderTableViewCell.h"
#import "HTSaleItemBottmTableViewCell.h"
#import "HTSaleItemPayKindTableViewCell.h"
#import "HTSaleItemDetailTableViewCell.h"
#import "HTSaleOtherDetailTableViewCell.h"
#import "HTSaleItemMode.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface HTDayChartReportViewController ()<UITableViewDelegate,UITableViewDataSource,HTChangeTypeTableCellDelegate, chooseShowPayDetailDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *cellsName;

@property (nonatomic,strong) NSMutableArray *baseArray;

@property (nonatomic,strong) NSMutableArray *orderArray;

@property (nonatomic,strong) NSMutableArray *exchangeArray;

@property (nonatomic,strong) NSString *type;
@property (nonatomic, assign) NSInteger currentSelectShowPayKindType;
@property (nonatomic, strong) NSMutableArray *payKindDetailLeftArr;
@property (nonatomic, strong) NSMutableArray *payKindDetailRightArr;
@property (nonatomic, strong) UIImage *shareImg;
@end

@implementation HTDayChartReportViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = @"1";
    self.title = @"日报表";
    [self createTb];
    [self loadDataWithDate:self.reportDate];
    [self buildRightButtonItem];
}


- (void)buildRightButtonItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-share" highImageName:@"g-share" target:self action:@selector(creatScreenShot)];
    
}

- (void)creatScreenShot{
    if (!_shareImg) {
        NSInteger sec = self.cellsName.count == 0 ? 0 : self.cellsName.count;
        NSArray *cells = self.cellsName[sec - 1];
        NSInteger ro = self.cellsName.count == 0 ? 0 : [cells count];
        [self.tab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ro - 1 inSection:sec - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [MBProgressHUD showMessage:@"生成完整截图中"];
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            dispatch_async(dispatch_get_main_queue(),^{
                UIGraphicsBeginImageContextWithOptions(self.tab.contentSize, YES, [UIScreen mainScreen].scale);
                
                CGPoint savedContentOffset = self.tab.contentOffset;
                CGRect savedFrame = self.tab.frame;
                self.tab.contentOffset = CGPointZero;
                self.tab.frame = CGRectMake(0, 0, self.tab.contentSize.width, self.tab.contentSize.height);
                [self.tab.layer renderInContext: UIGraphicsGetCurrentContext()];
                self.shareImg = UIGraphicsGetImageFromCurrentImageContext();
                self.tab.contentOffset = savedContentOffset;
                self.tab.frame = savedFrame;
                
                [MBProgressHUD hideHUD];
                UIGraphicsEndImageContext();
                [self share];
            });
            [timer invalidate];
            timer = nil;
        }];
    }else{
        [self share];
    }
}

- (void)share{
    NSArray* imageArray = @[self.shareImg];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:@"知识与你共享"
                                         images:imageArray
                                            url:[NSURL URLWithString:@""]
                                          title:self.title
                                           type:SSDKContentTypeImage];
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
    
}


- (void)selectChooseShowPayKindType:(NSInteger)type
{
    if (type == _currentSelectShowPayKindType - 1) {
        _currentSelectShowPayKindType = 0;
    }else{
        NSMutableArray *tempArr = [[NSMutableArray arrayWithArray:self.baseArray] objectAtIndex:0];
        if (type == 0) {
            _currentSelectShowPayKindType = 1;
            [tempArr replaceObjectAtIndex:5 withObject:_payKindDetailLeftArr];
        }else{
            _currentSelectShowPayKindType = 2;
            [tempArr replaceObjectAtIndex:5 withObject:_payKindDetailRightArr];
        }
    }
    [self.tab reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:0];
}

#pragma mark -UITabelViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 1 && indexPath.row == 5 && _currentSelectShowPayKindType == 0) {
        return 0.01;
    }
    
    self.tab.rowHeight = UITableViewAutomaticDimension;
    self.tab.estimatedRowHeight = 300;
    return self.tab.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *names = self.cellsName[indexPath.section];
    NSString *cellName = names[indexPath.row];
    if ([cellName isEqualToString:@"HTChooseDateTableViewCell"]) {
        HTChooseDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTChooseDateTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.reportDate = self.reportDate;
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleItemHeaderTableViewCell"]) {
        HTSaleItemHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleItemHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *tempArr = self.baseArray[indexPath.section - 1];
        cell.hideRedPoint = YES;
        cell.dataArr = tempArr[indexPath.row];
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleItemBottmTableViewCell"]) {
        HTSaleItemBottmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleItemBottmTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *tempArr = self.baseArray[indexPath.section - 1];
        cell.delegate = self;
        //1 4 是此时 消费 充值金额的indexPath
        if (indexPath.section == 1 && indexPath.row == 4) {
            cell.ifShowDownImv = YES;
        }else{
            cell.ifShowDownImv = NO;
        }
        cell.currentSelectShowPayKindType = self.currentSelectShowPayKindType;
        cell.dataArr = tempArr[indexPath.row];
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleItemPayKindTableViewCell"]) {
        HTSaleItemPayKindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleItemPayKindTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *tempArr = self.baseArray[indexPath.section - 1];
        if (_currentSelectShowPayKindType == 0) {
            cell.hidden = YES;
        }else if (_currentSelectShowPayKindType == 1){
            cell.hidden = NO;
        }else{
            cell.hidden = NO;
        }
        cell.dataArr = tempArr[indexPath.row];
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleItemDetailTableViewCell"]) {
        HTSaleItemDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleItemDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *tempArr = self.baseArray[indexPath.section - 1];
        cell.hideRedPoint = YES;
        cell.dataArr = tempArr[indexPath.row];
        return  cell;
    }else if ([cellName isEqualToString:@"HTSaleOtherDetailTableViewCell"]){
        HTSaleOtherDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleOtherDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *tempArr = self.baseArray[indexPath.section - 1];
        cell.hideRedPoint = YES;
        cell.dataArr = tempArr[indexPath.row];
        return  cell;
    }
//    else if ([cellName isEqualToString:@"HTBossSaleBasicInfoCell"]) {
//        HTBossSaleBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBossSaleBasicInfoCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.model = self.baseArray[indexPath.row];
//        return  cell;
//
//    }
    else if ([cellName isEqualToString:@"HTOrderHeadTableCell"]){
        HTOrderHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTOrderHeadTableCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HTOrderDetailModel *model = [[HTOrderDetailModel alloc] init];
        if ([self.type isEqualToString:@"1"]) {
          model = self.orderArray[indexPath.section - 5];
        }else{
          model = self.exchangeArray[indexPath.section - 5];
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
            model = self.orderArray[indexPath.section - 5];
        }else{
            model = self.exchangeArray[indexPath.section - 5];
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
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:self.cellsName[0]];
        [tempArr addObject:self.cellsName[1]];
        [tempArr addObject:self.cellsName[2]];
        [tempArr addObject:self.cellsName[3]];
        [tempArr addObject:self.cellsName[4]];
        self.cellsName = [NSMutableArray arrayWithArray:tempArr];
//      [self.cellsName removeAllObjects];
//      [self.cellsName addObject:@[@"HTChooseDateTableViewCell"]];
//      NSMutableArray *cellArr = [NSMutableArray array];
//      for (int  i = 0; i < self.baseArray.count; i++) {
//          [cellArr addObject:@"HTBossSaleBasicInfoCell"];
//      }
//      [self.cellsName addObject:cellArr];
//      [self.cellsName addObject:@[@"HTChangeTypeTableCell"]];
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
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:self.cellsName[0]];
        [tempArr addObject:self.cellsName[1]];
        [tempArr addObject:self.cellsName[2]];
        [tempArr addObject:self.cellsName[3]];
        [tempArr addObject:self.cellsName[4]];
        self.cellsName = [NSMutableArray arrayWithArray:tempArr];
//        [self.cellsName removeAllObjects];
//        [self.cellsName addObject:@[@"HTChooseDateTableViewCell"]];
//        NSMutableArray *cellArr = [NSMutableArray array];
//        for (int  i = 0; i < self.baseArray.count; i++) {
//            [cellArr addObject:@"HTBossSaleBasicInfoCell"];
//        }
//        [self.cellsName addObject:cellArr];
//        [self.cellsName addObject:@[@"HTChangeTypeTableCell"]];
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
        self.payKindDetailLeftArr = [NSMutableArray array];
        self.payKindDetailRightArr = [NSMutableArray array];
        
        //销售概况
        NSArray *titleArr1 =@[@[@"销售额 (元)"], @[@"消费", @"储值消费"], @[@"储赠消费"], @[@"营业收入 (元)"], @[@"消费", @"充值金额"], @[@"微信支付", @"支付宝支付", @"现金支付", @"刷卡支付"], @[@"单量", @"销量 (件)"], @[@"利润 (元)", @"折扣率"], @[@"件单价", @"客单价"], @[@"连带率"]];
        NSArray *iconArr1 = @[@[@"bXiaoShouE"], @[@"", @""], @[@""], @[@"bYingYeShouRu"], @[@"", @""], @[@"bWeiXinPay", @"bAliPay", @"bRMBPay", @"bPosPay"], @[@"bDanLiang", @"bXiaoLiang"], @[@"bLiRun", @"bZheKou"], @[@"bJianDanJia", @"bKeDanJia"], @[@"bLianDaiLv"]];
        NSArray *perDescribeArr1 = @[@[@"¥"], @[@"¥", @"¥"], @[@"¥"], @[@"¥"], @[@"¥", @"¥"], @[@"¥", @"¥", @"¥", @"¥"], @[@"", @""], @[@"¥", @""], @[@"¥", @"¥"], @[@""]];
        NSArray *sufDescribeArr1 = @[@[@""], @[@"", @""], @[@""], @[@""], @[@"", @""], @[@"", @"", @"", @""], @[@"", @""], @[@"", @""], @[@"", @""], @[@""]];;
        NSArray *describeKeyArr1 = @[@[@"saleAmount"], @[@"noStoreCon", @"consumeStore"], @[@"consumePreStore"], @[@"turnoverAmount"], @[@"noStoreCon", @"store"], @[@"weChat", @"aliPay", @"cash", @"isPos"], @[@"orderCount", @"orderProducts"], @[@"profit", @"discount"], @[@"piecePrice", @"customerTransaction"], @[@"related"]];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i < titleArr1.count; i++) {
            NSArray *tempTitleArr = titleArr1[i];
            NSArray *tempIconArr = iconArr1[i];
            NSArray *tempperDescribeArr = perDescribeArr1[i];
            NSArray *tempSufDescribeArr = sufDescribeArr1[i];
            NSArray *tempDescribeArr = describeKeyArr1[i];
            NSMutableArray *arr11 = [NSMutableArray array];
            for (int j = 0; j < tempTitleArr.count; j++) {
                HTSaleItemMode *tempModel = [[HTSaleItemMode alloc] init];
                tempModel.titleStr = tempTitleArr[j];
                tempModel.headerImvName = tempIconArr[j];
                tempModel.perDescribeStr = tempperDescribeArr[j];
                tempModel.describeStr = [json[@"data"][@"todayReport"] getStringWithKey:tempDescribeArr[j]];
                tempModel.sufDescribeStr = tempSufDescribeArr[j];
                [arr11 addObject:tempModel];
            }
            [arr1 addObject:arr11];
        }
        [self.baseArray addObject:arr1];
        self.currentSelectShowPayKindType = 0;
        
        //销售概括备用数据
        //1.消费中的详细支付种类
        NSArray *titleTemp =@[@"微信支付", @"支付宝支付", @"现金支付", @"刷卡支付"];
        NSArray *iconTemp = @[@"bWeiXinPay", @"bAliPay", @"bRMBPay", @"bPosPay"];
        NSArray *perDescribeTemp = @[@"¥", @"¥", @"¥", @"¥"];
        NSArray *sufDescribeTemp = @[@"", @"", @"", @""];
        NSArray *describeKeyTemp = @[@"weChat", @"aliPay", @"cash", @"isPos"];
        for (int i = 0; i < titleTemp.count; i++) {
            HTSaleItemMode *tempModel = [[HTSaleItemMode alloc] init];
            tempModel.titleStr = titleTemp[i];
            tempModel.headerImvName = iconTemp[i];
            tempModel.perDescribeStr = perDescribeTemp[i];
            tempModel.describeStr = [json[@"data"][@"todayReport"] getStringWithKey:describeKeyTemp[i]];
            tempModel.sufDescribeStr = sufDescribeTemp[i];
            [self.payKindDetailLeftArr addObject:tempModel];
        }
        //2.充值金额中的详细支付种类
        NSArray *titleTemp2 =@[@"微信支付", @"支付宝支付", @"现金支付", @"刷卡支付"];
        NSArray *iconTemp2 = @[@"bWeiXinPay", @"bAliPay", @"bRMBPay", @"bPosPay"];
        NSArray *perDescribeTemp2 = @[@"¥", @"¥", @"¥", @"¥"];
        NSArray *sufDescribeTemp2 = @[@"", @"", @"", @""];
        NSArray *describeKeyTemp2 = @[@"weChatStore", @"aliPayStore", @"cashStore", @"isPosStore"];
        for (int i = 0; i < titleTemp2.count; i++) {
            HTSaleItemMode *tempModel = [[HTSaleItemMode alloc] init];
            tempModel.titleStr = titleTemp2[i];
            tempModel.headerImvName = iconTemp2[i];
            tempModel.perDescribeStr = perDescribeTemp2[i];
            tempModel.describeStr = [json[@"data"][@"todayReport"] getStringWithKey:describeKeyTemp2[i]];
            tempModel.sufDescribeStr = sufDescribeTemp2[i];
            [self.payKindDetailRightArr addObject:tempModel];
        }
        
        //退换概况
        NSArray *titleArr2 =@[@[@"退货数量", @"换货数量"], @[@"退货金额 (元)", @"换货差额 (元)"], @[@"退货率", @"换货率"]];
        NSArray *iconArr2 = @[@[@"cyanPoint", @"cyanPoint"], @[@"cyanPoint", @"cyanPoint"], @[@"cyanPoint", @"cyanPoint"]];
        NSArray *perDescribeArr2 = @[@[@"", @""], @[@"¥", @"¥"], @[@"", @""]];
        NSArray *sufDescribeArr2 = @[@[@"", @""], @[@"", @""], @[@"%", @"%"]];;
        NSArray *describeKeyArr2 = @[@[@"returnProducts", @"exchangeProducts"], @[@"returnAmount", @"exchangeAndReturnAmount"], @[@"returnRate", @"exchangeRate"]];
        NSMutableArray *arr2 = [NSMutableArray array];
        for (int i = 0; i < titleArr2.count; i++) {
            NSMutableArray *arr22 = [NSMutableArray array];
            NSArray *tempTitleArr = titleArr2[i];
            NSArray *tempIconArr = iconArr2[i];
            NSArray *tempperDescribeArr = perDescribeArr2[i];
            NSArray *tempSufDescribeArr = sufDescribeArr2[i];
            NSArray *tempDescribeArr = describeKeyArr2[i];
            for (int j = 0; j < tempTitleArr.count; j++) {
                HTSaleItemMode *tempModel = [[HTSaleItemMode alloc] init];
                tempModel.titleStr = tempTitleArr[j];
                tempModel.headerImvName = tempIconArr[j];
                tempModel.perDescribeStr = tempperDescribeArr[j];
                tempModel.describeStr = [json[@"data"][@"todayReport"] getStringWithKey:tempDescribeArr[j]];
                tempModel.sufDescribeStr = tempSufDescribeArr[j];
                [arr22 addObject:tempModel];
            }
            [arr2 addObject:arr22];
        }
        [self.baseArray addObject:arr2];
        
        //会员概况
        NSArray *titleArr3 =@[@[@"新增会员", @"新增标签"], @[@"新增储值", @"新增储值赠送"], @[@"VIP成交人数", @"回头率"]];
        NSArray *iconArr3 = @[@[@"purplePoint", @"purplePoint"], @[@"purplePoint", @"purplePoint"], @[@"purplePoint", @"purplePoint"]];
        NSArray *perDescribeArr3 = @[@[@"", @""], @[@"¥", @"¥"], @[@"", @""]];
        NSArray *sufDescribeArr3 = @[@[@"", @""], @[@"", @""], @[@"", @"%"]];;
        NSArray *describeKeyArr3 = @[@[@"newCustomerCount", @"tagCount"], @[@"store", @"giveStore"], @[@"oldCustomerCount", @"backUpRate"]];
        NSMutableArray *arr3 = [NSMutableArray array];
        for (int i = 0; i < titleArr3.count; i++) {
            NSArray *tempTitleArr = titleArr3[i];
            NSArray *tempIconArr = iconArr3[i];
            NSArray *tempperDescribeArr = perDescribeArr3[i];
            NSArray *tempSufDescribeArr = sufDescribeArr3[i];
            NSArray *tempDescribeArr = describeKeyArr3[i];
            NSMutableArray *arr33 = [NSMutableArray array];
            for (int j = 0; j < tempTitleArr.count; j++) {
                HTSaleItemMode *tempModel = [[HTSaleItemMode alloc] init];
                tempModel.titleStr = tempTitleArr[j];
                tempModel.headerImvName = tempIconArr[j];
                tempModel.perDescribeStr = tempperDescribeArr[j];
                tempModel.describeStr = [json[@"data"][@"todayReport"] getStringWithKey:tempDescribeArr[j]];
                tempModel.sufDescribeStr = tempSufDescribeArr[j];
                [arr33 addObject:tempModel];
            }
            [arr3 addObject:arr33];
        }
        [self.baseArray addObject:arr3];
        [self.cellsName addObject:@[@"HTSaleItemHeaderTableViewCell", @"HTSaleItemBottmTableViewCell", @"HTSaleItemBottmTableViewCell", @"HTSaleItemHeaderTableViewCell", @"HTSaleItemBottmTableViewCell", @"HTSaleItemPayKindTableViewCell", @"HTSaleItemDetailTableViewCell", @"HTSaleItemDetailTableViewCell", @"HTSaleItemDetailTableViewCell", @"HTSaleItemDetailTableViewCell"]];
        [self.cellsName addObject:@[@"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell"]];
        [self.cellsName addObject:@[@"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell"]];
        
//        NSArray *titles1 = @[@"利润",@"销量",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费"];
//        NSArray *titles2 = @[@"营业额",@"换货数量",@"VIP销售占比",@"退货率",@"客单价",@"新增标签",@"支付宝支付"];
//        NSArray *titles3 = @[@"退换差额",@"退货数量",@"折扣",@"换货率",@"件单价",@"新增储值",@"微信支付"];
//        NSArray *keys1 = @[@"profit",@"orderProducts",@"orderCount",@"related",@"flowCountIn",@"backUpRate",@"consumeStore"];
//        NSArray *keys2 = @[@"saleAmount",@"exchangeProducts",@"vipSaleScale",@"returnRate",@"customerTransaction",@"tagCount",@"aliPay"];
//        NSArray *keys3 = @[@"exchangeAndReturnAmount",@"returnProducts",@"discount",@"exchangeRate",@"piecePrice",@"store",@"weChat"];
//        NSArray *prefix1 = @[@"￥",@"",@"",@"",@"",@"",@"￥"];
//        NSArray *prefix2 = @[@"￥",@"",@"",@"",@"￥",@"",@"￥"];
//        NSArray *prefix3 = @[@"￥",@"",@"",@"",@"￥",@"￥",@"￥"];
//        NSArray *suffix1  = @[@"",@"件",@"单",@"",@"人",@"%",@""];
//        NSArray *suffix2  = @[@"",@"件",@"%",@"%",@"",@"",@""];
//        NSArray *suffix3  = @[@"",@"件",@"折",@"%",@"",@"",@""];
//        NSArray *imageName  = @[@"利润",@"矢量智能对象5",@"单量",@"连带率",@"进店人次",@"回头率",@"储值消费"];
//        NSMutableArray *arr = [NSMutableArray array];
//        NSMutableArray *cellArr = [NSMutableArray array];
//        for (int  i = 0; i < titles1.count; i++) {
//            HTBossReportBasciModel *model = [[HTBossReportBasciModel alloc] init];
//            model.title1 = titles1[i];
//            model.title2 = titles2[i];
//            model.title3 = titles3[i];
//            model.value1 = [json[@"data"][@"todayReport"] getStringWithKey:keys1[i]];
//            model.value2 = [json[@"data"][@"todayReport"] getStringWithKey:keys2[i]];
//            model.value3 = [json[@"data"][@"todayReport"] getStringWithKey:keys3[i]];
//            model.suffix1 = suffix1[i];
//            model.suffix2 = suffix2[i];
//            model.suffix3 = suffix3[i];
//            model.prefix1 = prefix1[i];
//            model.prefix2 = prefix2[i];
//            model.prefix3 = prefix3[i];
//            model.imgName = imageName[i];
//            [arr addObject:model];
//            [cellArr addObject:@"HTBossSaleBasicInfoCell"];
//        }
//        [self.baseArray addObjectsFromArray:arr];
//        [self.cellsName addObject:cellArr];
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
//    [self.tab registerNib:[UINib nibWithNibName:@"HTBossSaleBasicInfoCell" bundle:nil] forCellReuseIdentifier:@"HTBossSaleBasicInfoCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleItemHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSaleItemHeaderTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleItemBottmTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSaleItemBottmTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleItemPayKindTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSaleItemPayKindTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleItemDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSaleItemDetailTableViewCell"];
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleOtherDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTSaleOtherDetailTableViewCell"];
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
        [_cellsName addObject:@[@"HTSaleItemHeaderTableViewCell", @"HTSaleItemBottmTableViewCell", @"HTSaleItemBottmTableViewCell", @"HTSaleItemHeaderTableViewCell", @"HTSaleItemBottmTableViewCell", @"HTSaleItemPayKindTableViewCell", @"HTSaleItemDetailTableViewCell", @"HTSaleItemDetailTableViewCell", @"HTSaleItemDetailTableViewCell", @"HTSaleItemDetailTableViewCell"]];
        [_cellsName addObject:@[@"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell"]];
        [_cellsName addObject:@[@"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell", @"HTSaleOtherDetailTableViewCell"]];
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
