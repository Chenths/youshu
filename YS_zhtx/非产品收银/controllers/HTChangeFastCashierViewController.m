//
//  HTFastCashierViewController.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTCashierBottomView.h"
#import "HTChangeFastCashierViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HTFastEditProductViewController.h"
#import "HTFastProductViewCell.h"
#import "HTNewCustomerBaceInfoView.h"
#import "HTCustModel.h"
#import "PhoneNumberTools.h"
#import "HTCahargeProductModel.h"
#import "HTMenuModle.h"
#import "NSObject+ModelToDic.h"
#import "HTChangeSettleViewController.h"
#import "SecurityUtil.h"
#import "HTFastNoProductInventoryTurnInController.h"
#import "HTStoreMoneyViewController.h"
#import "HTHoldChargeManager.h"
@interface HTChangeFastCashierViewController ()<UITableViewDelegate,UITableViewDataSource,HTNewCustomerBaceInfoViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,HTCashierBottomViewDelegate>{
    NSString *modleId;
    NSString *customerid;
}
//底部view
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HTCashierBottomView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) NSString *userPhoneNumber;

@property (nonatomic,assign) BOOL isShow;
//商品数量
@property (nonatomic,assign) CGFloat goodsNumbers;

//订单总价
@property (nonatomic,assign) CGFloat totlePrize;

@property (nonatomic,strong) NSMutableArray *productArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;


@end

@implementation HTChangeFastCashierViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退换货商品";
    [self loadPrintData];
    [self bottomView];
    [self createTb];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-goodsAdd" highImageName:@"g-goodsAdd" target:self action:@selector(addProductClicked:)] ;
}

#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTFastProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTFastProductViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.index = indexPath;
    [self sumTotle];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        self.dataTableView.hidden = YES;
    }else{
        self.dataTableView.hidden = NO;
    }
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 98;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    HTFastEditProductViewController *vc = [[HTFastEditProductViewController alloc] init];
    vc.editModel = self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    vc.deleteProuct = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataArray removeObjectAtIndex:indexPath.row];
        [strongSelf.dataTableView reloadData];
    };
    vc.selectedProductModel = ^(HTFastPrudoctModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -CustomDelegate
-(void)stroeMoneyClicked{
    HTStoreMoneyViewController *vc = [[HTStoreMoneyViewController alloc] init];
    vc.handType    = HAND_TYPE_STORED;
    vc.phoneNumber = self.userPhoneNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)dismissAlertViewFromBigView:(UIView *)alertView{
    [alertView removeFromSuperview];
    self.isShow = NO;
}
/**
 结算点击
 */
-(void)settlerClicked{
    if (self.dataArray.count == 0) {
        [MBProgressHUD showError:@"请添加商品"];
        return;
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    for (HTFastPrudoctModel *model in self.dataArray) {
        for (int i = 0; i < model.numbers.integerValue; i++) {
            NSDictionary *dic = @{
                                  @"barcode":[HTHoldNullObj getValueWithUnCheakValue:model.barcode],
                                  @"categories":[HTHoldNullObj getValueWithUnCheakValue:model.categoryId],
                                  @"price":[HTHoldNullObj getValueWithUnCheakValue:model.price],
                                  @"discount": model.discount.length == 0 ? @"" : [NSString stringWithFormat:@"%.2lf",(model.discount.floatValue/10)]
                                  };
            [dataArr addObject:dic];
            HTCahargeProductModel *dModel = [[HTCahargeProductModel alloc] init];
            HTChargeProductInfoModel *producModel = [[HTChargeProductInfoModel alloc] init];
            producModel.barcode = model.barcode;
            producModel.customtype = model.categoryName;
            producModel.price = [HTHoldNullObj getValueWithUnCheakValue:model.price];
            producModel.finalprice = [HTHoldNullObj getValueWithUnCheakValue:[model getFinallPriceWithPrice:model.price andDiscount:model.discount]];
            producModel.discount = model.discount;
            dModel.product = @[producModel];
            [self.productArray addObject:dModel];
        }
    }
    if (![HTShareClass shareClass].printerModel.lastOrderPrintDic || [HTShareClass shareClass].printerModel.lastOrderPrintDic.allKeys.count > 0) {
        [MBProgressHUD showMessage:@""];
        [self createOrderWithBcString:[dataArr arrayToJsonString] AndBqString:@""];
    }else{
        NSDictionary *dic = @{
                              @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                              @"companyId":[HTShareClass shareClass].loginModel.companyId
                              };
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryOrderPrintInfo4App] params:dic success:^(id json) {
            __strong typeof(weakSelf) strongSelf = self;
            NSDictionary *dataDic = [json getDictionArrayWithKey:@"data"];
            if (dataDic) {
                NSString *isNul = [dataDic getStringWithKey:@"isNull"];
                if ([isNul isEqualToString:@"1"]) {
                    [HTShareClass shareClass].printerModel.lastOrderPrintDic = nil;
                    [strongSelf createOrderWithBcString:[dataArr arrayToJsonString] AndBqString:@""];
                }else if ([isNul isEqualToString:@"0"]){
                    if ([dataDic getDictionArrayWithKey:@"printInfo"]) {
                        [[HTShareClass shareClass].printerModel.lastOrderPrintDic setDictionary:[dataDic getDictionArrayWithKey:@"printInfo"]];
                        [strongSelf createOrderWithBcString:[dataArr arrayToJsonString] AndBqString:@""];
                    }
                }
            }
        } error:^{
            [self createOrderWithBcString:[dataArr arrayToJsonString] AndBqString:@""];
        } failure:^(NSError *error) {
            [self createOrderWithBcString:[dataArr arrayToJsonString] AndBqString:@""];
        }];
    }
    
}
#pragma mark -EventResponse

