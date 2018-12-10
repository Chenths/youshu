//
//  HTFeedbackController.m
//  24小助理
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTFeedbackController.h"

@interface HTFeedbackController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *themeTextFied;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;
@end

@implementation HTFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}
- (void)createUI{
    
    self.view.backgroundColor = RGB(0.94, 0.94, 0.94, 1);
    self.themeTextFied.delegate = self;
    self.descTextView.delegate  = self;
}
- (IBAction)setFeedBackClicked:(id)sender {
    if (self.themeTextFied.text.length == 0 ) {
        [MBProgressHUD showError:@"请输入问题概述"];
        return;
    }
    if (self.themeTextFied.text.length == 0) {
        [MBProgressHUD showError:@"请输入问题详细描述"];
        return;
    }
    NSDictionary *dic = @{
                          @"content":[HTHoldNullObj getValueWithUnCheakValue:self.descTextView.text],
                          @"title" : [HTHoldNullObj getValueWithUnCheakValue:self.themeTextFied.text],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"type" : @"0"
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFeedback,saveFeedback] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"data"][@"state"] intValue] == 1) {
            [MBProgressHUD showSuccess:@"问题反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"问题反馈失败"];
        }
        
    } error:^{
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.holderLabel.hidden = YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.descTextView.text.length == 0) {
        self.holderLabel.hidden = NO;
    }
}
@end
