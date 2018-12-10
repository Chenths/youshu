//
//  HTChangeProductHomeViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTScanTools.h"
#import "PhoneNumberTools.h"
#import "HTChangeOrderProductController.h"
#import "HTChangeProductHomeViewController.h"

#import "HTCustomerOrderListController.h"
#import "HTChangeOrderProductController.h"

@interface HTChangeProductHomeViewController ()<HTScanCodeDelegate>
@property (weak, nonatomic) IBOutlet UIView *textBack1;
@property (weak, nonatomic) IBOutlet UIView *textBack2;
@property (weak, nonatomic) IBOutlet UIButton *searchBt1;
@property (weak, nonatomic) IBOutlet UIButton *searchBt2;
@property (weak, nonatomic) IBOutlet UITextField *orderText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (nonatomic,strong) HTScanTools *scanTool;
@end

@implementation HTChangeProductHomeViewController
#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneText.autocorrectionType = UITextAutocorrectionTypeNo;
    [self createSub];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#if defined (__i386__) || defined (__x86_64__)
    //模拟器下执行
#else
    [self.scanTool.session startRunning];
    //真机下执行
#endif
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scanTool.session stopRunning];
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate
-(void)handleScanResultStr:(NSString *)result{
    
}
#pragma mark -EventResponse
-(void)phoneClicked:(UIButton *)sender{
    if ([PhoneNumberTools isMobileNumber:self.phoneText.text]) {
        [self loadDataWithType:@"1" andPhoneOrOder:self.phoneText.text];
    }else{
        [MBProgressHUD showError:@"请输入正确的电话号码"];
    }
}
-(void)orderClicked:(UIButton *)sender{
    if (self.orderText.text.length > 0) {
        [self loadDataWithType:@"2" andPhoneOrOder:self.orderText.text];
    }
}
#pragma mark -private methods
- (void)loadDataWithType:(NSString *) type andPhoneOrOder:(NSString *) param{
    [MBProgressHUD showMessage:@""];
    NSDictionary *dict = @{
                           @"companyId":[HTShareClass shareClass].loginModel.companyId,
                           @"param": param,
                           @"type" : type,
                           };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleOrder,queryOrderOrCus] params:dict success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([type isEqualToString:@"1"]) {
            NSDictionary *dic = [json getDictionArrayWithKey:@"data"];
            if ([[dic getStringWithKey:@"moduleId"] isNull]) {
                [MBProgressHUD showError:@"相关信息错误，请重新输入相关信息"];
                return ;
            }
            HTCustomerOrderListController *vc = [[HTCustomerOrderListController alloc] init];
            vc.custId = [dic getStringWithKey:@"parentModelId"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"2"]){
            NSDictionary *dic = [json getDictionArrayWithKey:@"data"];
            if ([[dic getStringWithKey:@"modelId"] isNull]) {
                [MBProgressHUD showError:@"相关信息错误，请重新输入相关信息"];
                return ;
            }
            HTChangeOrderProductController *vc = [[HTChangeOrderProductController alloc] init];
            vc.orderId = [dic getStringWithKey:@"modelId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)createSub{
    [self.textBack1 changeCornerRadiusWithRadius:3];
    [self.textBack2 changeCornerRadiusWithRadius:3];
    [self.searchBt1 changeCornerRadiusWithRadius:3];
    [self.searchBt2 changeCornerRadiusWithRadius:3];
    [self scanTool];
    [self.searchBt1 addTarget:self action:@selector(phoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBt2 addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - getters and setters
-(HTScanTools *)scanTool{
    if (!_scanTool ) {
        _scanTool = [[HTScanTools alloc] init];
        _scanTool.frame = CGRectMake(0, 0, HMSCREENWIDTH, 240);
        _scanTool.delegate = self;
        [_scanTool startScanInView:self.view];
        
    }
    return _scanTool;
}

@end
