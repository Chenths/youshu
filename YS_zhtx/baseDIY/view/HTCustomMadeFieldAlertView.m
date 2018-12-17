//
//  HTCustomMadeFieldAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import <KLCPopup.h>
#import "HTCustomMadeFieldAlertView.h"

@interface HTCustomMadeFieldAlertView(){
    KLCPopup *pop;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgTop;

@property (weak, nonatomic) IBOutlet UIView *fieldBackView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

@property (weak, nonatomic) IBOutlet UIButton *okBt;


@end

@implementation HTCustomMadeFieldAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.fieldBackView changeCornerRadiusWithRadius:3];
    [self changeCornerRadiusWithRadius:5];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.okBt changeCornerRadiusWithRadius:3];
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id <HTCustomMadeFieldAlertViewDelegate>)delegate
{
    HTCustomMadeFieldAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTCustomMadeFieldAlertView" owner:nil options:nil].lastObject;
    alert.titleLabel.text = title ? title : @"";
    alert.msgLabel.text = msg ? msg : @"";
    CGFloat height = 0.0f;
    if (msg.length == 0) {
        self.msgTop.constant = 0;
        self.msgLabel.hidden = YES;
        height = 180;
    }else{
        height = 200;
    }
    alert.delegate = delegate;
    [alert setFrame:CGRectMake(16, HEIGHT - (height), HMSCREENWIDTH - 32, height)];
    
    return alert;
}

-(void)show{
   pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [self.textField becomeFirstResponder];
    [pop show];
}
- (IBAction)cancleClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBtClickedWithStr:)]) {
        [self.delegate cancelBtClickedWithStr:self.textField.text];
    }
    [pop dismiss:YES];
}
- (IBAction)okBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okBtClickedWithStr:)]) {
        [self.delegate okBtClickedWithStr:self.textField.text];
    }
    [pop dismiss:YES];
}


@end
