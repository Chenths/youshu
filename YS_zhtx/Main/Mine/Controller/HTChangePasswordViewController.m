//
//  HTChangePasswordViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "NSString+md5.h"
#import "HTAccountTool.h"
#import "HTChangePasswordViewController.h"

@interface HTChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;

@property (weak, nonatomic) IBOutlet UITextField *repetPassWord;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;


@end

@implementation HTChangePasswordViewController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)okBtClicked:(id)sender {
    //    取消键盘第一响应
    [self.passwordText resignFirstResponder];
    [self.oldPassWord resignFirstResponder];
    [self.repetPassWord resignFirstResponder];
    
    //    判断密码长度
    if (self.passwordText.text.length < 4 || self.passwordText.text.length > 20) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入长度为4到20的新密码"];
        return;
    }
    //    判断新密码是否一样
    if ([self.passwordText.text isEqualToString:self.repetPassWord.text]) {
        [self updataPassWord];
        //
    }else{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"前后两次密码不相同，请重新设置"];
        return;
    }
}
#pragma mark -private methods
- (void)updataPassWord{
    NSDictionary *dic = @{
                          @"newPassword":[self.passwordText.text md5],
                          @"oldPassword":[self.oldPassWord.text md5] ,
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middlePerson,changePassWordUrl] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:json[@"msg"]];
        if ([json[@"state"] integerValue] ) {
            [HTAccountTool exitLogin];
        }
    } error:^{
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙，修改密码失败"];
    }];
}
#pragma mark - getters and setters
@end
