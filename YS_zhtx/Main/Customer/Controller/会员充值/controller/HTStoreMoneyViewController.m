//
//  HTStoreMoneyViewController.m
//  24小助理
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//


#import "HTStoreMoneyViewController.h"
#import "HTStoredMoneyCollectionCell.h"
#import "HTStoredSendModel.h"
#import "HTAddStoredMoneyCollectionCell.h"
#import "HTStoredAlertView.h"
#import "PhoneNumberTools.h"
#import <MessageUI/MessageUI.h>
#import "HTCustModel.h"
#import "HTBillsViewController.h"
#import "HTHoldCustomerEventManger.h"
@interface HTStoreMoneyViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HTStoredAlertViewDelegate,MFMessageComposeViewControllerDelegate>
{

    BOOL isLoadVip;
    NSString *finallStroe;
}
@property (nonatomic,strong) HTCustModel *custModel;
@property (weak, nonatomic) IBOutlet UIButton *finshBt;

@property (weak, nonatomic) IBOutlet UILabel *desc1;
@property (weak, nonatomic) IBOutlet UILabel *desc2;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UIImageView *sexImg;

@property (strong,nonatomic) UIView *tapCoverView;

@property (weak, nonatomic) IBOutlet UICollectionView *mycollectionView;

@property (nonatomic,strong) HTStoredAlertView *storedAlert;

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UIImageView *yanzhengImg;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIView *writejifenBackView;
@property (weak, nonatomic) IBOutlet UIButton *sendStoreBt;


@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *storedLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendByStoredLabel;


@property (nonatomic,strong) NSMutableDictionary *requstDic;

@property (nonatomic,assign) NSInteger selectedTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btBottomHeight;

@property (nonatomic,strong) NSArray *payArr;

@end

@implementation HTStoreMoneyViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self storedSelected:nil];
    self.selectedTag = 200;
    [self createVipView];
    isLoadVip = NO;
    [self loadAuth];
    [self loadStoredList];
}
#pragma mark -EventResponse


- (IBAction)finshBtClicked:(id)sender {

    HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"是否确认%@",self.handType == HAND_TYPE_DEDUED ? @"扣除" : @"充值"] btsArray:@[@"取消",@"确认"] okBtclicked:^{
                    if (self.handType == HAND_TYPE_STORED ) {
                        NSMutableArray *titles = [NSMutableArray array];
                        for (int i = 0; i < self.payArr.count; i++) {
                            NSDictionary *dic = self.payArr[i];
                            [titles addObject:[dic getStringWithKey:@"name"]];
                        }
                        if (self.selectedTag == 200) {
                            HTStoredSendModel *selectedModel = [[HTStoredSendModel alloc] init];
                            BOOL isselect = NO;
                            for (HTStoredSendModel *model in self.dataArray) {
                                if (model.isSelected) {
                                    selectedModel = model;
                                    isselect = YES;
                                    break;
                                }
                            }
                            if (!isselect) {
                                [MBProgressHUD showError:@"请选择充值条件" toView:self.view];
                                return;
                            }
                            [self.requstDic setObject:[HTHoldNullObj getValueWithUnCheakValue:selectedModel.send] forKey:@"send"];
                            [self.requstDic setObject:[HTHoldNullObj getValueWithUnCheakValue:selectedModel.money] forKey:@"amount"];
                            
                            [LPActionSheet showActionSheetWithTitle:@"请选择支付方式" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles handler:^(LPActionSheet *actionSheet, NSInteger index) {
                                if (index >= 1) {
                                    NSDictionary *dic = self.payArr[index - 1];
                                    [self.requstDic setObject:[dic getStringWithKey:@"id"] forKey:@"rechargeSource"];
                                    [self LoadHandingMoney];
                                }
                            }];
                        }
                        if (self.selectedTag == 202) {
                            if (([self.moneyTextField.text length] == 0 || self.moneyTextField.text.intValue == 0) && !self.moneyTextField.hidden) {
                                [MBProgressHUD showError:@"请输入金额" toView:self.view];
                                return;
                            }
                            if ([self.moneyTextField.text intValue] < 0) {
                                [MBProgressHUD showError:@"金额不能为负数"];
                                return;
                            }
                            [self.requstDic setObject:self.moneyTextField.text forKey:@"amount"];
//                            [LPActionSheet showActionSheetWithTitle:@"请选择支付方式" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles handler:^(LPActionSheet *actionSheet, NSInteger index) {
//                                if (index >= 1) {
//                                    NSDictionary *dic = self.payArr[index - 1];
//                                    [self.requstDic setObject:[dic getStringWithKey:@"id"] forKey:@"rechargeSource"];
//                                }
                             [self LoadHandingMoney];
//                            }];
                        }
                    }
                    if (self.handType == HAND_TYPE_DEDUED) {
                        if (([self.moneyTextField.text length] == 0 || self.moneyTextField.text.intValue == 0) && !self.moneyTextField.hidden) {
                            [MBProgressHUD showError:@"请输入金额" toView:self.view];
                            return;
                        }
                        if ([self.moneyTextField.text intValue] < 0) {
                            [MBProgressHUD showError:@"金额不能为负数"];
                            return;
                        }
                        [self.requstDic setObject:self.moneyTextField.text forKey:@"amount"];
                        [self LoadHandingMoney];
                    }
    } cancelClicked:^{
    }];
    [alert show];
}
- (IBAction)storedSelected:(id)sender {
    
    UIImageView *image = [self.view viewWithTag:200];
    image.image = [UIImage imageNamed:@"store_选中图标"];
    
    UIImageView *image1 = [self.view viewWithTag:202];
    image1.image = [UIImage imageNamed:@"store_未选择图标"];
    if (self.sendStoreBt.enabled) {
        UIImageView *image2 = [self.view viewWithTag:201];
        image2.image = [UIImage imageNamed: self.handType == HAND_TYPE_STORED ?@"store_不可选择图标": @"store_未选择图标"];
    }
    self.selectedTag = 200;
    if (self.handType == HAND_TYPE_STORED) {
        self.writejifenBackView.hidden = YES;
        self.mycollectionView.hidden = NO;
    }else{
         self.moneyTextField.placeholder = @"请输入扣除储值面额";
    }
     [self.requstDic setObject:@"1" forKey:@"accountType"];
}

