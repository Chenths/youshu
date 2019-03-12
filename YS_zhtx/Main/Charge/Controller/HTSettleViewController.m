//
//  HTSettleViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSettleViewController.h"
#import "HTLoginVienController.h"
#import "HTChangePriceViewController.h"
#import "NSString+Atribute.h"
#import "HTHoldSettleManager.h"
#import "HTCahargeProductModel.h"
#import "HTHoldChargeManager.h"
#import "HTPrinterTool.h"
#import "HTCashierCustomerTitleView.h"
#import "HTCustomTextAlertView.h"
#import <MessageUI/MessageUI.h>
#import "HTEditVipViewController.h"
#import "HTTelMsgAlertView.h"
@interface HTSettleViewController ()<UINavigationBarDelegate,UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate>{
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UILabel *storedMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *storedSendMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralMoneyLabel;


@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totlePriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payBarcodeImg;

@property (weak, nonatomic) IBOutlet UIButton *cashPayBt;
@property (weak, nonatomic) IBOutlet UIButton *storedBt;
@property (weak, nonatomic) IBOutlet UIButton *posBt;
@property (weak, nonatomic) IBOutlet UIButton *storedSendBt;
@property (weak, nonatomic) IBOutlet UIButton *addDescBt;
@property (weak, nonatomic) IBOutlet UIButton *refreshBt;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIScrollView *backScollerView;

@property (weak, nonatomic) IBOutlet UIView *tapView;

@property (weak, nonatomic) IBOutlet UILabel *imgHoldImg;

@property (nonatomic,strong) NSString *wechatPayOrderId;

@property (nonatomic,strong) HTPrinterTool *printerManager;
@property (nonatomic,strong) NSString *descString;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *descChangeBt;


@end

@implementation HTSettleViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubView];
    [self initNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavHidden];
    [self configUi];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
    
    [_timer invalidate];
    _timer = nil;
}
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

/**
 *  发送消息
 *
 *  @param tel 电话
 *  @param msg 消息内容
 */
