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
#import "HTChargeViewController.h"
#import "HTNewVipBaseInfoCell.h"
#import "HTNewGoodsImgTableViewCell.h"
#import "HTScanTools.h"
#import "HTHoldChargeManager.h"
#import "HTCustomMadeFieldAlertView.h"
#import "PhoneNumberTools.h"
#import "HTUnderstockListAlertView.h"
#import "HTChargeOrderModel.h"
#import "HTSettleViewController.h"
#import "HTBatchTurnInController.h"
#import "HTChooseCustomerViewController.h"
#import "HTShareClass.h"
#import "HTLoginDataModel.h"
#import "HTLoginDataPersonModel.h"
#import "HTNewPayViewController.h"
#import "Poper.h"
#import "HTChargeMaskViewController.h"
@interface HTChargeViewController ()<UITableViewDataSource,UITableViewDelegate,HTCashierChooseSizeOrColorViewDelegate,HTScanCodeDelegate,HTWriteBarcodeViewDelegate,HTCashierBottomViewDelegate,HTCustomMadeFieldAlertViewDelegate, HTChooseCustomerDelegate>{
    Poper *poper;
}
//判断重复扫描
@property (nonatomic,strong) NSString *holdBarcode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabTopHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) HTWriteBarcodeView *whiteBarcode;

@property (nonatomic,strong) HTCashierBottomView *bottomView;

@property (nonatomic,strong) HTScanTools *scanTool;

@property (nonatomic,strong) NSMutableArray *dataArray;



@property (nonatomic,strong) HTCustModel *custModel;

@end
@implementation HTChargeViewController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收银记账";
    [self createTb];
    [self initNav];
    self.whiteBarcode.hidden = YES;
    [self bottomView];
    [self scanTool];
    if (self.phone) {
        [self okBtClickedWithStr:self.phone];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVipBack:) name:@"addVipBackNoti" object:nil];
}