- (IBAction)jifenSelected:(id)sender {
    
    UIImageView *image = [self.view viewWithTag:202];
    image.image = [UIImage imageNamed:@"store_选中图标"];
    UIImageView *image1 = [self.view viewWithTag:200];
    image1.image = [UIImage imageNamed:@"store_未选择图标"];
     if (self.sendStoreBt.enabled) {
    UIImageView *image2 = [self.view viewWithTag:201];
    image2.image = [UIImage imageNamed: self.handType == HAND_TYPE_STORED ?@"store_不可选择图标": @"store_未选择图标"];
     }
    self.selectedTag = 202;
    if (self.handType == HAND_TYPE_STORED) {
        self.writejifenBackView.hidden = NO;
        self.mycollectionView.hidden = YES;
        self.moneyTextField.placeholder = @"请输入充值积分面额";
    }else{
        self.moneyTextField.placeholder = @"请输入扣除积分面额";
    }
    [self.requstDic setObject:@"2" forKey:@"accountType"];
}
- (IBAction)sendStoredBt:(id)sender {
    
    UIImageView *image = [self.view viewWithTag:202];
    image.image = [UIImage imageNamed:@"store_未选择图标"];
    
    UIImageView *image1 = [self.view viewWithTag:200];
    image1.image = [UIImage imageNamed:@"store_未选择图标"];
    
    UIImageView *image2 = [self.view viewWithTag:201];
    image2.image = [UIImage imageNamed: self.handType == HAND_TYPE_STORED ?@"store_不可选择图标": @"store_选中图标"];
    self.moneyTextField.placeholder = @"请输入扣除储值赠送面额";
    self.selectedTag = 202;
    [self.requstDic setObject:@"3" forKey:@"accountType"];
}
- (void)tapCover{
    [self.storedAlert removeFromSuperview];
    [self.tapCoverView removeFromSuperview];
}
-(void)rightBtClicked{
    [HTHoldCustomerEventManger lookCustomerBillListWithCustomerId:[HTHoldNullObj getValueWithUnCheakValue:self.custModel.custId] andCustModel:self.custModel];
}
#pragma mark -private methods
- (void)createVipInfoWith:(HTCustModel *)custModel{
//    HTDataCustBasetInfo *model1 = custModel.custInfo;
    if (custModel.nickname.length == 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",@"暂无"];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@",custModel.nickname];
    }
    self.levelLabel.text = [NSString stringWithFormat:@"%@" ,custModel.custlevel ? custModel.custlevel : @"无"];

    self.jifenLabel.text = !custModel.account.integral.balance ? @"0":[NSString stringWithFormat:@"%@",custModel.account.integral.balance];
    self.storedLabel.text = !custModel.account.stored.balance ? @"0":[NSString stringWithFormat:@"%@",custModel.account.stored.balance];
    self.sendByStoredLabel.text = !custModel.account.storedPresented.balance ? @"0":[NSString stringWithFormat:@"%@",custModel.account.storedPresented.balance];
    if (![[HTHoldNullObj getValueWithUnCheakValue:custModel.isfreestorevalueaccountactive] isEqualToString:@"1"]) {
        self.sendStoreBt.enabled = NO;
        UIImageView *imageView = [self.view viewWithTag:201];
        imageView.image = [UIImage imageNamed:@"store_不可选择图标"];
        self.sendByStoredLabel.text = @"未启用";
    }
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:custModel.headImg] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    [self.headImg changeCornerRadiusWithRadius:self.headImg.height / 2];
    NSString *sex = [HTHoldNullObj getValueWithUnCheakValue:custModel.sex].length == 0 ? @"g-woman" :[[HTHoldNullObj getValueWithUnCheakValue:custModel.sex] isEqualToString:@"0"] ? @"g-woman" : @"g-man";
    self.sexImg.image = [UIImage imageNamed:sex];
    self.phoneNum.text = [HTHoldNullObj getValueWithUnCheakValue:self.phoneNumber];
}