- (void)sendMessegeWithPhone:(NSString *) tel andMsg:(NSString *) msg{
    [self showMessageView:@[tel] title:@"新消息" body:msg];
}
/**
 *  发送短息 url
 *
 *  @param phones 电话号码
 *  @param title  标题
 *  @param body   内容
 */
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    __weak typeof(self ) weakSelf = self;
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        controller.body = body;
        controller.messageComposeDelegate = weakSelf;
        
        for (UIView *obj in controller.view.subviews) {
            if ([[obj class] isSubclassOfClass:[UITextField class]]) {
                UITextField *textFied =  (UITextField *)obj;
                textFied.enabled      = NO;
            }
        }
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
        vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
        for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
            if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                vc.customerFollowRecordId = [mode.moduleId stringValue];
            }
            if ([mode.moduleName isEqualToString:@"customer"]) {
                vc.moduleModel = mode;
            }
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
     
    }
}
//短信发送成功回调
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
//            push到客户编辑页面
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
            break;
            
        case MessageComposeResultFailed:
            //信息传送失败
        {
         
            //            push到客户编辑页面
            
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
            break;
        case MessageComposeResultCancelled:
        {
            //信息被用户取消传送
            HTEditVipViewController *vc = [[HTEditVipViewController alloc] init];
            vc.modelId = [HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId];
            for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
                if ([mode.moduleName isEqualToString:@"customerFollowRecord"]) {
                    vc.customerFollowRecordId = [mode.moduleId stringValue];
                }
                if ([mode.moduleName isEqualToString:@"customer"]) {
                    vc.moduleModel = mode;
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -EventResponse
//储值赠送支付
- (IBAction)storedSendClicked:(UIButton *)sender {
    if ([HTShareClass shareClass].smsConfig == 0) {
        [self storeSendLoadWith:sender];
    }else{
        __weak typeof(self) weakSelf = self;
        [HTTelMsgAlertView showAlertWithName:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.nickname] andPhone:self.custModel.phone andCustomerId:self.custModel.customerid andOkBt:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf storeSendLoadWith:sender];
        }];
    }
    
}
//刷卡支付
- (IBAction)posClicked:(UIButton *)sender {
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"orderState":@"2",
                          @"payType":@"3",
                          @"isPos":@"1",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"productCount":@(self.products.count),
                          @"qrProductIds":[HTHoldChargeManager getProductIdsFormArray:self.products],
                              };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    sender.enabled = NO;
    [HTHoldSettleManager caishPayWithPosDic:dic andSucces:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdPayResultWithJson:json andEventSender:sender];
    } severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络繁忙,支付失败"];
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"请检查你的网络,支付失败"];
    }];
}
//储值支付
- (IBAction)storedClicked:(UIButton *)sender {
    if ([HTShareClass shareClass].smsConfig == 0) {
        [self storeLoadWith:sender];
    }else{
        __weak typeof(self) weakSelf = self;
        [HTTelMsgAlertView showAlertWithName:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.nickname] andPhone:self.custModel.phone andCustomerId:self.custModel.customerid andOkBt:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf storeLoadWith:sender];
        }];
    }
}
//现金支付
- (IBAction)caishPayClicked:(UIButton *)sender {
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"orderState":@"2",
                          @"payType":@"3",
                          @"isPos":@"0",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"productCount":@(self.products.count),
                          @"qrProductIds":[HTHoldNullObj getValueWithUnCheakValue:[HTHoldChargeManager getProductIdsFormArray:self.products]],
                          };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    sender.enabled = NO;
    [HTHoldSettleManager caishPayWithPosDic:dic andSucces:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdPayResultWithJson:json andEventSender:sender];
    } severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络繁忙,支付失败"];
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"请检查你的网络,支付失败"];
    }];
}
//店铺微信支付
- (IBAction)shopWechatPayClicked:(UIButton *)sender {
    
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"orderState":@"2",
                          @"payType":@"5",
                          @"mPayType":@"1",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"productCount":@(self.products.count),
                          @"qrProductIds":[HTHoldChargeManager getProductIdsFormArray:self.products],
                          };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    sender.enabled = NO;
    [HTHoldSettleManager shopAliOrWechatPayWithPosDic:dic Succes:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdPayResultWithJson:json andEventSender:sender];
    } severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络繁忙,支付失败"];
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"请检查你的网络,支付失败"];
    }];
    
}
//店铺支付宝支付
- (IBAction)shopAliPayClicked:(UIButton *)sender {
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"orderState":@"2",
                          @"payType":@"5",
                          @"mPayType":@"2",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"productCount":@(self.products.count),
                          @"qrProductIds":[HTHoldChargeManager getProductIdsFormArray:self.products],
                          };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    sender.enabled = NO;
    [HTHoldSettleManager shopAliOrWechatPayWithPosDic:dic Succes:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdPayResultWithJson:json andEventSender:sender];
    } severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络繁忙,支付失败"];
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        [MBProgressHUD showError:@"请检查你的网络,支付失败"];
    }];
}
//查询扫码支付结果
- (IBAction)refreshPayResultClicked:(UIButton *)sender {
    
    [self refreshCodePayWithState:NO andSender:sender];
}

-(void)closeOrderClicked:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否再争取一下" btsArray:@[@"争取一次",@"残忍拒绝"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdCancelOrCloseWithOrderState:@"4"];
    } cancelClicked:^{
    }];
    [alert show];
}
-(void)cancelOrderClicked:(UIButton *)sender{
     __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否再争取一下" btsArray:@[@"争取一次",@"残忍拒绝"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdCancelOrCloseWithOrderState:@"3"];
    } cancelClicked:^{
    }];
    [alert show];
}
- (IBAction)moreBtClicked:(id)sender {
//    __weak typeof(self) weakSelf = self;
//    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"改价",@"使用积分"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (index == 2) {
//
//        }else if(index == 1){
            HTChangePriceViewController *vc = [[HTChangePriceViewController alloc] init];
            vc.oldDataArray = self.products;
            vc.orderModel = self.orderModel;
            NSMutableArray *copyArray = [NSMutableArray array];
            for (HTCahargeProductModel *model in self.products) {
                NSDictionary *dic = [model yy_modelToJSONObject];
                HTCahargeProductModel *mm = [HTCahargeProductModel yy_modelWithJSON:dic];
                [copyArray addObject:mm];
            }
            vc.dataArray = copyArray;
            vc.custModel = self.custModel;
            __weak typeof(self) weakSelf = self;
            vc.didChange = ^(NSArray *backArray, NSString *wechatPayOrderId, NSString *finalPrice, NSString *payCode) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.products = backArray;
                strongSelf.orderModel.finalprice = finalPrice;
                strongSelf.payCode = payCode;
                strongSelf.wechatPayOrderId = wechatPayOrderId;
                [strongSelf configUi];
            };
            vc.didpay = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.printerManager.pushNext = ^{
                    __strong typeof(weakSelf) strongsSelf = weakSelf;
                    [strongsSelf print];
                    [strongsSelf.navigationController popToRootViewControllerAnimated:YES];
                };
            };
            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
}
//添加备注点击
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
//修改备注点击
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

