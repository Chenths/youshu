//
//  HTProductNormalTableViewCell.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTProductNormalTableViewCell.h"
@interface HTProductNormalTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@end
@implementation HTProductNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.valueTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieledDidChange:) name:UITextFieldTextDidChangeNotification object:self.valueTextField];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.valueTextField];
}
-(void)textFieledDidChange:(NSNotification *)notice{
    if (notice.object == self.valueTextField) {
        self.model.value = self.valueTextField.text;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.model.value.length > 0) {
        self.valueTextField.text = [NSString stringWithFormat:@"%@%@%@",self.model.pre,self.model.value,self.model.suf];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)setModel:(HTEditFastProductModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    if (model.value.length > 0) {
        self.valueTextField.text = [NSString stringWithFormat:@"%@%@%@",model.pre,model.value,model.suf];
    }
    self.valueTextField.keyboardType = model.keyBroardType;
}

@end
