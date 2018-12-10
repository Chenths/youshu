//
//  HTCommonViewController.m
//  YOUSHU_zhtx
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTJumpTools.h"
#import "HTCommonViewController.h"

@interface HTCommonViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HTCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:self.backImg.length > 0 ? self.backImg : @"g-back" highImageName:self.backImg.length > 0 ? self.backImg : @"g-back" target:self action:@selector(back)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if ([HTShareClass shareClass].jumpType.length > 0) {
        [HTJumpTools jumpWithStr:[HTShareClass shareClass].jumpType withDic:[HTShareClass shareClass].jumpDic];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
-(void)setBackImg:(NSString *)backImg{
    _backImg = backImg;
    if (backImg.length == 0) {
        self.navigationItem.leftBarButtonItem = nil;
        return;
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:self.backImg.length > 0 ? self.backImg : @"g-back" highImageName:self.backImg.length > 0 ? self.backImg : @"g-back" target:self action:@selector(back)];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadMenuAuthWithString:(NSString *)key Type:(NSString *)type HaveRoot:(HAVEROOT) root {
    NSDictionary *dic = @{
                          @"companyId" : [HTHoldNullObj getValueWithUnCheakValue: [HTShareClass shareClass].loginModel.loginId],
                          @"menuAuthTypes" : type
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleMenu,loadMenuAuth4App] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        NSString *ruleStr = [json[@"data"] getStringWithKey:@"rule"];
        if ([ruleStr containsString:key]) {
            root(YES);
        }else{
            [MBProgressHUD showError:@"没有访问权限"];
            root(NO);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
