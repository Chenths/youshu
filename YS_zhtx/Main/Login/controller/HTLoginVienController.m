//
//  HTLoginVienController.m
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "Account.h"
#import "HTAccountTool.h"
#import "YJJTextField.h"
#import "HTLoginVienController.h"
#import "MainTabBarViewController.h"
#import "IQKeyboardManager.h"
#import "HTCustomTextAlertView.h"
@interface HTLoginVienController ()<UITextFieldDelegate>
{
   
    YJJTextField *shopNameField;
    YJJTextField *userNameField;
    YJJTextField *passwordField;
}

@property (weak, nonatomic) IBOutlet UIView *loginBackView;

@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UIImageView *longinImv;



@end

@implementation HTLoginVienController




#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.backImg = @"";
    //添加更换baseURL宏的地方
#ifdef DEBUG
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImvAction)];
        [self.longinImv addGestureRecognizer:tapGesturRecognizer];
#else
#endif
}

- (void)tapImvAction{
    NSString *tmp;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"]) {
        tmp = [[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"];
    }else{
        tmp = @"http://192.168.199.33:8080/";
    }
    [HTCustomTextAlertView showAlertWithTitle:@"输入服务器地址" holdTitle:@"" orTextString:tmp okBtclicked:^(NSString * textValue) {
        if (![textValue isEqualToString:@""]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:textValue forKey:@"baseUrl"];
        }
    } andCancleBtClicked:^{
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)simulateBtClicked:(id)sender {
    Account *acount = [[Account alloc] init];
    acount.userName = @"8001";
    acount.passWord = @"8001";
    acount.shopNumber = @"csdpsccd";
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"正在登录"];
    [HTAccountTool loginDoSomeThing:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf saveShopName];
        [HTAccountTool createViewControllerWithjson:json];
    } WithAccount:acount];
    
}
- (IBAction)loginBtClicked:(id)sender {
    [self.view endEditing:YES];
    BOOL isNotOk = NO;
    if (shopNameField.textField.text.length == 0) {
        [shopNameField showError];
        isNotOk = YES;
    }
    if (passwordField.textField.text.length == 0) {
        [passwordField showError];
        isNotOk = YES;
    }
    if (userNameField.textField.text.length == 0 ) {
        [userNameField showError];
        isNotOk = YES;
    }
    if (isNotOk) {
        [MBProgressHUD showError:@"请输入正确的登录信息"];
        return;
    }else{
        Account *acount = [[Account alloc] init];
        acount.userName = userNameField.textField.text;
        acount.passWord = passwordField.textField.text;
        acount.shopNumber = shopNameField.textField.text;
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showMessage:@"正在登录"];
        [HTAccountTool loginDoSomeThing:^(id json) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf saveShopName];
            [HTAccountTool createViewControllerWithjson:json];
        } WithAccount:acount];
    }
}

