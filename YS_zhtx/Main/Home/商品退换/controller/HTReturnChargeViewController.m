//
//  YHChargeViewController.m
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
#import "HTWriteBarcodeView.h"
#import "HTCashierChooseSizeOrColorView.h"
#import "HTCashierBottomView.h"
#import "HTReturnChargeViewController.h"
#import "HTNewVipBaseInfoCell.h"
#import "HTNewGoodsImgTableViewCell.h"
#import "HTScanTools.h"
#import "HTExchangeProductsDetailView.h"
#import "HTHoldChargeManager.h"
#import "HTUnderstockListAlertView.h"
#import "HTHoldCustomerEventManger.h"
#import "HTChangeSettleViewController.h"
#import "HTBatchTurnInController.h"
@interface HTReturnChargeViewController ()<UITableViewDataSource,UITableViewDelegate,HTCashierChooseSizeOrColorViewDelegate,HTScanCodeDelegate,HTWriteBarcodeViewDelegate,HTCashierBottomViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabTopHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) HTWriteBarcodeView *whiteBarcode;

@property (nonatomic,strong) HTCashierBottomView *bottomView;

@property (nonatomic,strong) HTScanTools *scanTool;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *holdBarcode;

@end
@implementation HTReturnChargeViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收银记账";
    [self loadPrintData];
    [self createTb];
    [self initNav];
    self.whiteBarcode.hidden = YES;
    [self scanTool];
    [self bottomView];
    if (self.custModel) {
        self.bottomView.custModel = self.custModel;
        self.bottomView.vipBt.enabled = YES;
    }else{
        self.bottomView.vipBt.enabled = NO;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavHidden];
#if defined (__i386__) || defined (__x86_64__)
    //模拟器下执行
#else
    [self.scanTool.session startRunning];
    //真机下执行
#endif
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.scanTool.session stopRunning];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewGoodsImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNewGoodsImgTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [self sumTotle];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        self.tab.hidden = YES;
    }else{
        self.tab.hidden = NO;
    }
    return  self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTCahargeProductModel *model = self.dataArray[indexPath.row];
    if (model.product.count > 1) {
        [HTCashierChooseSizeOrColorView showAlertViewInView:self.view andDelegate:self withGoodData:model];
    }
}
#pragma mark -CustomDelegate
//删除商品
-(void)delClickWithProduct:(HTCahargeProductModel *)model{
    [self.dataArray removeObject:model];
    [self.tab reloadData];
}

/**
 结算点击
 */
-(void)settlerClicked{
    if (self.dataArray.count == 0) {
        [MBProgressHUD showError:@"未添加商品"];
        return;
    }
    if ([HTHoldChargeManager getbcProductJsonStrFormArray:self.dataArray].length == 0) {
        return;
    }
    if (![HTShareClass shareClass].printerModel.lastOrderPrintDic || [HTShareClass shareClass].printerModel.lastOrderPrintDic.allKeys.count > 0) {
        [MBProgressHUD showMessage:@""];
        [self createOrderPost];
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
                    [strongSelf createOrderPost];
                }else if ([isNul isEqualToString:@"0"]){
                    if ([dataDic getDictionArrayWithKey:@"printInfo"]) {
                        [[HTShareClass shareClass].printerModel.lastOrderPrintDic setDictionary:[dataDic getDictionArrayWithKey:@"printInfo"]];
                        [strongSelf createOrderPost];
                    }
                }
            }
        } error:^{
            [self createOrderPost];
        } failure:^(NSError *error) {
            [self createOrderPost];
        }];
    }
}

-(void)vipBtclicked{
    
}

-(void)dismissAlertViewFromBigView:(UIView *)alertView{
    [alertView removeFromSuperview];
}
/**
 输入电话弹框 确认点击
 
 @param text 电话号码
 */
-(void)okBtClickedWithStr:(NSString *)text{
}
//取消按钮确认
- (void)cancelBtClickedWithStr:(NSString *)text{
}
/**
 储值按钮点击
 */
- (void)stroeMoneyClicked{
    if (self.custModel) {
       [HTHoldCustomerEventManger storedForCustomerWithCustomerPhone:self.custModel.phone];
    }
}
/**
 编辑商品资料不全商品
 
 @param model 正在编辑的商品
 */
-(void)okBtClickWithProduct:(HTCahargeProductModel *)model{
    if ([HTShareClass shareClass].isProductStockActive) {
        if ([HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.inventory].length == 0) {
            __weak typeof(self) weakSelf = self;
            HTCustomDefualAlertView *alert =  [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@ 商品暂无库存是否继续",model.selectedModel.barcode] btsArray:@[@"移除",@"确认"] okBtclicked:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.tab reloadData];
            } cancelClicked:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.dataArray removeObject:model];
                [strongSelf.tab reloadData];
            }];
            [alert notTochShow];
            return ;
        }else if ([[HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.inventory] isEqualToString:@"0"]){
            __weak typeof(self) weakSelf = self;
            HTCustomDefualAlertView *alert =  [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@ 商品库存不足，是否调入",model.selectedModel.barcode] btsArray:@[@"移除",@"去调入"] okBtclicked:^{
                //            去调入页面
                __strong typeof(weakSelf) strongSelf = weakSelf;
                HTBatchTurnInController *vc = [[HTBatchTurnInController alloc] init];
                vc.dataArray = [@[model] mutableCopy];
                [strongSelf.navigationController pushViewController:vc animated:YES];
                [strongSelf.tab reloadData];
            } cancelClicked:^{
                //            移除商品
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.dataArray removeObject:model];
                [strongSelf.tab reloadData];
            }];
            [alert notTochShow];
            return ;
        }else{
          [self.tab reloadData];
        }
    }else{
        [self.tab reloadData];
    }
}


