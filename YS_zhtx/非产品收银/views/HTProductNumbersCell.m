//
//  HTProductNumbersCell.m
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTProductNumbersCell.h"
@interface  HTProductNumbersCell()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *valuetext;
@property (weak, nonatomic) IBOutlet UILabel *titlteLabel;


@end
@implementation HTProductNumbersCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"222222"].CGColor;
    self.backView.layer.borderWidth = 1;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieledDidChange:) name:UITextFieldTextDidChangeNotification object:self.valuetext];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.valuetext];
}
-(void)textFieledDidChange:(NSNotification *)notice{
    if (notice.object == self.valuetext) {
        self.model.value = self.valuetext.text;
    }
}
- (IBAction)miusClicked:(id)sender {
    if (self.valuetext.text.integerValue <= 1) {
        self.model.value = @"1";
        return;
    }else{
        self.valuetext.text = [NSString stringWithFormat:@"%ld",self.valuetext.text.integerValue - 1];
        self.model.value = self.valuetext.text;
    }
}
- (IBAction)addClicked:(id)sender {
     self.valuetext.text = [NSString stringWithFormat:@"%ld",self.valuetext.text.integerValue + 1 ];
    self.model.value = self.valuetext.text;
}
- (void)setModel:(HTEditFastProductModel *)model{
    _model = model;
    self.titlteLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    
    if (model.value.length > 0) {
        self.valuetext.text = [NSString stringWithFormat:@"%@%@%@",model.pre,model.value,model.suf];
    }else{
        self.model.value = @"1";
    }
    self.valuetext.keyboardType = model.keyBroardType;
}

@end
