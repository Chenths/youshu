//
//  HTCustomTextAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomTextAlertView.h"
@interface HTCustomTextAlertView()<UITextViewDelegate>


@end
@implementation HTCustomTextAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"#222222"] withWidth:1];
    [self.okBt changeCornerRadiusWithRadius:3];
    [self changeCornerRadiusWithRadius:3];
    [self.textView changeCornerRadiusWithRadius:3];
}
+(void)showAlertWithTitle:(NSString *)title holdTitle:(NSString *)hold orTextString:(NSString *)textStr okBtclicked:(OkBtClick)ok andCancleBtClicked:(CancleBtClick)cancel{
    
    HTCustomTextAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTCustomTextAlertView" owner:nil options:nil].lastObject;
    alert.frame = CGRectMake(16, HEIGHT - 244 , HMSCREENWIDTH - 32, 244);
    alert.titleLabel.text = title;
    alert.holdLabel.text = hold;
    alert.okBtClicked = ok;
    alert.cancleClicked = cancel;
    alert.textView.delegate = alert;
    if (textStr.length > 0) {
        alert.textView.text = textStr;
        alert.holdLabel.hidden = YES;
    }
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}

+(void)showAlertWhiteBackAndNoTouchWithTitle:(NSString *)title holdTitle:(NSString *)hold orTextString:(NSString *)textStr okBtclicked:(OkBtClick)ok andCancleBtClicked:(CancleBtClick)cancel{
    
    HTCustomTextAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTCustomTextAlertView" owner:nil options:nil].lastObject;
    alert.frame = CGRectMake(16, HEIGHT - 244 , HMSCREENWIDTH - 32, 244);
    alert.titleLabel.text = title;
    alert.holdLabel.text = hold;
//    alert.okBtClicked = ok;
    alert.textView.backgroundColor = [UIColor whiteColor];
    alert.textView.userInteractionEnabled = NO;
    alert.cancleClicked = cancel;
    alert.okBt.hidden = YES;
    [alert.cancelBt setTitle:@"知道了" forState:UIControlStateNormal];
    alert.cancelBt.backgroundColor = [UIColor blackColor];
    [alert.cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    alert.twoBtnLeadingToTailing.constant = - (HMSCREENWIDTH - 32 - 64);
//    alert.cancelLeftConstains.constant = 36;
    alert.textView.delegate = alert;
    if (textStr.length > 0) {
        alert.textView.text = textStr;
        alert.holdLabel.hidden = YES;
    }
    KLCPopup *pop = [KLCPopup popupWithContentView:alert showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.holdLabel.hidden = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textView.text.length == 0) {
        self.holdLabel.hidden = NO;
    }else{
        self.holdLabel.hidden = YES;
    }
}
- (IBAction)cancelClicked:(id)sender {
    [KLCPopup dismissAllPopups];
    if (self.cancleClicked) {
        self.cancleClicked();
    }
}
- (IBAction)okClicked:(id)sender {
    if (self.textView.text.length == 0) {
        [MBProgressHUD showError:@"请输入内容"];
        return;
    }
    [KLCPopup dismissAllPopups];
    if (self.okBtClicked) {
        self.okBtClicked(self.textView.text);
    }
}


@end
