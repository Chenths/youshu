//
//  HTTelMsgAlertView.m
//  有术
//
//  Created by mac on 2018/10/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "KLCPopup.h"
#import "HTTelMsgAlertView.h"

@interface HTTelMsgAlertView()

@property (weak, nonatomic) IBOutlet UILabel *custInfoLabel;

@property (weak, nonatomic) IBOutlet UITextField *msgTextField;

@property (weak, nonatomic) IBOutlet UIButton *msgBt;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

@property (weak, nonatomic) IBOutlet UIButton *okBt;

@property (weak, nonatomic) IBOutlet UIView *fielBack;

@property (nonatomic,copy) okBtClick  okBtClicked;

@property (nonatomic,strong) NSString *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgWidth;

@property (nonatomic,strong) NSString *telPhone;

@property (nonatomic,strong) NSString *strTime;
@property (nonatomic, strong) NSString *customerId;
@end

@implementation HTTelMsgAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.fielBack.layer.masksToBounds = YES;
    self.fielBack.layer.cornerRadius = 3;
    self.cancelBt.layer.masksToBounds = YES;
    self.cancelBt.layer.cornerRadius = 3;
    self.cancelBt.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
    self.cancelBt.layer.borderWidth = 1;
    self.okBt.layer.masksToBounds = YES;
    self.okBt.layer.cornerRadius = 3;
    self.msgBt.layer.masksToBounds = YES;
    self.msgBt.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3;
}

+(void)showAlertWithName:(NSString *)customerName andPhone:(NSString *)phone andCustomer:(NSString *)customerId andOkBt:(okBtClick)ok{
    HTTelMsgAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTTelMsgAlertView" owner:nil options:nil].lastObject;
    alert.frame = CGRectMake(16, HEIGHT - 220, HMSCREENWIDTH - 32, 220);
    alert.custInfoLabel.text = [NSString stringWithFormat:@"%@:%@",customerName,phone];
    alert.name = customerName;
    alert.telPhone = phone;
    alert.customerId = customerId;
    if (ok) {
        alert.okBtClicked  = ok;
    }
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}
- (IBAction)cancelClicked:(id)sender {
   [KLCPopup dismissAllPopups];
}

- (IBAction)getMsgClicked:(id)sender {
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue   = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.msgBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.msgWidth.constant = [self.msgBt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size.width + 40 ;
                self.msgBt.userInteractionEnabled=YES;
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 70;
            self.strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.msgBt setTitle:[NSString stringWithFormat:@"重发验证码(%@)",self.strTime] forState:UIControlStateNormal];
                self.msgWidth.constant = [self.msgBt.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size.width + 40 ;
                self.msgBt.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    NSDictionary *dic = @{
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.customerId],
                          @"type":@"1",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"/admin/api/sms/send_sms_verification_code_4_app.html"] params:dic success:^(id json) {
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"获取验证码成功"];
        }else{
            [MBProgressHUD showError:[json getStringWithKey:@"msg"]];
        }
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
}

- (IBAction)okClicekd:(id)sender {
    if (self.msgTextField.text.length == 0) {
        [MBProgressHUD showError:@"请获取验证码"];
        return;
    }
    NSDictionary *dic = @{
                          @"customerId":[HTHoldNullObj getValueWithUnCheakValue:self.customerId],
                          @"code":[HTHoldNullObj getValueWithUnCheakValue:self.msgTextField.text],
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"/admin/api/sms/check_sms_verification_code_4_app.html"] params:dic success:^(id json) {
        if ([[json getStringWithKey:@"state"] isEqualToString:@"1"]) {
            if (self.okBtClicked) {
                self.okBtClicked();
            }
            [KLCPopup dismissAllPopups];
        }else{
            [MBProgressHUD showError:[json getStringWithKey:@"msg"]];
        }
       
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
    
   
}


@end