- (void)addVipBack:(NSNotification *)noti{
    [self okBtClickedWithStr:[noti.userInfo objectForKey:@"phone"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#if defined (__i386__) || defined (__x86_64__)
    //模拟器下执行
#else
    [self.scanTool.session startRunning];
    //真机下执行
#endif
    [self setNavHidden];
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
//    判断商品是否为精确商品 否则弹框编辑颜色和尺码
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
 移除编辑商品信息弹框

 @param alertView 弹框
 */
- (void)dismissAlertViewFromBigView:(UIView *)alertView{
    [alertView removeFromSuperview];
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
    self.bottomView.settelBt.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [self checkProductNum:[HTHoldChargeManager getbcProductJsonStrFormArray:self.dataArray] andCustId:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId] WithSucces:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //        库存异常
        if ([[json[@"data"] getStringWithKey:@"inventoryState"] isEqualToString:@"1"] && [HTShareClass shareClass].isProductStockActive) {
            strongSelf.bottomView.settelBt.enabled = YES;
            NSArray *poductIds = [json[@"data"] getArrayWithKey:@"productIds"];
            //            获取无库存的产品数据
            NSArray *notInvens = [HTHoldChargeManager cheakIsLockPruductsFormLockArray:poductIds andDatas:strongSelf.dataArray];
            if (notInvens.count > 0) {
                //                弹框提示
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
//        NSArray *detaillist = [json[@"data"][@"order"] getArrayWithKey:@"detaillist"];
//        HTChargeOrderModel *order = [HTChargeOrderModel yy_modelWithJSON:[json[@"data"] getDictionArrayWithKey:@"order"]];
        NSMutableArray *copyArray = [NSMutableArray array];
        for (HTCahargeProductModel *model in strongSelf.dataArray) {
            NSDictionary *dic = [model yy_modelToJSONObject];
            HTCahargeProductModel *mm = [HTCahargeProductModel yy_modelWithJSON:dic];
            [copyArray addObject:mm];
        }
        //       根据返回值 为本地产品已被赋值的primarykey作为订单的唯一标识符
        NSMutableArray *inKeys = [NSMutableArray array];
//        for (HTCahargeProductModel *model in copyArray) {
//            HTChargeProductInfoModel *mmm = model.selectedModel;
//            for (NSDictionary *dict in detaillist) {
//                if ([mmm.productId isEqualToString:[dict getStringWithKey:@"productid"]] && ![mmm.primaryKey isEqualToString:[dict getStringWithKey:@"id"]]) {
//                    //                    该商品primarykey为空 且未添加到其他商品上
//                    if (mmm.primaryKey.length == 0 && ![inKeys containsObject:[dict getStringWithKey:@"id"]]) {
//                        mmm.primaryKey = [dict getStringWithKey:@"id"];
//                        [inKeys addObject: [dict getStringWithKey:@"id"]];
//                        break;
//                    }
//
//                }
//            }
//        }
        //替换
//                HTSettleViewController *vc = [[HTSettleViewController alloc] init];
        HTNewPayViewController *vc = [[HTNewPayViewController alloc] init];
        
        HTChargeOrderModel *orderModel = [[HTChargeOrderModel alloc] init];
        orderModel.encodeFinal = self.bottomView.finallPrice;
        orderModel.encodeTotal = self.bottomView.totlePrice;
        
        vc.orderModel = orderModel;
        vc.products = copyArray;
//        if ([HTShareClass shareClass].isPlatformOnlinePayActive) {
//            vc.payCode = [json[@"data"] getStringWithKey:@"payCode"];
//        }else{
//            vc.addUrl = [json[@"data"] getStringWithKey:@"adUrl"];
//        }
        vc.custModel = strongSelf.custModel;
//        vc.requestNum = [json[@"data"] getStringWithKey:@"requestNum"];
        [strongSelf.navigationController pushViewController:vc animated:YES];
        strongSelf.bottomView.settelBt.enabled = YES;
    } error:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bottomView.settelBt.enabled = YES;
        
    }];
   
}

/**
 检查库存
 @param productJsonStr 产品的数据构造的json字符串
 @param custid 用户id
 @param succes 成功操作
 @param error1 失败的操作
 */
-(void)checkProductNum:(NSString *)productJsonStr andCustId:(NSString *)custid WithSucces:(Succes)succes error:(Erro) error1{
    NSDictionary *dic = @{
                          @"bcProductJsonStr":productJsonStr,
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:custid]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,chectProductNum] params:dic success:^(id json) {
        if (succes) {
            succes(json);
        }
        [MBProgressHUD hideHUD];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        if (error1) {
            error1();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        if (error1) {
            error1();
        }
    }];
}


/**
 输入电话弹框 确认点击 如果已录入产品  获取用户信息并根据会员折扣刷新产品价

 @param text 电话号码
 */
-(void)okBtClickedWithStr:(NSString *)text{
    [self.view endEditing:YES];
    if (![PhoneNumberTools isMobileNumber:text] && !self.customerId) {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    if (![HTHoldChargeManager getProductIdsFormArray:self.dataArray]) {
        return;
    }
    
    NSDictionary *dic = @{
                          @"bcProductIds":[HTHoldChargeManager getProductIdsFormArray:self.dataArray],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"phone":[HTHoldNullObj getValueWithUnCheakValue:text],
                          @"id": [HTHoldNullObj getValueWithUnCheakValue:self.customerId]
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProduct,refreshBuyProductList] params:dic success:^(id json) {
        self.phone = text;
        self.custModel = [HTCustModel yy_modelWithJSON:json[@"data"][@"cust"]];
        self.bottomView.custModel = self.custModel;
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic  in [json[@"data"] getArrayWithKey:@"products"]) {
            NSDictionary *diccc  =@{ @"data":@{
                                     @"product":@[dic]
                                     }
                                     };
            __weak typeof(self) weakSelf = self;
            [HTHoldChargeManager getProductModelWithJsonData:diccc withModel:^(HTCahargeProductModel *model) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.dataArray addObject:model];
            } andSearchStr:text];
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
//取消按钮确认
- (void)cancelBtClickedWithStr:(NSString *)text{
}
/**
 储值按钮点击
 */
- (void)stroeMoneyClicked{
}

/**
 添加vip电话
 */
- (void)vipBtclicked{
    HTChooseCustomerViewController *choose = [[HTChooseCustomerViewController alloc] init];
    
    choose.delegate = self;
    [self.navigationController pushViewController:choose animated:YES];
//    HTCustomMadeFieldAlertView *phoneAlart =  [[HTCustomMadeFieldAlertView alloc] initWithTitle:@"请输入VIP手机号码" message:@"(凭此号码退换货）" delegate:self];
//    phoneAlart.textField.keyboardType =  UIKeyboardTypePhonePad;
//    [phoneAlart show];
}


- (void)sendDic:(NSDictionary *)dic WithModel:(HTCustomerListModel *)model
{
    if (![dic.allKeys containsObject:@"phone"]) {
        self.customerId = model.custId;
    }
    NSLog(@"传回来");
    [self okBtClickedWithStr:[dic objectForKey:@"phone"]];
}


/**
 编辑商品资料不全商品

 @param model 正在编辑的商品
 */
-(void)okBtClickWithProduct:(HTCahargeProductModel *)model{
//    开启库存
    if ([HTShareClass shareClass].isProductStockActive) {
//        根据颜色 尺码选择的商品  inventory 字段为空  给出相应提示
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
//       根据颜色 尺码选择的商品  inventory（库存）字段为空  给出库存不足提示
    }else if ([[HTHoldNullObj getValueWithUnCheakValue:model.selectedModel.inventory] isEqualToString:@"0"]){
        __weak typeof(self) weakSelf = self;
        HTCustomDefualAlertView *alert =  [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@ 商品库存不足，是否调入",model.selectedModel.barcode] btsArray:@[@"移除",@"去调入"] okBtclicked:^{
            //                去调入页面
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
//    获取到结果清空判断字符串
    [self performSelector:@selector(clearStrWithStr:) withObject:result afterDelay:2];
//   根据条码获取产品资料
    [HTHoldChargeManager getProductDataFromBarcode:result andPhone:[HTHoldNullObj getValueWithUnCheakValue:self.phone] andId:[HTHoldNullObj getValueWithUnCheakValue:self.customerId] WithSucces:^(id json) {
        __weak typeof(self) weakSelf = self;
//        处理产品资料
        [HTHoldChargeManager getProductModelWithJsonData:json withModel:^(HTCahargeProductModel *model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.dataArray addObject:model];
            [strongSelf.tab reloadData];
        } andSearchStr:result];
    }];
}
#pragma mark -EventResponse
/**
 根据输入条码查询商品

 @param barcode 输入条码
 */
-(void)searchProductWithBarCode:(NSString *)barcode{
    [self.view endEditing:YES];
    if (barcode.length < 3) {
        [MBProgressHUD showError:@"识别位数不能小于3位"];
        return;
    }
    [MBProgressHUD showMessage:@""];
//    请求产品资料
    [HTHoldChargeManager getProductDataFromBarcode:barcode andPhone:[HTHoldNullObj getValueWithUnCheakValue:self.phone] andId:[HTHoldNullObj getValueWithUnCheakValue:self.customerId] WithSucces:^(id json) {
        __weak typeof(self) weakSelf = self;
//        处理获取到的产品资料
        [HTHoldChargeManager getProductModelWithJsonData:json withModel:^(HTCahargeProductModel *model) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUD];
            [strongSelf.dataArray addObject:model];
            [strongSelf.tab reloadData];
        } andSearchStr:barcode];
    }];
}

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
#pragma mark -private methods
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
}
- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
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

