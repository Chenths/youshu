//
//  HTSettleViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChangeSettleViewController.h"
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
#import "HTLoginDataPersonModel.h"
#import "HTSetterExchangePruductDetailView.h"
#import "SecurityUtil.h"
#import "HTTelMsgAlertView.h"
@interface HTChangeSettleViewController ()<UINavigationBarDelegate,UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate,HTSetterExchangePruductDetailViewDelegate>{
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



@property (nonatomic,strong) HTPrinterTool *printerManager;
@property (nonatomic,strong) NSString *descString;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *descChangeBt;

@property (weak, nonatomic) IBOutlet UIButton *okPayBt;

@property (weak, nonatomic) IBOutlet UIButton *aliPayBt;

@property (weak, nonatomic) IBOutlet UIImageView *aliPayImg;

@property (weak, nonatomic) IBOutlet UILabel *aliPayLabel;

@property (weak, nonatomic) IBOutlet UIImageView *wechatImg;
@property (weak, nonatomic) IBOutlet UILabel *wechatTitle;
@property (weak, nonatomic) IBOutlet UIButton *wechatBt;

@property (weak, nonatomic) IBOutlet UIButton *detailDownBt;

@property (nonatomic,strong) HTSetterExchangePruductDetailView *detailView;

@property (weak, nonatomic) IBOutlet UIImageView *settleBackImg;

@property (nonatomic,assign) NSTimeInterval beginTime;

@end

@implementation HTChangeSettleViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubView];
    [self initNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    self.beginTime = [dat timeIntervalSince1970];
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
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate
-(void)coloseBtClicekd{
    [UIView animateWithDuration:0.3 animations:^{
         self.detailView.frame = CGRectMake(16,self.settleBackImg.y, HMSCREENWIDTH - 32, 0);
    } completion:^(BOOL finished) {
        self.detailView.hidden = YES;
    }];
}
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
        NSDictionary *dic = @{
                              @"accountId":[HTHoldNullObj getValueWithUnCheakValue:self.custModel.account.storedPresented.accoutId]
                              };
        [MBProgressHUD showMessage:@""];
        [self repalceRequest:dic andIsStore:YES eventBt:sender];
    }else{
        __weak typeof(self) weakSelf = self;
        [HTTelMsgAlertView showAlertWithName:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.nickname] andPhone:self.custModel.phone andOkBt:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSDictionary *dic = @{
                                  @"accountId":[HTHoldNullObj getValueWithUnCheakValue:strongSelf.custModel.account.storedPresented.accoutId]
                                  };
            [MBProgressHUD showMessage:@""];
            [strongSelf repalceRequest:dic andIsStore:YES eventBt:sender];
        }];
    }
   
}
//刷卡支付
- (IBAction)posClicked:(UIButton *)sender {
    [MBProgressHUD showMessage:@""];
    [self repalceRequest:nil andIsStore:NO eventBt:sender];
}
//储值支付
- (IBAction)storedClicked:(UIButton *)sender {
    if ([HTShareClass shareClass].smsConfig == 0) {
        NSDictionary *dic = @{
                              @"accountId":[HTHoldNullObj getValueWithUnCheakValue:self.custModel.account.stored.accoutId]
                              };
        [MBProgressHUD showMessage:@""];
        [self repalceRequest:dic andIsStore:YES eventBt:sender];
    }else{
        __weak typeof(self) weakSelf = self;
        [HTTelMsgAlertView showAlertWithName:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.nickname] andPhone:self.custModel.phone andOkBt:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSDictionary *dic = @{
                                  @"accountId":[HTHoldNullObj getValueWithUnCheakValue:strongSelf.custModel.account.stored.accoutId]
                                  };
            [MBProgressHUD showMessage:@""];
            [strongSelf repalceRequest:dic andIsStore:YES eventBt:sender];
        }];
    }
   
}
//现金支付
- (IBAction)caishPayClicked:(UIButton *)sender {
     [MBProgressHUD showMessage:@""];
     [self repalceRequest:nil andIsStore:NO eventBt:sender];
}
//店铺微信支付
- (IBAction)shopWechatPayClicked:(UIButton *)sender {
     [MBProgressHUD showMessage:@""];
     [self repalceRequest:nil andIsStore:NO eventBt:sender];
    
}
//店铺支付宝支付
- (IBAction)shopAliPayClicked:(UIButton *)sender {
    [MBProgressHUD showMessage:@""];
   [self repalceRequest:nil andIsStore:NO eventBt:sender];
}
//查询扫码支付结果
- (IBAction)refreshPayResultClicked:(id)sender {
    [MBProgressHUD showMessage:@""];
    [self autoQueryStateRequest];
}