-(void)autoQueryStateRequest{
    [self refreshCodePayWithState:YES andSender:nil];
}
#pragma mark -private methods
//刷新支付宝请求
-(void)refreshCodePayWithState:(BOOL)isAuto andSender:(UIButton *)sender{
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"companyId"  :[HTShareClass shareClass].loginModel.companyId,
                          @"productCount":[NSString stringWithFormat:@"%ld", self.products.count],
                          @"qrProductIds":[HTHoldChargeManager getProductIdsFormArray:self.products],
                          @"wechatPayOrderId":[HTHoldNullObj getValueWithUnCheakValue: self.wechatPayOrderId],
                          @"requestNum":[HTHoldNullObj getValueWithUnCheakValue:self.requestNum]
                          };
    if (!isAuto) {
       [MBProgressHUD showMessage:@""];
    }
    sender.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [HTHoldSettleManager refreshAliOrWechatPayWithPosDic:dic Succes:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [strongSelf holdPayResultWithJson:json andEventSender:sender];
        }else{
            sender.enabled = YES;
            if (!isAuto) {
                [MBProgressHUD showError:@"该订单尚未完成支付"];
            }
        }
    } severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        if (!isAuto) {
            [MBProgressHUD showError:SeverERRORSTRING];
        }
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        if (!isAuto) {
            [MBProgressHUD showError:NETERRORSTRING];
        }
    }];
}
//储值赠送支付请求
-(void)storeSendLoadWith:(UIButton *)sender{
    NSDictionary *dic = @{
                          @"customerId" :[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId] ,
                          @"companyId"  :[HTShareClass shareClass].loginModel.companyId,
                          @"totalPrice" : self.orderModel.finalprice,
                          @"orderId"    : self.orderModel.orderId,
                          @"accountId"  : [HTHoldNullObj getValueWithUnCheakValue:self.custModel.account.storedPresented.accoutId],
                          @"productCount":@(self.products.count),
                          @"qrProductIds":[HTHoldChargeManager getProductIdsFormArray:self.products]
                          };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    sender.enabled = NO;
    [HTHoldSettleManager storedPayWithPosDic:dic andSucces:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdStoredPayResultWithJson:json andEventSender:sender];
    }  severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"网络繁忙,支付失败" btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"网络繁忙,支付失败" btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
    }];
}
//储值支付请求
-(void)storeLoadWith:(UIButton *)sender{
    NSDictionary *dic = @{
                          @"customerId" :[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId] ,
                          @"companyId"  :[HTShareClass shareClass].loginModel.companyId,
                          @"totalPrice" : self.orderModel.finalprice,
                          @"orderId"    : self.orderModel.orderId,
                          @"accountId"  : [HTHoldNullObj getValueWithUnCheakValue:self.custModel.account.stored.accoutId],
                          @"productCount":@(self.products.count),
                          @"qrProductIds":[HTHoldChargeManager getProductIdsFormArray:self.products]
                          };
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    sender.enabled = NO;
    [HTHoldSettleManager storedPayWithPosDic:dic andSucces:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf holdStoredPayResultWithJson:json andEventSender:sender];
    } severError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"网络繁忙,支付失败" btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
    } andError:^{
        [MBProgressHUD hideHUD];
        sender.enabled = YES;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"网络繁忙,支付失败" btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
    }];
}
-(void)createSubView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.backView.frame = CGRectMake(0, 0, HMSCREENWIDTH, self.addDescBt.y + 100 > HEIGHT ? self.addDescBt.y + 100 : HEIGHT );
     [self.backView setGradientColorWithBeginColor:[UIColor colorWithHexString:@"#FC5C7D"] beginPoint:CGPointMake(0, 0) andEndColor:[UIColor colorWithHexString:@"#6A82FB"] endPoint:CGPointMake(1, 1)];
    [self.backScollerView addSubview:self.backView];
    self.backScollerView.contentSize = CGSizeMake(HMSCREENWIDTH,self.addDescBt.y + 100 > HEIGHT ? self.addDescBt.y + 100 : HEIGHT);
    self.backScollerView.showsVerticalScrollIndicator = NO;
    self.backScollerView.showsHorizontalScrollIndicator = NO;
    [self.refreshBt changeCornerRadiusWithRadius:3];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(autoQueryStateRequest) userInfo:nil repeats:YES];
    
}
-(void)initNav{
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"关闭订单" target:self withColor:[UIColor whiteColor] action:@selector(closeOrderClicked:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"取消订单" target:self withColor:[UIColor whiteColor] action:@selector(cancelOrderClicked:)];
}
- (void)setNavHidden {
    UIColor *color = [UIColor whiteColor];
    UIImage *image = [self imageWithColor:[color colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = image;
    [self.navigationController.navigationBar setShadowImage:UIGraphicsGetImageFromCurrentImageContext()];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    self.navigationController.navigationBar.clipsToBounds = YES;
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
-(void)configUi{
    if (self.custModel.custId.length > 0) {
        self.storedMoneyLabel.hidden = NO;
        self.storedSendMoneyLabel.hidden = NO;
        self.integralMoneyLabel.hidden = NO;
        self.storedBt.enabled = YES;
        if (self.custModel.isfreestorevalueaccountactive.boolValue) {
            self.storedSendBt.enabled = YES;
        }else{
            self.storedSendBt.enabled = NO;
        }
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
        self.storedBt.enabled = NO;
        self.storedSendBt.enabled = NO;
    }
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.encodeFinal];
    self.totlePriceLabel.text = [NSString stringWithFormat:@"¥%@",self.orderModel.encodeTotal];
    
    if (self.addUrl.length > 0) {
        [self.payBarcodeImg sd_setImageWithURL:[NSURL URLWithString:self.addUrl] placeholderImage:[UIImage imageNamed:@"g-notBarcodeImg"]];
        self.imgHoldImg.text = @"暂未开通平台在线支付功能";
        self.imgHoldImg.textColor = [UIColor colorWithHexString:@"#999999"];
    }else if (self.payCode.length > 0){
        self.payBarcodeImg.image = [HTHoldSettleManager createCodeImageWithValue:self.payCode];
        self.imgHoldImg.text = @"扫描二维码进行微信、支付宝支付";
        self.imgHoldImg.textColor = [UIColor colorWithHexString:@"#222222"];
    }else{
        self.payBarcodeImg.image = [UIImage imageNamed:@"g-notBarcodeImg"];
        self.imgHoldImg.text = @"暂未开通平台在线支付功能";
        self.imgHoldImg.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    self.descLabel.hidden = YES;
    self.descChangeBt.hidden = YES;
}
-(void)holdPayResultWithJson:(id)json andEventSender:(UIButton *)sender{
    [MBProgressHUD hideHUD];
    if ([[json[@"data"] getStringWithKey:@"isScan"] isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"顾客正在进行扫码支付，不能进行此操作"];
        sender.enabled = YES;
        return ;
    }
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"交易已成功"];
    if (sender.tag - 1000 == 0 ) {
        [HTShareClass shareClass].printerModel.paytype = alipayType ;
    }else if (sender.tag - 1000 == 1){
        [HTShareClass shareClass].printerModel.paytype = wetchatType ;
    }else if (sender.tag - 1000 == 2){
        [HTShareClass shareClass].printerModel.paytype = cashType ;
    }else if (sender.tag - 1000 == 3){
        [HTShareClass shareClass].printerModel.paytype = posType ;
    }
    [self settleSuccessWithMsg:json[@"data"][@"sms"]];
    [self print];
}
-(void)holdStoredPayResultWithJson:(id)json andEventSender:(UIButton *)sender{
    
    if ([[json[@"data"] getStringWithKey:@"isScan"] isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"顾客正在进行扫码支付，不能进行此操作"];
        sender.enabled = YES;
        return ;
    }
    if ([json[@"data"][@"state"]  intValue]) {
        [MBProgressHUD hideHUD];
        __weak typeof(self) weakSelf = self;
         HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:json[@"data"][@"msg"] btTitle:@"确定" okBtclicked:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
             if (sender == strongSelf.storedBt) {
                 [HTShareClass shareClass].printerModel.paytype = storedType;
                 [HTShareClass shareClass].printerModel.storeValue = [NSString stringWithFormat:@"%@",self.orderModel.encodeFinal];
             }
             if (sender == strongSelf.storedSendBt) {
                 [HTShareClass shareClass].printerModel.paytype = storedSendType;
                 [HTShareClass shareClass].printerModel.freeStoreValue = [NSString stringWithFormat:@"%@",self.orderModel.encodeFinal];
             }
            [strongSelf settleSuccessWithMsg:json[@"data"][@"sms"]];
            [strongSelf print];
        }];
        [alert notTochShow];
    }else{
        [MBProgressHUD hideHUD];
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:json[@"data"][@"msg"] btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
        sender.enabled = YES;
    }
}
/**
 下单成功后的统一操作
 
 @param msg 发送短信内容
 */
