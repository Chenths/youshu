//
//  HTReturnSettleViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCashierCustomerTitleView.h"
#import "HTSetterExchangePruductDetailView.h"
#import "HTReturnSettleViewController.h"
#import "NSString+Atribute.h"
#import "HTHoldChargeManager.h"
#import "HTPrinterTool.h"
#import "HTOrderDetailProductModel.h"
#import "HTLoginDataPersonModel.h"
#import "HTCustomTextAlertView.h"
@interface HTReturnSettleViewController ()<UINavigationBarDelegate,UIGestureRecognizerDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *descChangeBt;
@property (weak, nonatomic) IBOutlet UIButton *addDescBt;

@property (weak, nonatomic) IBOutlet UILabel *storedMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *storedSendMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralMoneyLabel;

@property (nonatomic,strong) HTSetterExchangePruductDetailView *detailView;

@property (weak, nonatomic) IBOutlet UIButton *refreshBt;

@property (nonatomic,strong) HTPrinterTool *printTool;

@property (nonatomic,strong) NSString *descString;




@end

@implementation HTReturnSettleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPrintData];
    [self initNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createSub];
    [self setNavHidden];
    [self configUi];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.navigationBar.clipsToBounds = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}
#pragma mark -EventResponse
-(void)closeOrderClicked:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否再争取一下" btsArray:@[@"争取一次",@"残忍拒绝"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
    } cancelClicked:^{
    }];
    [alert show];
}
//-(void)cancelOrderClicked:(UIButton *)sender{
//    __weak typeof(self) weakSelf = self;
//    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否再争取一下" btsArray:@[@"争取一次",@"残忍拒绝"] okBtclicked:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//    } cancelClicked:^{
//    }];
//    [alert show];
//}
- (IBAction)okBtClicked:(id)sender {
    [MBProgressHUD showMessage:@"正在退货..."];
    if (![HTShareClass shareClass].printerModel.lastOrderPrintDic || [HTShareClass shareClass].printerModel.lastOrderPrintDic.allKeys.count > 0) {
        [self returnPost];
    }else{
        NSDictionary *dic = @{
                              @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderId],
                              @"companyId":[HTShareClass shareClass].loginModel.companyId
                              };
        __weak typeof(self) weakSelf = self;
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryOrderPrintInfo4App] params:dic success:^(id json) {
            __strong typeof(weakSelf) strongSelf = self;
            NSDictionary *dataDic = [json getDictionArrayWithKey:@"data"];
            if (dataDic) {
                NSString *isNul = [dataDic getStringWithKey:@"isNull"];
                if ([isNul isEqualToString:@"1"]) {
                    [HTShareClass shareClass].printerModel.lastOrderPrintDic = nil;
                    [strongSelf returnPost];
                }else if ([isNul isEqualToString:@"0"]){
                    if ([dataDic getDictionArrayWithKey:@"printInfo"]) {
                        [[HTShareClass shareClass].printerModel.lastOrderPrintDic setDictionary:[dataDic getDictionArrayWithKey:@"printInfo"]];
                        [strongSelf returnPost];
                    }
                }
            }
        } error:^{
            [MBProgressHUD  hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
        } failure:^(NSError *error) {
            [MBProgressHUD  hideHUD];
            [MBProgressHUD showError:NETERRORSTRING];
        }];
    }
}

- (IBAction)addDescClicked:(id)sender {
    
    [HTCustomTextAlertView showAlertWithTitle:@"订单备注信息" holdTitle:@"请输入订单备注内容" orTextString:nil  okBtclicked:^(NSString * textVale) {
        
        NSDictionary *dic = @{
                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
                              @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                              @"remark":[HTHoldNullObj getValueWithUnCheakValue:textVale]
                              };
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,@"modify_order_remark_4_app.html"] params:dic success:^(id json) {
            [MBProgressHUD hideHUD];
            self.descChangeBt.hidden = NO;
            self.descLabel.hidden = NO;
            self.descLabel.text = textVale;
            self.descString = textVale;
            self.addDescBt.hidden = YES;
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查你的网络"];
        }];
        
    } andCancleBtClicked:^{
    }];
    
}