/**
 处理扫码数据
 
 @param result 扫码所得条码
 */
-(void) handleScanResultStr:(NSString *) result{
    if ([result isEqualToString:self.holdBarcode]) {
        return;
    }
    self.holdBarcode = result;
    [self performSelector:@selector(clearStrWithStr:) withObject:result afterDelay:2];
    [HTHoldChargeManager getProductDataFromBarcode:result andPhone:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.phone] andId:[HTHoldNullObj getValueWithUnCheakValue:_custModel.custId] WithSucces:^(id json) {
        __weak typeof(self) weakSelf = self;
        [HTHoldChargeManager getProductModelWithJsonData:json withModel:^(HTCahargeProductModel *model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.dataArray addObject:model];
            [strongSelf.tab reloadData];
        } andSearchStr:result];
    }];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//}
#pragma mark -EventResponse
/**
 扫码与输入条码切换
 
 @param sender 扫码按钮
 */
-(void)starScanClicked:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"输入条码"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"扫条码" target:self withColor:[UIColor colorWithHexString:@"#ffffff"] action:@selector(starScanClicked:)];
        self.whiteBarcode.hidden = NO;
        [self.scanTool.session stopRunning];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"输入条码" target:self withColor:[UIColor colorWithHexString:@"#ffffff"] action:@selector(starScanClicked:)];
        self.whiteBarcode.hidden = YES;
        [self.scanTool.session startRunning];
    }
}
/**
 根据输入条码查询商品
 
 @param barcode 输入条码
 */