- (void)setDelegate{
    
   
    _moneyTextField.delegate = self;
    _moneyTextField.enabled  = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction:)name:UITextFieldTextDidChangeNotification object:self.moneyTextField];
}
- (void)loadStoredList{
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadRechargeRule4app] params:dic success:^(id json) {
        for (NSDictionary *dic in json[@"data"]) {
            HTStoredSendModel *model = [[HTStoredSendModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        HTStoredSendModel *model = [[HTStoredSendModel alloc] init];
        model.islast = YES;
        [self.dataArray addObject:model];
        self.payArr = [json getArrayWithKey:@"rechargeSrc"];
        [self.mycollectionView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}
-(void)createVipView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(( HMSCREENWIDTH -45)  / 2 ,72 );
    layout.minimumInteritemSpacing = 15 ;
    layout.minimumLineSpacing = 15 ;
    //    设置collectionView的frame
    self.mycollectionView.collectionViewLayout = layout;
    //    self.mycollectionView.backgroundColor = self.view.backgroundColor = RGB(0.96, 0.96, 0.98, 1);
    //    设置代理
    self.mycollectionView.delegate   = self;
    self.mycollectionView.dataSource = self;
    self.mycollectionView.backgroundColor = [UIColor clearColor];
    [self.mycollectionView registerNib:[UINib nibWithNibName:@"HTStoredMoneyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTStoredMoneyCollectionCell"];
    
    [self.mycollectionView registerNib:[UINib nibWithNibName:@"HTAddStoredMoneyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTAddStoredMoneyCollectionCell"];
    self.btBottomHeight.constant = SafeAreaBottomHeight + 16;
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"账单详情" target:self action:@selector(rightBtClicked)];
}


/**
 *  请求权限
 */
- (void) loadAuth{
    [MBProgressHUD showMessage:@""];
    NSString *moduleId = [HTHoldNullObj getValueWithUnCheakValue:self.moduleId];

    __weak typeof(self ) weakSelf = self;

    NSString *url = [NSString stringWithFormat:@"%@%@%@",baseUrl,middleModel,loadModuleAuth];

    NSDictionary *dict =@{
                          @"moduleId":moduleId

                          };
    [HTHttpTools POST:url params:dict success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL auth ;
        switch (strongSelf.handType) {

            case HAND_TYPE_DEDUED:
            {
                auth = [json[@"data"][@"moduleAuthorityRule"][@"deduct"] boolValue];
            }
                break;
            case HAND_TYPE_STORED:
            {
                auth = [json[@"data"][@"moduleAuthorityRule"][@"topUp"] boolValue];
            }
                break;
            default:
                break;
        }
        if (auth) {
            [self setDelegate];
            [self createUI];
            strongSelf.view.backgroundColor = RGB(0.96, 0.96, 0.98, 1);
            if (strongSelf.phoneNumber) {
                strongSelf.moneyTextField.enabled = YES;
                [strongSelf loadVipMsgWithPhone:strongSelf.phoneNumber withError:^{
                }];
            }
        }else{
            [MBProgressHUD showError:@"权限不足,无法进行此操作"];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    } error:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求数据失败，网络繁忙"];
        [strongSelf.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
        [strongSelf.navigationController popViewControllerAnimated:YES];

    }];
}
- (void)infoAction:(NSNotification *) obj{
    
    UITextField *text = obj.object;
    if (text.text.length == 0) {
        return;
    }
    if (text == self.moneyTextField) {
        NSString *moneyText = self.moneyTextField.text;
        NSString *regex = @"^[0-9]$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([predicate evaluateWithObject:moneyText]) {
            
        }else{
            if (abs([moneyText intValue]) != 0) {
                self.moneyTextField.text = [NSString stringWithFormat:@"%d",abs([moneyText intValue])] ;
            }else{
                self.moneyTextField.text = nil;
            }
        }
    }
    
}
- (void)createUI{
    switch (self.handType) {
        case HAND_TYPE_STORED:
        {
            self.title = @"账户充值";
            self.writejifenBackView.hidden = YES;
            self.mycollectionView.hidden = NO;
            self.sendStoreBt.enabled = NO;
            UIImageView *imageView = [self.view viewWithTag:201];
            imageView.image = [UIImage imageNamed:@"store_不可选择图标"];
            [self.finshBt setTitle:@"确认充值" forState:UIControlStateNormal];
            self.desc1.hidden = NO;
            self.desc2.hidden = NO;
            [self.finshBt changeCornerRadiusWithRadius:3];
             
        }
            break;
        case HAND_TYPE_DEDUED:
        {
            self.title = @"账户扣除";
            self.writejifenBackView.hidden = NO;
            self.mycollectionView.hidden = YES;
            self.sendStoreBt.enabled = YES;
            UIImageView *imageView = [self.view viewWithTag:201];
            imageView.image = [UIImage imageNamed:@"store_未选择图标"];
            self.moneyTextField.placeholder = @"请输入扣除储值面额";
            [self.finshBt setTitle:@"确认扣除" forState:UIControlStateNormal];
            [self.finshBt changeCornerRadiusWithRadius:3];
            self.desc1.hidden = YES;
            self.desc2.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}
- (void)loadVipMsgWithPhone:(NSString *) phone withError:(nullable void (^)(void))failure{
    
    [MBProgressHUD showMessage:@""];
    self.moneyTextField.enabled = YES;
    NSDictionary *dic = @{
                          @"phone":[HTHoldNullObj getValueWithUnCheakValue:self.phoneNumber],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,laodCust4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        self.custModel = [HTCustModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self createVipInfoWith:self.custModel];
        [self.requstDic setObject:self.custModel.custId forKey:@"customerId"];
    }  error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

//请求充值或扣除
- (void)LoadHandingMoney{
//
    int finall = 0;
    HTAccoutInfoModel *account  = [[HTAccoutInfoModel alloc] init];
   
        if ([[self.requstDic getStringWithKey:@"accountType"] isEqualToString:@"1"]) {
            account = self.custModel.account.stored;
        }
        if ([[self.requstDic getStringWithKey:@"accountType"] isEqualToString:@"2"]) {
            account = self.custModel.account.integral;
        }
        if ([[self.requstDic getStringWithKey:@"accountType"] isEqualToString:@"3"]) {
            account = self.custModel.account.storedPresented;
        }
    if (self.handType == HAND_TYPE_STORED) {
        finall = account.balance.intValue +  _moneyTextField.text.intValue;
    }
    if (self.handType == HAND_TYPE_DEDUED) {
         finall = account.balance.intValue -  _moneyTextField.text.intValue;
        if ([account.balance intValue] < _moneyTextField.text.intValue) {
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@余额小于你要扣除的金额",account.name] btTitle:@"确定" okBtclicked:^{
            }];
            [alert show];
            return;
        }
    }
    finallStroe = [NSString stringWithFormat:@"%d",finall];
    [MBProgressHUD showMessage:@""];
    NSString *changUrl = [NSString string];
    switch (_handType) {
        case HAND_TYPE_STORED:
        {
            changUrl = topUpMoney4App;
        }
            break;
        case HAND_TYPE_DEDUED:{
            changUrl = deductMoney4App;
        }
            break;
            
        default:
            break;
    }
    [self.requstDic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,changUrl] params:self.requstDic success:^(id json) {
        [MBProgressHUD hideHUD];
        self->isLoadVip = NO;
        if ([json[@"data"][@"state"] intValue] == 1) {
            //返回短信类容
            if ([[json[@"data"] getStringWithKey:@"sms"] length ] > 0) {
                __weak typeof(self) weakSelf = self;
                HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@成功",self.handType == HAND_TYPE_STORED ? @"充值":@"扣除"] btTitle:@"确定" okBtclicked:^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf sendMessegeWithPhone:self.phoneNumber andMsg:[NSString stringWithFormat:@"%@%@",[json[@"data"] getStringWithKey:@"sms"],self->finallStroe]];
                }];
                [alert show];

            }else{
                HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@成功",self.handType == HAND_TYPE_STORED ? @"充值":@"扣除"] btTitle:@"确定" okBtclicked:^{
                }];
                [alert show];
            }
            self.storedAlert = nil;
            self.moneyTextField.text = nil;
            self.requstDic = nil;
            [self storedSelected:nil];
            for (HTStoredSendModel *model in self.dataArray) {
                model.isSelected = NO;
            }
            [self.mycollectionView reloadData];
            [self loadVipMsgWithPhone:self.phoneNumber withError:^{
            }];
        }else{
            HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@失败",self.handType == HAND_TYPE_STORED ? @"充值":@"扣除"] btTitle:@"确定" okBtclicked:^{
            }];
            [alert show];
        }
    } error:^{
        self->isLoadVip = NO;
        [MBProgressHUD hideHUD];
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"网络繁忙，%@失败",self.handType == HAND_TYPE_STORED ? @"充值":@"扣除"] btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
        
    } failure:^(NSError *error) {
        self->isLoadVip = NO;
        [MBProgressHUD hideHUD];
        HTCustomDefualAlertView *alert = [[HTCustomDefualAlertView alloc] initAlertWithTitle:[NSString stringWithFormat:@"%@失败，请检查你的网络",self.handType == HAND_TYPE_STORED ? @"充值":@"扣除"] btTitle:@"确定" okBtclicked:^{
        }];
        [alert show];
    }];
}
#pragma mark -CustomDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;

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

        [self dismissViewControllerAnimated:YES completion:nil];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - MFMessageComposeViewController 回调

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{

    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功


            break;
        case MessageComposeResultFailed:
            //信息传送失败


            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送


            break;
        default:
            break;
    }
}
-(void)cancelStored{
    [self tapCover];
}
- (void)storedMoney:(NSString *)amount withSend:(NSString *)send{
    [self.requstDic setObject:[HTHoldNullObj getValueWithUnCheakValue:amount] forKey:@"amount"];
    [self.requstDic setObject:[HTHoldNullObj getValueWithUnCheakValue:send] forKey:@"send"];
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < self.payArr.count; i++) {
        NSDictionary *dic = self.payArr[i];
        [titles addObject:[dic getStringWithKey:@"name"]];
    }
    [LPActionSheet showActionSheetWithTitle:@"请选择支付方式" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:titles handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index >= 1) {
            NSDictionary *dic = self.payArr[index - 1];
            [self.requstDic setObject:[dic getStringWithKey:@"id"] forKey:@"rechargeSource"];
            [self LoadHandingMoney];
        }
    }];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTStoredSendModel *model = self.dataArray[indexPath.row];
    if (!model.islast) {
        HTStoredMoneyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTStoredMoneyCollectionCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.model = self.dataArray[indexPath.row];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        if (model.isSelected) {
            cell.layer.borderColor = [UIColor colorWithHexString:@"#6A82FB"].CGColor;
            cell.layer.borderWidth = 1.3;
        }else{
            cell.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
            cell.layer.borderWidth = 0.0;
        }
        return cell;
    }else{
        HTAddStoredMoneyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTAddStoredMoneyCollectionCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (HTStoredSendModel *model in self.dataArray) {
        model.isSelected = NO;
    }
     HTStoredSendModel *model = self.dataArray[indexPath.row];
    if (!model.islast) {
        model.isSelected = YES;
        [self.mycollectionView reloadData];
    }else{
     
        [self.mycollectionView reloadData];
        [self.view addSubview:self.tapCoverView];
        self.storedAlert.dataArray = self.dataArray;
        [self.view addSubview:self.storedAlert];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.moneyTextField  ];
}
#pragma mark - getters and setters


- (NSMutableDictionary *)requstDic
{
    if (!_requstDic) {
        _requstDic = [NSMutableDictionary dictionary];
    }
    return _requstDic;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(HTStoredAlertView *)storedAlert{
    if (!_storedAlert) {
        _storedAlert = [[HTStoredAlertView alloc] initAlertWithFrame:CGRectMake((HMSCREENWIDTH - 328)/ 2, 70, 328, 300)];
        _storedAlert.layer.cornerRadius = 5;
        _tapCoverView.layer.masksToBounds = YES;
        _storedAlert.delegate = self;
    }
    return _storedAlert;
}
- (UIView *)tapCoverView{
    if (!_tapCoverView) {
        _tapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, HEIGHT)];
        _tapCoverView.backgroundColor = [UIColor colorWithHexString:@"222222"];
        _tapCoverView.alpha = 0.5;
        _tapCoverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover)];
        [_tapCoverView addGestureRecognizer:tap];
    }
    return _tapCoverView;
}
-(NSArray *)payArr{
    if (!_payArr) {
        _payArr = [NSArray array];
    }
    return _payArr;
}
@end
