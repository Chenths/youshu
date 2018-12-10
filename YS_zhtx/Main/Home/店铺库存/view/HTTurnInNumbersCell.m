//
//  HTTurnInNumbersCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTurnInNumbersCell.h"
@interface HTTurnInNumbersCell()

@property (weak, nonatomic) IBOutlet UIView *textFieldBack;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
@implementation HTTurnInNumbersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.textFieldBack changeCornerRadiusWithRadius:3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.numberField];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.numberField];
}
- (void)textfieldDidChange:(NSNotification *)notice{
    if (notice.object == self.numberField) {
        if (self.type == HTTurnIn) {
            self.model.numbers = self.numberField.text;
        }else{
            if (self.numberField.text.floatValue > self.model.maxCount.floatValue) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"当前库存为%@",self.model.maxCount]];
                self.numberField.text = self.model.maxCount;
                self.model.numbers = self.model.maxCount;
                return;
            }else{
                self.model.numbers = self.numberField.text;
            }
        }
        
    }
}
-(void)setModel:(HTTuneOutorInModel *)model{
    _model = model;
    self.sizeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.size];
    self.countLabel.text = [NSString stringWithFormat:@"%@件",[HTHoldNullObj getValueWithUnCheakValue:model.maxCount]];
    if (self.type == HTTurnIn) {
        self.numberField.placeholder = @"调入数量";
    }else{
        self.numberField.placeholder = @"调出数量";
    }
}


@end
