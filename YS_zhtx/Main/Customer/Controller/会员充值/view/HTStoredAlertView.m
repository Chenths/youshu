//
//  HTStoredAlertView.m
//  有术
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
//#import "HTStoredSendModel.h"
#import "HTStoredAlertView.h"

@interface HTStoredAlertView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *storeMoneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendMoneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *okBt;
@property (weak, nonatomic) IBOutlet UISwitch *swichBt;
@property (weak, nonatomic) IBOutlet UIView *sendTextBack;

@end

@implementation HTStoredAlertView


-(instancetype)initAlertWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self = [[NSBundle mainBundle] loadNibNamed:@"HTStoredAlertView" owner:nil options:nil].lastObject;
        [self setFrame:frame];
        self.cancelBt.layer.masksToBounds = YES;
        self.cancelBt.layer.cornerRadius = 3;
        self.cancelBt.layer.borderWidth = 1;
        self.cancelBt.layer.borderColor = [UIColor colorWithHexString:@"222222"].CGColor;
        self.sendMoneyTextField.enabled = NO;
        self.okBt.layer.masksToBounds = YES;
        self.okBt.layer.cornerRadius = 3;
        self.sendTextBack.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiedlDidChange:) name:UITextFieldTextDidChangeNotification object:self.storeMoneyTextField];
        self.storeMoneyTextField.delegate = self;
    }
    return self;
}
- (IBAction)cancelBtCilcked:(id)sender {
    if (self.delegate) {
        [self.delegate cancelStored];
    }
    
}
- (IBAction)okBtClicked:(id)sender {
    
    if (self.delegate) {
        if (self.storeMoneyTextField.text.length == 0) {
            [MBProgressHUD showError:@"请输入充值金额"];
            return;
        }
        [self.delegate  storedMoney:[HTHoldNullObj getValueWithUnCheakValue:self.storeMoneyTextField.text] withSend:[HTHoldNullObj getValueWithUnCheakValue:self.sendMoneyTextField.text]];
        [self cancelBtCilcked:nil];
    }
}

- (IBAction)switchClicked:(id)sender {
    
    if (self.swichBt.isOn) {
        self.sendMoneyTextField.enabled = YES;
        self.sendTextBack.backgroundColor = [UIColor colorWithHexString:@"e6e8ec"];
    }else{
        self.sendMoneyTextField.enabled = NO;
        self.sendTextBack.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    }
}
-(void)textFiedlDidChange:(NSNotification *)notice{
    
    if (notice.object == self.storeMoneyTextField) {
//        HTStoredSendModel *selectedModel = [[HTStoredSendModel alloc] init];
//        for (HTStoredSendModel *model in self.dataArray) {
//            if (model.money) {
//                if (self.storeMoneyTextField.text.floatValue >= model.money.floatValue) {
//                    selectedModel = model;
//                }
//            }
//        }
//        if (selectedModel.money) {
//            self.sendMoneyTextField.text = [HTHoldNullObj getValueWithUnCheakValue:selectedModel.send];
//        }else{
//            self.sendMoneyTextField.text = @"";
//        }
    }
    
}

@end