-(void)addProductClicked:(UIBarButtonItem *)sender{
    HTFastEditProductViewController *vc = [[HTFastEditProductViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.selectedProductModel = ^(HTFastPrudoctModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId].length > 0 && model.discount.length == 0) {
            model.discount = [NSString stringWithFormat:@"%.2lf",self.custModel.discount.floatValue * 10];
        }
        [strongSelf.dataArray addObject:model];
        [strongSelf.dataTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -private methods
//下单
- (void)createOrderWithBcString:(NSString *) bcProductStr AndBqString:(NSString *)bqStr{
    [MBProgressHUD showMessage:@""];
    __weak typeof(self ) weakSelf = self;
    NSDictionary *dic = @{
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId ,
                          @"replaceDetailIds":[HTHoldChargeManager getReturnProductIdsFormArray:self.exchangeArray],
                          @"bcProductJsonStr":bcProductStr,
                          @"orderId": [HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId]
                          };
    self.bottomView.settelBt.enabled = NO;
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,replaceProduct4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([[json[@"data"][@"order"] getStringWithKey:@"isstockenough"] isEqualToString:@"0"]) {
            HTCustomDefualAlertView *alet = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"当前剩余为%@件，请先进行调货操作",[json[@"data"][@"order"] getStringWithKey:@"avaliablestock"]] btsArray:@[@"取消",@"去调入"] okBtclicked:^{
                HTFastNoProductInventoryTurnInController *vc = [[HTFastNoProductInventoryTurnInController alloc] init];
                [strongSelf.navigationController pushViewController: vc animated:YES];
            } cancelClicked:^{
            }];
            [alet show];
            strongSelf.bottomView.settelBt.enabled = YES;
            return ;
        }
        NSArray *detaillist = [json[@"data"][@"order"] getArrayWithKey:@"detaillist"];
        for (NSDictionary *dict in detaillist) {
            for (HTCahargeProductModel *model in self.productArray) {
                HTChargeProductInfoModel *mmm = model.selectedModel;
                if ([mmm.barcode isEqualToString:[dict getStringWithKey:@"barcode"]] && ![mmm.primaryKey isEqualToString:[dict getStringWithKey:@"id"]]) {
                    if (mmm.primaryKey.length == 0) {
                        mmm.primaryKey = [dict getStringWithKey:@"id"];
                    }
                    break;
                }
            }
        }
        HTChargeOrderModel *order = [HTChargeOrderModel yy_modelWithJSON:[json[@"data"] getDictionArrayWithKey:@"order"]];
        HTChangeSettleViewController *vc = [[HTChangeSettleViewController alloc] init];
        vc.orderDetail = self.orderModel;
        vc.custModel = self.custModel;
        vc.products = self.productArray;
        vc.orderModel = order;
        vc.returnArray = self.exchangeArray;
        vc.timeoutJobId = [json[@"data"][@"order"] getStringWithKey:@"timeoutjobid"];
        vc.wechatPayOrderId = [json[@"data"] getStringWithKey:@"wechatPayOrderId"];
        if ([HTShareClass shareClass].isPlatformOnlinePayActive) {
            vc.payCode = [json[@"data"] getStringWithKey:@"payCode"];
        }else{
            vc.addUrl = [json[@"data"] getStringWithKey:@"adUrl"];
        }
        [strongSelf.navigationController pushViewController:vc animated:YES];
        strongSelf.bottomView.settelBt.enabled = YES;
    } error:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bottomView.settelBt.enabled = YES;
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bottomView.settelBt.enabled = YES;
        [MBProgressHUD hideHUD];
    }];
}
//计算商品数量 及总价
- (void)sumTotle{
    
    CGFloat finall = 0.0f;
    CGFloat totle = 0.0f;
    for (HTFastPrudoctModel *model  in self.dataArray) {
        self.goodsNumbers += model.numbers.integerValue;
        finall += [ [model getFinallPriceWithPrice:model.price andDiscount:model.discount] intValue] * model.numbers.integerValue;
        totle  += [model.price intValue] * model.numbers.integerValue;
    }
    self.bottomView.finallPrice = [NSString stringWithFormat:@"%.0lf",finall];
    self.bottomView.totlePrice = [NSString stringWithFormat:@"%.0lf",totle];
    self.bottomView.productNum = [NSString stringWithFormat:@"%ld",self.dataArray.count];
}
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTFastProductViewCell" bundle:nil] forCellReuseIdentifier:@"HTFastProductViewCell"];
    self.dataTableView.tableFooterView = footView;
    if (self.custModel) {
        self.bottomView.custModel = self.custModel;
        self.bottomView.vipBt.enabled = YES;
    }else{
        self.bottomView.vipBt.enabled = NO;
    }
    self.tabBottomHeight.constant = SafeAreaBottomHeight + 61;
}
-(void)loadPrintData{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryOrderPrintInfo4App] params:dic success:^(id json) {
        NSDictionary *dataDic = [json getDictionArrayWithKey:@"data"];
        if (dataDic) {
            NSString *isNul = [dataDic getStringWithKey:@"isNull"];
            if ([isNul isEqualToString:@"1"]) {
                [HTShareClass shareClass].printerModel.lastOrderPrintDic = nil;
            }else if ([isNul isEqualToString:@"0"]){
                if ([dataDic getDictionArrayWithKey:@"printInfo"]) {
                    [[HTShareClass shareClass].printerModel.lastOrderPrintDic setDictionary:[dataDic getDictionArrayWithKey:@"printInfo"]];
                }
            }
        }
    } error:^{
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - getters and setters
//初始化底部试图
-(HTCashierBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"HTCashierBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, HEIGHT - SafeAreaBottomHeight - 61 - nav_height, HMSCREENWIDTH, 61);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_bottomView];
        });
    }
    return _bottomView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array ];
    }
    return _dataArray;
}
-(NSMutableArray *)productArray{
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

@end