- (void)settleSuccessWithMsg:(NSString *)msg{
    [self clearCache];
    if (self.custModel.custId.length > 0 && self.custModel.phone.length > 0 && msg.length > 0) {
        __weak typeof(self) weakSelf = self;
        self.printerManager.pushNext = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
          [strongSelf sendMessegeWithPhone:[HTHoldNullObj getValueWithUnCheakValue:strongSelf.custModel.phone] andMsg:msg];
        };
    }else{
        __weak typeof(self) weakSelf = self;
        self.printerManager.pushNext = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
}

/**
 清除缓存
 */
-(void)clearCache{
    NSDictionary *dic = [NSDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:STROREUNFINSHORDER];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",0] forKey:STROREUNFINSHORDERTIME];
}
//打印
-(void)print{
//构造打印数据
    [HTShareClass shareClass].printerModel.orderTotalPrize = self.orderModel.encodeTotal;
    [HTShareClass shareClass].printerModel.orderFinalPrize = self.orderModel.encodeFinal;
    [HTShareClass shareClass].printerModel.orderId = self.orderModel.orderId;
    [HTShareClass shareClass].printerModel.orderNo = self.orderModel.ordernum;
    [HTShareClass shareClass].printerModel.telPhone = self.custModel.phone;
    [self.products enumerateObjectsUsingBlock:^(HTCahargeProductModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
        HTChargeProductInfoModel *md = obj.selectedModel ;
        [printDic setObject:[NSString stringWithFormat:@"%@",md.barcode] forKey:@"productCode"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.size] forKey:@"size"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.color] forKey:@"colorNum"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.price] forKey:@"singlePrice"];
        [printDic setObject: [[NSString stringWithFormat:@"%@", md.discount] isEqualToString:@"0.0"]  ?  @"1" : [NSString stringWithFormat:@"%@", md.discount].length == 0 ? @"-10.0" : [NSString stringWithFormat:@"%@", md.discount] forKey:@"discount"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.finalprice ]forKey:@"salePrice"];
        [printDic setObject:@"1" forKey:@"count"];
        [[HTShareClass shareClass].printerModel.goodsList addObject:printDic];
    }];
    [HTShareClass shareClass].printerModel.orderDesc = self.descString;