#pragma mark -private methods
-(void)initSubviews{
    [self.loginBt changeCornerRadiusWithRadius:3];
    shopNameField = [YJJTextField yjj_textField];
    shopNameField.frame = CGRectMake(0, 0, self.loginBackView.width, 80);
    shopNameField.maxLength = 100;
    shopNameField.errorStr = @"未输入店铺名";
    shopNameField.placeholder = @"店铺";
    shopNameField.placeHolderLabelColor = [UIColor colorWithHexString:@"#999999"];
    shopNameField.placeHolderColor = [UIColor colorWithHexString:@"#999999"];
    shopNameField.lineWarningColor = [UIColor colorWithHexString:@"#F53434"];
    shopNameField.lineDefaultColor = [UIColor colorWithHexString:@"#F1F1F1"];
    shopNameField.lineSelectedColor = [UIColor colorWithHexString:@"#222222"];
    shopNameField.historyContentKey = @"shopName";
    shopNameField.showHistoryList = YES;
    shopNameField.textField.returnKeyType = UIReturnKeyNext;
    shopNameField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    shopNameField.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.loginBackView addSubview:shopNameField];
    
    userNameField = [YJJTextField yjj_textField];
    userNameField.frame = CGRectMake(0, 85, self.loginBackView.width, 80);
    userNameField.maxLength = 100;
    userNameField.errorStr = @"未输入账号";
    userNameField.placeholder = @"账号";
    userNameField.placeHolderLabelColor = [UIColor colorWithHexString:@"#999999"];
    userNameField.placeHolderColor = [UIColor colorWithHexString:@"#999999"];
    userNameField.lineWarningColor = [UIColor colorWithHexString:@"#F53434"];
    userNameField.lineDefaultColor = [UIColor colorWithHexString:@"#F1F1F1"];
    userNameField.lineSelectedColor = [UIColor colorWithHexString:@"#222222"];
    userNameField.textField.returnKeyType = UIReturnKeyNext;
    userNameField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameField.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    userNameField.showHistoryList = NO;
    [self.loginBackView addSubview:userNameField];
    
    passwordField = [YJJTextField yjj_textField];
    passwordField.frame = CGRectMake(0, 170, self.loginBackView.width, 80);
    passwordField.maxLength = 100;
    passwordField.errorStr = @"未输入密码";
    passwordField.placeholder = @"密码";
    passwordField.placeHolderLabelColor = [UIColor colorWithHexString:@"#999999"];
    passwordField.placeHolderColor = [UIColor colorWithHexString:@"#999999"];
    passwordField.lineWarningColor = [UIColor colorWithHexString:@"#F53434"];
    passwordField.lineDefaultColor = [UIColor colorWithHexString:@"#F1F1F1"];
    passwordField.lineSelectedColor = [UIColor colorWithHexString:@"#222222"];
    passwordField.showHistoryList = NO;
    passwordField.textField.returnKeyType = UIReturnKeyDone;
    passwordField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.textField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordField.textField.secureTextEntry = YES;
    [self.loginBackView addSubview:passwordField];
    __weak typeof(userNameField) weakU = userNameField;
    shopNameField.nextCliked = ^{
        __strong typeof(weakU) strongU = weakU;
        [strongU.textField becomeFirstResponder];
    };
    __weak typeof(passwordField) weakP = passwordField;
    userNameField.nextCliked = ^{
        __strong typeof(weakP) strongP = weakP;
        [strongP.textField becomeFirstResponder];
    };
}
-(void)saveShopName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *originalDic = [defaults objectForKey:@"historyContent"];
    if (originalDic == nil) {  // 如果系统中没有记录
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            // 用数组存放输入的内容，并作为保存字典的Value，Key为用户在创建时自己指定
        NSArray *array = [NSArray arrayWithObject:shopNameField.textField.text];
        [dic setObject:array forKey:shopNameField.historyContentKey];
        [defaults setObject:dic forKey:@"historyContent"];
    }else{
        __block NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
            // 遍历所有TextField，取出当前文本框的Key和内容
            NSString *currentKey = shopNameField.historyContentKey;
            NSString *currentText = shopNameField.textField.text;
            __block NSMutableArray *contentArray;
            // 遍历已经存在的记录
            [originalDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
                contentArray = [NSMutableArray arrayWithArray:obj];
                if ([key isEqualToString:currentKey]) {  // 如果当前Key和字典中的Key相同，则添加Value
                    [contentArray addObject:currentText];
                    // 去除重复的记录
                    NSSet *set = [NSSet setWithArray:contentArray];
                    contentArray = (NSMutableArray *)set.allObjects;
                    NSMutableArray *arr = [NSMutableArray array];
                    for (int i = ((int)contentArray.count - 1); i >=0 ; i--) {
                        [arr addObject:contentArray[i]];
                    }
                    [newDic setObject:arr forKey:currentKey];
                    *stop = YES;
                }
            }];
        [defaults setObject:newDic forKey:@"historyContent"];
    }
}
#pragma mark - getters and setters

@end
