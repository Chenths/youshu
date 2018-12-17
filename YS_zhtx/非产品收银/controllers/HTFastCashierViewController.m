//
//  HTFastCashierViewController.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTCashierBottomView.h"
#import "HTFastCashierViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "HTFastEditProductViewController.h"
#import "HTFastProductViewCell.h"
#import "HTNewCustomerBaceInfoView.h"
#import "HTCustModel.h"
#import "PhoneNumberTools.h"
#import "HTCahargeProductModel.h"
#import "HTSettleViewController.h"
#import "HTMenuModle.h"
#import "NSObject+ModelToDic.h"
#import "HTFastNoProductInventoryTurnInController.h"
#import "HTStoreMoneyViewController.h"
#import "HTCustomMadeFieldAlertView.h"
#import "HTChargeOrderModel.h"
@interface HTFastCashierViewController ()<UITableViewDelegate,UITableViewDataSource,HTNewCustomerBaceInfoViewDelegate,HTCashierBottomViewDelegate,HTCustomMadeFieldAlertViewDelegate,UITextFieldDelegate>{
    NSString *modleId;
    NSString *customerid;
}
//底部view
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HTCashierBottomView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,assign) BOOL isShow;
//商品数量
@property (nonatomic,assign) CGFloat goodsNumbers;

//订单总价
@property (nonatomic,assign) CGFloat totlePrize;

@property (nonatomic,strong) NSMutableArray *productArray;

@property (nonatomic,strong) HTCustModel *custModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;


@end

@implementation HTFastCashierViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self bottomView];
    self.title = @"简易下单";
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
    vc.phoneNumber = self.phone;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)dismissAlertViewFromBigView:(UIView *)alertView{
    [alertView removeFromSuperview];
    self.isShow = NO;
}
//取消按钮确认
- (void)cancelBtClickedWithStr:(NSString *)text{
}
/**
 输入电话弹框 确认点击
 
 @param text 电话号码
 */
-(void)okBtClickedWithStr:(NSString *)text{
    [self.view endEditing:YES];
    if (![PhoneNumberTools isMobileNumber:text]) {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    NSDictionary *dic = @{
                          @"bcProductIds":@"",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"phone":[HTHoldNullObj getValueWithUnCheakValue:text]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProduct,refreshBuyProductList] params:dic success:^(id json) {
        self.phone = text;
        self.custModel = [HTCustModel yy_modelWithJSON:json[@"data"][@"cust"]];
        self.bottomView.custModel = self.custModel;
        if (self.dataArray.count > 0 ) {
            for (HTFastPrudoctModel *model1 in self.dataArray) {
                if (model1.discount.length == 0) {
                    model1.discount =[NSString stringWithFormat:@"%.2lf", self.custModel.discount.floatValue * 10];
                }
            }
            [self.dataTableView reloadData];
        }
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

/**
 结算点击
 */
-(void)settlerClicked{
    
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
    [self createOrderWithBcString:[dataArr arrayToJsonString] AndBqString:@""];
}
/**
 添加vip电话
 */
- (void)vipBtclicked{
    HTCustomMadeFieldAlertView *phoneAlart =  [[HTCustomMadeFieldAlertView alloc] initWithTitle:@"请输入VIP手机号码" message:@"(凭此号码退换货）" delegate:self];
    phoneAlart.textField.keyboardType =  UIKeyboardTypePhonePad;
    [phoneAlart show];
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
                          @"qrProductJsonStr":bqStr,
                          @"bcProductJsonStr":bcProductStr
                          };
    self.bottomView.settelBt.enabled = NO;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,createNoProductOder] params:dic success:^(id json) {
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
        //        装已被赋值的primarykey
        NSMutableArray *inKeys = [NSMutableArray array];
        for (HTCahargeProductModel *model in self.productArray) {
            HTChargeProductInfoModel *mmm = model.selectedModel;
            for (NSDictionary *dict in detaillist) {
                if ([mmm.barcode isEqualToString:[dict getStringWithKey:@"barcode"]] && ![mmm.primaryKey isEqualToString:[dict getStringWithKey:@"id"]]) {
                    //                    该商品primarykey为空 且未添加到其他商品上
                    if (mmm.primaryKey.length == 0 && ![inKeys containsObject:[dict getStringWithKey:@"id"]]) {
                        mmm.primaryKey = [dict getStringWithKey:@"id"];
                        [inKeys addObject: [dict getStringWithKey:@"id"]];
                        break;
                    }
                }
            }
        }
        HTChargeOrderModel *order = [HTChargeOrderModel yy_modelWithJSON:[json[@"data"] getDictionArrayWithKey:@"order"]];
        HTSettleViewController *vc = [[HTSettleViewController alloc] init];
        vc.orderModel = order;
        vc.products = self.productArray;
        if ([HTShareClass shareClass].isPlatformOnlinePayActive) {
            vc.payCode = [json[@"data"] getStringWithKey:@"payCode"];
        }else{
            vc.addUrl = [json[@"data"] getStringWithKey:@"adUrl"];
        }
        vc.custModel = strongSelf.custModel;
        vc.requestNum = [json[@"data"] getStringWithKey:@"requestNum"];
        [strongSelf.navigationController pushViewController:vc animated:YES];
        strongSelf.bottomView.settelBt.enabled = YES;
    } error:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bottomView.settelBt.enabled = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bottomView.settelBt.enabled = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
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
    self.tabBottomHeight.constant = 61 + SafeAreaBottomHeight;
}
#pragma mark - getters and setters
//初始化底部试图
-(HTCashierBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"HTCashierBottomView" owner:nil options:nil].lastObject;
        _bottomView.frame = CGRectMake(0, HEIGHT - SafeAreaBottomHeight - nav_height  - 61, HMSCREENWIDTH, 61);
        _bottomView.delegate = self;
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