-(void)closeOrderClicked:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:@"是否再争取一下" btsArray:@[@"争取一次",@"残忍拒绝"] okBtclicked:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf cancleOrCloseLoadWithState:YES];
    } cancelClicked:^{
    }];
    [alert show];
}
-(void)cancelOrderClicked:(UIButton *)sender{
    [self cancleOrCloseLoadWithState:NO];
}
- (IBAction)moreBtClicked:(id)sender {
//    __weak typeof(self) weakSelf = self;
//    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"改价",@"使用积分"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (index == 2) {
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
            vc.isReturn = YES;
            vc.custModel = self.custModel;
            CGFloat totl = 0.0f;
            for (HTOrderDetailProductModel *mm in self.returnArray) {
                totl += mm.finalprice.floatValue;
            }
            vc.changePrice = [SecurityUtil encryptAESData:[NSString stringWithFormat:@"%.2lf",totl]];
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

- (IBAction)showDetailClicked:(id)sender {
    
    self.detailView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.detailView.frame = CGRectMake(16,self.settleBackImg.y, HMSCREENWIDTH - 32, 390);
    }];
    
}

#pragma mark -private methods


- (void)cancleOrCloseLoadWithState:(BOOL) state{
    
    NSDictionary *dic = @{
                          @"bcProductJsonStr":[HTHoldChargeManager getbcProductJsonStrFormArray:self.products],
                          @"replaceDetailIds":[HTHoldChargeManager getReturnProductIdsFormArray:self.returnArray],
                          @"companyId":[HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId],
                          @"orderId":self.orderModel.orderId,
                          };
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,cancelReplaceProduct] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (state) {
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
          
        }else{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
          [self clearCache];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
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
    [self.okPayBt changeCornerRadiusWithRadius:3];
    self.detailView = [[HTSetterExchangePruductDetailView alloc] initWithDetailFrame:CGRectMake(16,self.settleBackImg.y, HMSCREENWIDTH - 32, 0)] ;
    self.detailView.hidden = YES;
    self.detailView.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.detailView];
    });
    
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
        headView.nameLable.textColor = [UIColor whiteColor];
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
    if (self.orderDetail.remark.length > 0) {
        self.descLabel.text = self.orderDetail.remark;
        self.descString = self.orderDetail.remark;
        self.descLabel.hidden = NO;
        self.descChangeBt.hidden = NO;
        self.addDescBt.hidden = YES;
    }else{
        self.descLabel.hidden = YES;
        self.descChangeBt.hidden = YES;
        self.addDescBt.hidden = NO;
    }
    self.okPayBt.hidden = YES;
    [self configAlipayIsEnabel:NO];
    [self configWechatpayIsEnabel:NO];
    if (self.orderModel.encodeFinal.floatValue < 0) {
        self.okPayBt.hidden = NO;
        self.refreshBt.hidden = YES;
        self.storedBt.enabled = NO;
        self.storedSendBt.enabled = NO;
        self.cashPayBt.enabled = NO;
        self.posBt.enabled = NO;
        if ([self.orderModel.paytype isEqualToString:@"2"]) {
            [self.okPayBt addTarget:self action:@selector(storedClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([self.orderModel.paytype isEqualToString:@"4"]){
            [self.okPayBt addTarget:self action:@selector(storedSendClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.okPayBt addTarget:self action:@selector(posClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
     if ([self.orderModel.paytype isEqualToString:@"1"]) {
        self.refreshBt.hidden = NO;
        self.storedBt.enabled = NO;
        self.storedSendBt.enabled = NO;
        self.cashPayBt.enabled = NO;
        self.posBt.enabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(autoQueryStateRequest) userInfo:nil repeats:YES];
      }else if ([self.orderModel.paytype isEqualToString:@"2"]){
        self.refreshBt.hidden = YES;
        self.storedBt.enabled = YES;
        self.storedSendBt.enabled = NO;
        self.cashPayBt.enabled = NO;
        self.posBt.enabled = NO;
      }else if ([self.orderModel.paytype isEqualToString:@"3"]){
        self.refreshBt.hidden = YES;
        self.storedBt.enabled = NO;
        self.storedSendBt.enabled = NO;
        if ([[HTHoldNullObj getValueWithUnCheakValue:self.orderModel.ispos] isEqualToString:@"0"]) {
            self.cashPayBt.enabled = YES;
            self.posBt.enabled = NO;
        }else{
            self.cashPayBt.enabled = NO;
            self.posBt.enabled = YES;
        }
      }else if ([self.orderModel.paytype isEqualToString:@"5"]){
          self.refreshBt.hidden = NO;
          self.storedBt.enabled = NO;
          self.storedSendBt.enabled = NO;
          self.cashPayBt.enabled = NO;
          self.posBt.enabled = NO;
          if ([self.orderModel.mpaymenttype isEqualToString:@"2"]) {
              [self configAlipayIsEnabel:YES];
          }else if ([self.orderModel.mpaymenttype isEqualToString:@"1"]){
              [self configWechatpayIsEnabel:YES];
          }
      }
    }
    self.detailView.returnProducts = self.returnArray;
    self.detailView.changeProducts = self.products;
    self.detailView.orderPrice = self.orderModel.encodeFinal;
}
-(void)holdPayResultWithJson:(id)json andEventSender:(UIButton *)sender{
    [MBProgressHUD hideHUD];
    if ([[json[@"data"] getStringWithKey:@"isScan"] isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"顾客正在进行扫码支付，不能进行此操作"];
        sender.enabled = YES;
        return ;
    }
    if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"-1"]){
        HTAccoutInfoModel *accoun = self.custModel.account.integral;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"积分余不足,退货失败，应扣除%@积分,余额为%@",[json[@"data"] getStringWithKey:@"deductpoints"],accoun.balance ?  accoun.balance :@"0"] btTitle:@"确定" okBtclicked:nil];
        [alert notTochShow];
        return;
    }
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"交易已成功"];
    if (sender.tag - 1000 == 0 ) {
        [HTShareClass shareClass].printerModel.returnPayType = alipayType ;
    }else if (sender.tag - 1000 == 1){
        [HTShareClass shareClass].printerModel.returnPayType = wetchatType ;
    }else if (sender.tag - 1000 == 2){
        [HTShareClass shareClass].printerModel.returnPayType = cashType ;
    }else if (sender.tag - 1000 == 3){
        [HTShareClass shareClass].printerModel.returnPayType = posType ;
    }
    if (self.orderModel.encodeFinal.floatValue < 0) {
        __weak typeof(self) weakSelf = self;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"需退该VIP %0.lf 元",fabsf(self.orderModel.encodeFinal.floatValue)] btTitle:@"确定" okBtclicked:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf settleSuccessWithMsg:json[@"data"][@"sms"]];
            [strongSelf print];
        }];
        [alert notTochShow];
    }else{
       [self settleSuccessWithMsg:json[@"data"][@"sms"]];
       [self print];
    }
}
-(void)holdStoredPayResultWithJson:(id)json andEventSender:(UIButton *)sender{
    
    if ([[json[@"data"] getStringWithKey:@"isScan"] isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"顾客正在进行扫码支付，不能进行此操作"];
        sender.enabled = YES;
        return ;
    }
    
    if ([[json[@"data"] getStringWithKey:@"state"] isEqualToString:@"-1"]){
       if ([json[@"data"] getStringWithKey:@"deductpoints"].length > 0) {
        HTAccoutInfoModel *accoun = self.custModel.account.integral;
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"积分余不足,退货失败，应扣除%@积分,余额为%@",[json[@"data"] getStringWithKey:@"deductpoints"],accoun.balance ?  accoun.balance :@"0"] btTitle:@"确定" okBtclicked:nil];
        [alert notTochShow];
       }else{
           HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"储值余额不足,退货失败，应扣除%@,余额为%@",[json[@"data"] getStringWithKey:@"balance"],self.orderModel.encodeFinal] btTitle:@"确定" okBtclicked:nil];
           [alert notTochShow];
       }
        return;
    }
        [MBProgressHUD hideHUD];
        __weak typeof(self) weakSelf = self;
    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:self.orderModel.encodeFinal.floatValue < 0 ? [NSString stringWithFormat:@"已将 %0.lf元退至该VIP%@账户",fabsf(self.orderModel.encodeFinal.floatValue), sender == self.storedBt ? @"储值账户" :@"储值赠送帐户"] : json[@"data"][@"msg"] btTitle:@"确定" okBtclicked:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
             if (sender == strongSelf.storedBt) {
                 [HTShareClass shareClass].printerModel.returnPayType = storedType;
                 [HTShareClass shareClass].printerModel.returnStoreValue = [NSString stringWithFormat:@"%@",self.orderModel.encodeFinal];
             }
             if (sender == strongSelf.storedSendBt) {
                 [HTShareClass shareClass].printerModel.returnPayType = storedSendType;
                 [HTShareClass shareClass].printerModel.returnFreeStoreValue = [NSString stringWithFormat:@"%@",self.orderModel.encodeFinal];
             }
            [strongSelf settleSuccessWithMsg:json[@"data"][@"sms"]];
            [strongSelf print];
        }];
        [alert notTochShow];
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

    
    [HTShareClass shareClass].printerModel.returnOrderFinalPrice = self.orderModel.encodeFinal;
    [HTShareClass shareClass].printerModel.orderId = self.orderModel.orderId;
    [HTShareClass shareClass].printerModel.orderNo = self.orderModel.ordernum;
    [HTShareClass shareClass].printerModel.telPhone = self.custModel.phone;
    
    [self.returnArray enumerateObjectsUsingBlock:^(HTOrderDetailProductModel * md, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *printDic = [NSMutableDictionary dictionary];
        
        [printDic setObject:[NSString stringWithFormat:@"%@",md.barcode] forKey:@"productCode"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.size] forKey:@"size"];
        [printDic setObject:[NSString stringWithFormat:@"%@",md.color] forKey:@"colorNum"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.finalprice] forKey:@"singlePrice"];
        [printDic setObject: [[NSString stringWithFormat:@"%@", md.discount] isEqualToString:@"0.0"]  ?  @"1" : [NSString stringWithFormat:@"%@", md.discount].length == 0 ? @"-10.0" : [NSString stringWithFormat:@"%@", md.discount] forKey:@"discount"];
        [printDic setObject:[NSString stringWithFormat:@"%@", md.finalprice ]forKey:@"salePrice"];
        [printDic setObject:@"1" forKey:@"count"];
        [[HTShareClass shareClass].printerModel.returnGoodsList addObject:printDic];
    }];
    
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
        [[HTShareClass shareClass].printerModel.exchangeGoodsList addObject:printDic];
    }];
    [HTShareClass shareClass].printerModel.returnGuider = [HTShareClass shareClass].loginModel.person.name;
    [HTShareClass shareClass].printerModel.returnOrderNo = self.orderModel.ordernum;
    [HTShareClass shareClass].printerModel.returnOrderId = self.orderModel.orderId;
    [HTShareClass shareClass].printerModel.orderDesc = self.descString;
    [self.printerManager print];
}
-(void)holdCancelOrCloseWithOrderState:(NSString *)state{
    
 
}
-(void)configAlipayIsEnabel:(BOOL) enabel{
    if (enabel) {
        self.aliPayBt.hidden = NO;
        self.aliPayImg.hidden = NO;
        self.aliPayLabel.hidden = NO;
    }else{
        self.aliPayBt.hidden = YES;
        self.aliPayImg.hidden = YES;
        self.aliPayLabel.hidden = YES;
    }
}
-(void)configWechatpayIsEnabel:(BOOL) enabel{
    if (enabel) {
        self.wechatBt.hidden = NO;
        self.wechatImg.hidden = NO;
        self.wechatTitle.hidden = NO;
    }else{
        self.wechatTitle.hidden = YES;
        self.wechatImg.hidden = YES;
        self.wechatBt.hidden = YES;
    }
}
- (void)autoQueryStateRequest{
    NSDictionary *dic = @{
                          @"payCompany":@"",
                          };
    [self repalceRequest:dic andIsStore:NO eventBt:nil];
}
-(void)repalceRequest:(NSDictionary *)dicccc andIsStore:(BOOL) isStroe eventBt:(UIButton *)sender{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval endTime = [dat timeIntervalSince1970];
    
    if (((endTime - self.beginTime) / 60) > 28) {
        [MBProgressHUD showError:@"页面已过期，请重新操作"];
        [self.navigationController popViewControllerAnimated:YES];
        [self clearCache];
        return;
    }
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId],
                          @"wechatPayOrderId":[HTHoldNullObj getValueWithUnCheakValue:self.wechatPayOrderId],
                          @"timeoutJobId":[HTHoldNullObj getValueWithUnCheakValue:self.timeoutJobId],
                          };
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValuesForKeysWithDictionary:dicccc];
    [postDic setValuesForKeysWithDictionary:dic];
    sender.enabled = NO;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,exchangeReplaceProduct4App] params:postDic success:^(id json) {
        if (isStroe) {
            [self holdStoredPayResultWithJson:json andEventSender:sender];
        }else{
            [self holdPayResultWithJson:json andEventSender:sender];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
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
