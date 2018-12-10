//
//  HTVipLevelEditCell.m
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTVipLevelEditCell.h"

@interface HTVipLevelEditCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *lowTextFied;

@property (weak, nonatomic) IBOutlet UITextField *heightTextFied;

@property (weak, nonatomic) IBOutlet UILabel *upLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation HTVipLevelEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange:) name:UITextFieldTextDidChangeNotification object:self.heightTextFied];
}

-(void)createSubView{

    self.upLabel.hidden = YES;
    self.lineView.hidden = NO;
    self.lowTextFied.enabled = NO;    
}

- (void)setModel:(HTVipLevelSeterModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.lowTextFied.text = [HTHoldNullObj getValueWithUnCheakValue:model.lowValue];
    self.heightTextFied.text = [HTHoldNullObj getValueWithUnCheakValue:model.heightValue];
    
    self.lowTextFied.placeholder = [model.units isEqualToString:@"天"] ? @"最低天数" : @"最低金额";
    self.heightTextFied.placeholder = [model.units isEqualToString:@"天"] ? @"最高天数" : @"最高金额";
}
-(void)textValueChange:(NSNotification *)  notic{
    UITextField *field = notic.object;
    if (field == self.heightTextFied) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(heightValueChangeWithText:andCell:)]) {
            [self.delegate heightValueChangeWithText:field.text andCell:self];
        }
    }
}
-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        self.heightTextFied.enabled = YES;
        self.heightTextFied.borderStyle = UITextBorderStyleRoundedRect;
        
    }else{
        self.heightTextFied.enabled = NO;
        self.heightTextFied.borderStyle = UITextBorderStyleNone;
    }
}
-(void)setIsLatst:(BOOL)isLatst{
    _isLatst = isLatst;
    if (isLatst) {
        self.upLabel.hidden = NO;
        self.heightTextFied.hidden = YES;
        self.lineView.hidden = YES;
    }else{
        self.upLabel.hidden = YES;
        self.heightTextFied.hidden = NO;
        self.lineView.hidden = NO;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.heightTextFied];
}

@end
