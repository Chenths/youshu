//
//  HTSetWarningAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSetWarningAlertView.h"

@interface HTSetWarningAlertView()

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;

@property (weak, nonatomic) IBOutlet UILabel *behindLabel;

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

@property (weak, nonatomic) IBOutlet UIButton *okBt;
@property (weak, nonatomic) IBOutlet UILabel *tailLabel;

@end

@implementation HTSetWarningAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    [self.okBt changeCornerRadiusWithRadius:3];
    [self changeCornerRadiusWithRadius:3];
    
}
- (instancetype)initWithAlert
{
    self = [[NSBundle mainBundle] loadNibNamed:@"HTSetWarningAlertView" owner:nil options:nil].lastObject;
    [self setFrame:CGRectMake(16, (HEIGHT - 210) / 2, HMSCREENWIDTH - 32, 210)];
    return self;
}
-(void)setModel:(HTEarlyWarningModel *)model{
    _model = model;
    self.titileLabel.text = [NSString stringWithFormat:@"%@预警设置",model.title];
    self.behindLabel.text = [NSString stringWithFormat:@"%@%@",model.title,model.bacekey];
    self.tailLabel.text = [NSString stringWithFormat:@"%@将预警", model.keyUnit];
}
-(void)show{
    KLCPopup *pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [pop show];
}
- (IBAction)cancelClicked:(id)sender {
    [KLCPopup dismissAllPopups];
}
- (IBAction)okClicekd:(id)sender {
    [KLCPopup dismissAllPopups];
    if (self.valueTextField.text.integerValue > self.model.mostNum.integerValue || self.valueTextField.text.integerValue == 0) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请输入0-%@的数值",self.model.mostNum]];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(okClickedWithModel:)]) {
        self.model.keyValue = self.valueTextField.text;
        [self.delegate okClickedWithModel:self.model];
    }
}


@end