//    发送打印请求
    [self.printerManager print];
}
-(void)holdCancelOrCloseWithOrderState:(NSString *)state{
    
    NSDictionary *dic = @{
                          @"orderId":[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.orderId],
                          @"companyId"  :[HTShareClass shareClass].loginModel.companyId,
                          @"orderState":[HTHoldNullObj getValueWithUnCheakValue:state],
                          @"qrProductIds":[HTHoldNullObj getValueWithUnCheakValue: [HTHoldChargeManager getProductIdsFormArray:self.products]],
                          @"payType":@"",
                          @"wechatPayOrderId":[HTHoldNullObj getValueWithUnCheakValue:self.wechatPayOrderId],
                              };
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [HTHoldSettleManager cancelOrCloseOrderWithPosDic:dic Succes:^(id json) {
        [MBProgressHUD hideHUD];
        if ([[json[@"data"] getStringWithKey:@"orderStatus"] isEqualToString:@"2"]) {
            
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"该订单已支付成功，不能进行该操作" btTitle:@"确定" okBtclicked:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf settleSuccessWithMsg:json[@"data"][@"sms"]];
                [strongSelf print];
            }];
            [alert notTochShow];
            return ;
        }
        [self clearCache];
        if ([state isEqualToString:@"3"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
         [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } severError:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } andError:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
#pragma mark - getters and setters
-(HTPrinterTool *)printerManager{
    if (!_printerManager) {
        _printerManager = [[HTPrinterTool alloc] init];
    }
    return _printerManager;
}

@end
