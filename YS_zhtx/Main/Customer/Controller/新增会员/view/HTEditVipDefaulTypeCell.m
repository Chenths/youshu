//
//  HTEditVipDefaulTypeCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTEditVipDefaulTypeCell.h"
@interface HTEditVipDefaulTypeCell()

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HTEditVipDefaulTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.valueTextField setValue:[UIColor colorWithHexString:@"#666666"] forKeyPath:@"placeholderLabel.textColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidCCChange:) name:UITextFieldTextDidChangeNotification object:self.valueTextField];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.valueTextField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(HTCustEditConfigModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    self.valueTextField.keyboardType = self.model.keyBoradType;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    self.valueTextField.textColor = [UIColor colorWithHexString:@"#666666"];
    self.valueTextField.enabled = YES;
    if (model.readOnly) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        self.valueTextField.textColor = [UIColor colorWithHexString:@"#999999"];
        self.valueTextField.enabled = NO;
    }
    if (model.require) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#FC5C7D"];
    }
}
-(void)setRequestDic:(NSMutableDictionary *)requestDic{
    _requestDic = requestDic;
    if ([requestDic getStringWithKey:self.model.SearchKey].length == 0) {
        self.valueTextField.text = @"";
        self.valueTextField.placeholder = @"未添加";
    }else{
        self.valueTextField.text = [requestDic getStringWithKey:self.model.SearchKey];
    }
}
-(void)textDidCCChange:(NSNotification *)notice{
    if (notice.object == self.valueTextField ) {
        [self.requestDic setObject:self.valueTextField.text forKey:self.model.SearchKey];
    }
}

@end
