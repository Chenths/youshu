//
//  HTWriteBarcodeView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import <KLCPopup.h>
#import "HTCustomMadeFieldAlertView.h"
#import "HTWriteBarcodeView.h"

@interface HTWriteBarcodeView()<HTCustomMadeFieldAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *barcodeLength;


@property (weak, nonatomic) IBOutlet UIView *writeBack;


@end

@implementation HTWriteBarcodeView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.barcodeTextfiled.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.writeBack changeCornerRadiusWithRadius:3];
    BOOL isSet = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"barcodeIsSet"]];
    if (!isSet) {
        [[NSUserDefaults standardUserDefaults] setValue:@"10" forKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"BarcodeLength"]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"barcodeIsSet"]];
        self.barcodeLength.text = @"(当前识别10位)";
    }else{
        NSString *length = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"BarcodeLength"]];
        self.barcodeLength.text = [NSString stringWithFormat:@"(当前识别%@位)",length];
    }
}

- (IBAction)setterBtClicked:(id)sender {
    HTCustomMadeFieldAlertView *alert = [[HTCustomMadeFieldAlertView alloc] initWithTitle:@"设置识别条码的位数" message:nil delegate:self];
    alert.textField.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}
#pragma mark - event

- (IBAction)okBtCliccked:(id)sender {
    if (self.delegate) {
        [self.delegate searchProductWithBarCode:self.barcodeTextfiled.text];
    }
}
#pragma mark-delegate
-(void)okBtClickedWithStr:(NSString *)text{
    if (text.integerValue < 4 && text.integerValue != 0) {
        [MBProgressHUD showError:@"条码位数不能小于4位"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:text forKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"BarcodeLength"]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-%@",[HTShareClass shareClass].loginModel.companyId,@"barcodeIsSet"]];
    self.barcodeLength.text = [NSString stringWithFormat:@"(当前识别%@位)",text];
}
-(void)cancelBtClickedWithStr:(NSString *)text{
    
}


@end