- (IBAction)changeDescClicked:(id)sender {
    [HTCustomTextAlertView showAlertWithTitle:@"订单备注信息" holdTitle:@"请输入订单备注内容" orTextString:self.descString  okBtclicked:^(NSString * textVale) {
        if ([self.descString isEqualToString:textVale]) {
            return ;
        }
        NSDictionary *dic = @{
                              @"companyId":[HTShareClass shareClass].loginModel.companyId,
                              @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                              @"remark":[HTHoldNullObj getValueWithUnCheakValue:textVale]
                              };
        [MBProgressHUD showMessage:@""];
        [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,@"modify_order_remark_4_app.html"] params:dic success:^(id json) {
            [MBProgressHUD hideHUD];
            self.descChangeBt.hidden = NO;
            self.descLabel.hidden = NO;
            self.descLabel.text = textVale;
            self.descString = textVale;
            self.addDescBt.hidden = YES;
        } error:^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:SeverERRORSTRING];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查你的网络"];
        }];
        
    } andCancleBtClicked:^{
    }];
}

#pragma mark -private methods

-(void)returnPost{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderId],
                          @"detailIds":[HTHoldChargeManager getReturnProductIdsFormArray:self.returnProducts],
                          @"isReturnAll":self.isReturnAll ? @"1" : @"0",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    
    self.refreshBt.enabled = NO;
    __weak typeof(self) weakself = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,returnProduct4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakself) strongSelf = weakself;
        if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"1"]) {
            CGFloat totle = 0.f;
            for (HTOrderDetailProductModel *model in strongSelf.returnProducts) {
                totle += model.finalprice.floatValue;
            }
            if ([strongSelf.orderModel.paytype isEqualToString:@"储值支付"]) {
                [HTShareClass shareClass].printerModel.returnPayType = storedType;
                HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat: @"已将%.2f元,退至该VIP储值账户 ",totle] btTitle:@"确定"  okBtclicked:^{
                    [strongSelf.navigationController  popViewControllerAnimated:YES];
                }];
                [alert notTochShow];
            }else if([strongSelf.orderModel.paytype isEqualToString:@"储值赠送支付"]){
                [HTShareClass shareClass].printerModel.returnPayType = storedSendType;
                HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat: @"已将%.2f元,退至该VIP储值赠送账户 ",totle] btTitle:@"确定"  okBtclicked:^{
                    [strongSelf.navigationController  popViewControllerAnimated:YES];
                }];
                [alert notTochShow];
            }else{
                [HTShareClass shareClass].printerModel.returnPayType = cashType;
                HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat: @"需退该VIP%.2f元",totle] btTitle:@"确定"  okBtclicked:^{
                    //            回上个页面刷新数据
                    [strongSelf.navigationController  popViewControllerAnimated:YES];
                }];
                [alert notTochShow];
            }
            [strongSelf printWithJson:json andTotle:totle];
        }else if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"-1"]){
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"积分余不足,退货失败，应扣除%@积分,余额为%@",[json[@"data"] getStringWithKey:@"deductPoints"],self.custModel.account.stored.balance] btTitle:@"确定"  okBtclicked:^{
            }];
            [alert notTochShow];
        }
        self.refreshBt.enabled = YES;
    } error:^{
        [MBProgressHUD hideHUD];
        self.refreshBt.enabled = YES;
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        self.refreshBt.enabled = YES;
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

-(void)printWithJson:(id)json andTotle:(CGFloat)totle{
    [self.returnProducts enumerateObjectsUsingBlock:^(HTOrderDetailProductModel * md, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.barcode] forKey:@"productCode"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.size] forKey:@"size"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.color] forKey:@"colorNum"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.totalprice] forKey:@"singlePrice"];
        [printDic setObject: [[NSString stringWithFormat:@"%@", md.discount] isEqualToString:@"0.0"]  ?  @"1" : [NSString stringWithFormat:@"%@", md.discount].length == 0 ? @"-10.0" : [NSString stringWithFormat:@"%@", md.discount] forKey:@"discount"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.finalprice ]forKey:@"salePrice"];
        [printDic setObject:@"1" forKey:@"count"];
        [[HTShareClass shareClass].printerModel.returnGoodsList addObject:printDic];
    }];
    NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
    [printDic setObject:[HTShareClass shareClass].loginModel.person.name forKey:@"returnGuider"];
    [printDic setObject:self.orderId forKey:@"returnOrderId"];
    [printDic setObject:[NSString stringWithFormat:@"%0.lf",(0 - totle)] forKey:@"returnOrderFinalPrice"];
    if ([self.orderModel.paytype isEqualToString:@"储值支付"]) {
        [printDic setObject:[NSString stringWithFormat:@"%0.lf",(0 - totle)]forKey:@"returnStoreValue"];
    }
    if ([self.orderModel.paytype isEqualToString:@"储值赠送支付"]) {
        [printDic setObject:[NSString stringWithFormat:@"%0.lf",(0 - totle)]forKey:@"returnFreeStoreValue"];
    }
    [printDic setObject:self.orderModel.ordernum forKey:@"returnOrderNo"];
    [printDic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.phone ] forKey:@"telPhone"];
    [[HTShareClass shareClass].printerModel setValuesForKeysWithDictionary:printDic];
    __weak typeof(self) weakSelf = self;
    self.printTool.presentNext = ^(UIViewController *vc){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf presentViewController:vc animated:YES completion:nil];
    };
    [self.printTool print];
}
-(void)configUi{
    if (self.custModel.custId.length > 0) {
        self.storedMoneyLabel.hidden = NO;
        self.storedSendMoneyLabel.hidden = NO;
        self.integralMoneyLabel.hidden = NO;
       
        self.storedMoneyLabel.text = [NSString stringWithFormat:@"%@ ¥%@",@"储值",self.custModel.account.stored.balance];
        self.storedMoneyLabel.attributedText = [self.storedMoneyLabel.text getAttFormBehindStr:@"储值" behindColor:[UIColor colorWithHexString:@"#222222"]];
        self.storedSendMoneyLabel.text = [NSString stringWithFormat:@"%@ ¥%@",@"储值赠送",self.custModel.account.storedPresented.balance];
        self.storedSendMoneyLabel.attributedText = [self.storedSendMoneyLabel.text getAttFormBehindStr:@"储值赠送" behindColor:[UIColor colorWithHexString:@"#222222"]];
        self.integralMoneyLabel.text = [NSString stringWithFormat:@"%@ ¥%@",@"积分",self.custModel.account.integral.balance];
        self.integralMoneyLabel.attributedText = [self.integralMoneyLabel.text getAttFormBehindStr:@"积分" behindColor:[UIColor colorWithHexString:@"#222222"]];
        HTCashierCustomerTitleView *headView = [[NSBundle mainBundle] loadNibNamed:@"HTCashierCustomerTitleView" owner:nil options:nil].lastObject;
        headView.backgroundColor = [UIColor clearColor];
        headView.model = self.custModel;
        self.navigationItem.titleView = headView;
    }else{
        self.storedMoneyLabel.hidden = YES;
        self.storedSendMoneyLabel.hidden = YES;
        self.integralMoneyLabel.hidden = YES;
        self.title = @"退货";
    }
    self.descChangeBt.hidden = YES;
    self.detailView.returnProducts = self.returnProducts;
    if (self.orderModel.remark.length > 0) {
        self.descLabel.text = self.orderModel.remark;
        self.descString = self.orderModel.remark;
        self.descChangeBt.hidden = NO;
        self.addDescBt.hidden = YES;
    }else{
        self.addDescBt.hidden = NO;
        self.descLabel.hidden = YES;
        self.descChangeBt.hidden = YES;
    }
}
-(void)createSub{
    self.backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height + 60);
    [self.backView setGradientColorWithBeginColor:[UIColor colorWithHexString:@"#FC5C7D"] beginPoint:CGPointMake(0, 0) andEndColor:[UIColor colorWithHexString:@"#6A82FB"] endPoint:CGPointMake(1, 1)];
    [self.refreshBt changeCornerRadiusWithRadius:3];
}
-(void)initNav{
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"取消退货" target:self withColor:[UIColor whiteColor] action:@selector(closeOrderClicked:)];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"退货" target:self withColor:[UIColor whiteColor] action:@selector(cancelOrderClicked:)];
    
    self.detailView = [[HTSetterExchangePruductDetailView alloc] initWithDetailFrame:CGRectMake(16,self.storedMoneyLabel.y + 36, HMSCREENWIDTH - 32, 240)] ;
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.view addSubview:self.detailView];
    });
}
- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
  
    self.navigationController.navigationBar.translucent = YES;
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
-(void)loadPrintData{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderId],
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
-(HTPrinterTool *)printTool{
    if (!_printTool) {
        _printTool = [[HTPrinterTool alloc] init];
    }
    return _printTool;
}
@end