-(void)searchProductWithBarCode:(NSString *)barcode{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@""];
    [HTHoldChargeManager getProductDataFromBarcode:barcode andPhone:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.phone] andId:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId] WithSucces:^(id json) {
        __weak typeof(self) weakSelf = self;
        [HTHoldChargeManager getProductModelWithJsonData:json withModel:^(HTCahargeProductModel *model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUD];
            [strongSelf.dataArray addObject:model];
            [strongSelf.tab reloadData];
        } andSearchStr:barcode];
    }];
}
-(void)tabHeadClicked{
   HTExchangeProductsDetailView *detail = [[HTExchangeProductsDetailView alloc] initWithAlertFrame:CGRectMake(0, HMSCREENWIDTH * 9 / 16, HMSCREENWIDTH, 280)];
    detail.exchangeProducts = self.exchangeArray;
   [detail show];
}
#pragma mark -private methods
-(void)createOrderPost{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"bcProductJsonStr":[HTHoldChargeManager getbcProductJsonStrFormArray:self.dataArray],
                          @"replaceDetailIds":[HTHoldChargeManager getReturnProductIdsFormArray:self.exchangeArray],
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    self.bottomView.settelBt.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,loadRepalceProductData4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //        库存不足
        if ([[json[@"data"] getStringWithKey:@"inventoryState"] isEqualToString:@"1"]) {
            strongSelf.bottomView.settelBt.enabled = YES;
            NSArray *poductIds = [json[@"data"] getArrayWithKey:@"productIds"];
            NSArray *notInvens = [HTHoldChargeManager cheakIsLockPruductsFormLockArray:poductIds andDatas:strongSelf.dataArray];
            if (notInvens.count > 0) {
                [HTUnderstockListAlertView showAlertWithDataArray:notInvens btsArray:@[@"移出商品",@"调入库存"] okBtclicked:^{
                    //                    调入库存
                    HTBatchTurnInController *vc = [[HTBatchTurnInController alloc] init];
                    vc.dataArray = [notInvens mutableCopy];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } cancelClicked:^{
                    //                    移除商品
                    [strongSelf.dataArray removeObjectsInArray:notInvens];
                    [strongSelf.tab reloadData];
                }];
            }
            return ;
        }
        //        积分不足
        if ([[json[@"data"][@"order"] getStringWithKey:@"state"] isEqualToString:@"-1"]){
            strongSelf.bottomView.settelBt.enabled = YES;
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"积分余不足,退货失败，应扣除%@积分,余额为%@",[json[@"data"][@"order"] getStringWithKey:@"deductpoints"],self.custModel.account.stored.balance ?  self.custModel.account.stored.balance :@"0"] btTitle:@"确定" okBtclicked:^{
            }];
            [alert show];
            return ;
        }
        NSArray *detaillist = [json[@"data"][@"order"] getArrayWithKey:@"detaillist"];
        NSMutableArray *copyArray = [NSMutableArray array];
        for (HTCahargeProductModel *model in strongSelf.dataArray) {
            NSDictionary *dic = [model yy_modelToJSONObject];
            HTCahargeProductModel *mm = [HTCahargeProductModel yy_modelWithJSON:dic];
            [copyArray addObject:mm];
        }
        //        装已被赋值的primarykey
        NSMutableArray *inKeys = [NSMutableArray array];
        for (HTCahargeProductModel *model in copyArray) {
            HTChargeProductInfoModel *mmm = model.selectedModel;
            for (NSDictionary *dict in detaillist) {
                if ([mmm.productId isEqualToString:[dict getStringWithKey:@"productid"]] && ![mmm.primaryKey isEqualToString:[dict getStringWithKey:@"id"]]) {
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
        HTChangeSettleViewController *vc = [[HTChangeSettleViewController alloc] init];
        vc.orderDetail = self.orderModel;
        vc.custModel = self.custModel;
        vc.products = copyArray;
        vc.orderModel = order;
        vc.returnArray = self.exchangeArray;
        vc.timeoutJobId = [json[@"data"][@"order"] getStringWithKey:@"timeoutjobid"];
        vc.wechatPayOrderId = [json[@"data"] getStringWithKey:@"wechatPayOrderId"];
//        if ([HTShareClass shareClass].isPlatformOnlinePayActive) {
//            vc.payCode = [json[@"data"] getStringWithKey:@"payCode"];
//        }else{
//            vc.addUrl = [json[@"data"] getStringWithKey:@"adUrl"];
//        }
        [strongSelf.navigationController pushViewController:vc animated:YES];
        strongSelf.bottomView.settelBt.enabled = YES;
    } error:^{
        [MBProgressHUD hideHUD];
        self.bottomView.settelBt.enabled = YES;
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        self.bottomView.settelBt.enabled = YES;
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)clearStrWithStr:(NSString *)str{
    if ([str isEqualToString:self.holdBarcode]) {
        self.holdBarcode = nil;
    }
}
-(void)initNav{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"输入条码" target:self withColor:[UIColor colorWithHexString:@"#ffffff"] action:@selector(starScanClicked:)];
}
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.hidden = YES;
    [self.tab registerNib:[UINib nibWithNibName:@"HTNewGoodsImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTNewGoodsImgTableViewCell"];
    
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    headV.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    title.textColor = [UIColor colorWithHexString:@"#222222"];
    title.text = [NSString stringWithFormat:@"退货商品(%ld)",self.exchangeArray.count];
    title.textAlignment = NSTextAlignmentCenter;
    [headV addSubview:title];
    
    UITapGestureRecognizer *taphead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabHeadClicked)];
    [headV addGestureRecognizer:taphead];
    self.tab.tableHeaderView = headV;
    
}
- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;
}
-(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}
-(void)sumTotle{
    CGFloat finall = 0.0f;
    CGFloat totle = 0.0f;
    for (HTCahargeProductModel *mmm in self.dataArray) {
        HTChargeProductInfoModel *model = [[HTChargeProductInfoModel alloc] init];
        if (mmm.product.count == 1) {
            model = [mmm.product firstObject];
        }else{
            if (!mmm.selectedModel) {
                model = [mmm.product firstObject];
            }else{
                model = mmm.selectedModel;
            }
        }
        finall += model.finalprice.floatValue ;
        totle  += model.price.floatValue;
    }
    self.bottomView.finallPrice = [NSString stringWithFormat:@"%.0lf",finall];
    self.bottomView.totlePrice = [NSString stringWithFormat:@"%.0lf",totle];
    self.bottomView.productNum = [NSString stringWithFormat:@"%ld",self.dataArray.count];
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

-(HTWriteBarcodeView *)whiteBarcode{
    if (!_whiteBarcode) {
        _whiteBarcode = [[NSBundle mainBundle] loadNibNamed:@"HTWriteBarcodeView" owner:nil options:nil].lastObject;
        _whiteBarcode.delegate = self;
        _whiteBarcode.frame = CGRectMake(0, 0, HMSCREENWIDTH , HMSCREENWIDTH * 9 / 16);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_whiteBarcode];
            self.tabTopHeight.constant = HMSCREENWIDTH * 9 / 16;
        });
        
    }
    return _whiteBarcode;
}
-(HTCashierBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"HTCashierBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, HEIGHT - SafeAreaBottomHeight - 61, HMSCREENWIDTH, 61);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self->_bottomView];
        });
    }
    return _bottomView;
}
-(HTScanTools *)scanTool{
    if (!_scanTool ) {
        _scanTool = [[HTScanTools alloc] init];
        _scanTool.frame = CGRectMake(0, 0, HMSCREENWIDTH, HMSCREENWIDTH * 9 / 16);
        self.tabTopHeight.constant = HMSCREENWIDTH * 9 / 16;
        _scanTool.delegate = self;
        [_scanTool startScanInView:self.view];
        UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫码线"]];
        imgview.center = CGPointMake(HMSCREENWIDTH * 0.5, HMSCREENWIDTH *9 / 32);
        [self.view addSubview:imgview];
    }
    return _scanTool;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
