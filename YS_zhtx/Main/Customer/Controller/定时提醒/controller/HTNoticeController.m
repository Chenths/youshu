//
//  HTNoticeController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HcdDateTimePickerView.h"
#import "HTNoticeController.h"

@interface HTNoticeController ()<UITextFieldDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *dateTextField;

@property (weak, nonatomic) IBOutlet UITextField *themeTextFied;

@property (weak, nonatomic) IBOutlet UIButton *saveBt;

@property (weak, nonatomic) IBOutlet UITextView *desTextView;

@property (weak, nonatomic) IBOutlet UILabel *holderLabel;

@property (nonatomic,strong) NSString *dateStr;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btBottomHeight;


@end

@implementation HTNoticeController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
//    self.view.backgroundColor = RGB(0.94, 0.94, 0.94, 1);
    self.dateTextField.delegate = self;
    self.themeTextFied.delegate = self;
    self.desTextView.delegate  = self;
    [self.dateTextField setValue:[UIColor colorWithHexString:@"#C4C6CB"] forKeyPath:@"placeholderLabel.textColor"];
    [self.themeTextFied setValue:[UIColor colorWithHexString:@"#C4C6CB"] forKeyPath:@"placeholderLabel.textColor"];
    
    [self.saveBt changeCornerRadiusWithRadius:3];
    self.btBottomHeight.constant = SafeAreaBottomHeight + 16;
}
- (IBAction)setNoticeClicked:(id)sender {
    
    if (self.dateTextField.text.length == 0 ) {
        [MBProgressHUD showError:@"请选择提醒时间"];
        return;
    }
    if (self.themeTextFied.text.length == 0) {
        [MBProgressHUD showError:@"请输入提醒主题"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSDictionary *requsetDic = @{
                                 @"modelId": [HTHoldNullObj getValueWithUnCheakValue:self.modelId],
                                 @"moduleId" :[HTHoldNullObj getValueWithUnCheakValue:self.moduleId],
                                 @"start_at" : self.dateTextField.text,
                                 @"title" : self.themeTextFied.text,
                                 @"desc" :[HTHoldNullObj getValueWithUnCheakValue:self.desTextView.text],
                                 };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,AddUserNotice] params:requsetDic success:^(id json)
     {
         [MBProgressHUD hideHUD];
         if ([json[@"data"][@"state"] integerValue] == 1) {
             [MBProgressHUD showSuccess:@"设置提醒成功"];
             self.dateTextField.text = nil;
             self.themeTextFied.text = nil;
             self.desTextView.text = nil;
         }else{
             [MBProgressHUD showError:@"设置定时提醒失败"];
         }
     } error:^{
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:SeverERRORSTRING];
         
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:NETERRORSTRING];
     }];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.holderLabel.hidden = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.dateTextField) {
        HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateTimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] WithIsBeteewn:NO];
        dateTimePickerView.topViewColor = [UIColor colorWithHexString:@"F8F8F8"];
        __weak typeof(self) weakSelf = self;
        dateTimePickerView.clickedOkBtn = ^(NSString *dateTimeStr) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.dateTextField.text = dateTimeStr;
            strongSelf.dateStr = dateTimeStr;
        };
        
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.desTextView.text.length == 0) {
        self.holderLabel.hidden = NO;
    }
}
@end