/**
 计算当前订单的总价
 */
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

/*

- (void)chooseSellerClicked:(UIButton *)button
{
    if (button.tag == 8001) {
        NSLog(@"当前为未弹出");
        [button setImage:[UIImage imageNamed:@"chooseDown"] forState:UIControlStateNormal];
        poper                     = [[Poper alloc] init];
        poper.frame               = CGRectMake(0 ,0, HMSCREENWIDTH,HEIGHT - nav_height - 64 - 100);
        //点击蒙板时的操作
        HTChargeMaskViewController *vc  = [[HTChargeMaskViewController alloc] init];
        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        //必要配置
//        self.modalPresentationStyle = UIModalPresentationCurrentContext;
//        self.providesPresentationContextTransitionStyle = YES;
//        self.definesPresentationContext = YES;
        
        vc.transitioningDelegate  = poper;
//        vc.view.frame = CGRectMake(0 , 0, HMSCREENWIDTH,HEIGHT - nav_height - 64 - 100);
//        vc.dataArray = tapArr;
//        vc.index  = indexPath.row;
//        vc.delegate = self;
//        vc.model = model;
        [self presentViewController:vc animated:YES completion:nil];
//        vc.view.superview.frame = CGRectMake(0 , 0, HMSCREENWIDTH,HEIGHT - nav_height - 64 - 100);
//
//        vc.view.superview.center = self.view.center;
        
        
    }else{
        NSLog(@"当前为弹出");
        [button setImage:[UIImage imageNamed:@"chooseUp"] forState:UIControlStateNormal];
        
    }
}
*/

-(HTCashierBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"HTCashierBottomView" owner:nil options:nil].lastObject;
        _bottomView.frame = CGRectMake(0, HEIGHT - SafeAreaBottomHeight - 61, HMSCREENWIDTH, 61);
//        if (1) {
//            _bottomView.payBtnWidht.constant = 73;
//            _bottomView.sellerChooseBtnWidth.constant = 64;
//            NSString *defaultSeller = [HTShareClass shareClass].loginModel.person.nickname;
//            [_bottomView.sellerChooseBtn setTitle:defaultSeller forState:UIControlStateNormal];
//        }
        _bottomView.delegate = self;
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
        imgview.center = CGPointMake(HMSCREENWIDTH * 0.5, HMSCREENWIDTH * 9 / 32);
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
