//
//  HTTurnOutDiscountCell.m
//  有术
//
//  Created by mac on 2018/5/8.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef NS_ENUM(NSInteger, HTWrithType) {
    HTWrithTypeDiscount,                // Default type for the current input method.
    HTWrithTypeMoney,
};
#import "HTTurnOutDiscountCell.h"
@interface HTTurnOutDiscountCell()

@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *holdBt;
@property (nonatomic,assign) HTWrithType wtithType;

@end
@implementation HTTurnOutDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wtithType = HTWrithTypeDiscount;
    [self.holdBt setTitle:@"输入折扣" forState:UIControlStateNormal];
    self.textFiled.keyboardType = UIKeyboardTypeDecimalPad;
    self.holdBt.layer.masksToBounds = YES;
    self.holdBt.layer.cornerRadius = 3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChage:) name:UITextFieldTextDidChangeNotification object:self.textFiled];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textFiled];
}
-(void)textDidChage:(NSNotification *)notion{
    if (notion.object == self.textFiled) {
        if (self.wtithType == HTWrithTypeDiscount) {
            [self.discount setObject: [HTHoldNullObj getValueWithBigDecmalObj:self.textFiled.text] forKey:@"discount"];
            [self.discount setObject:@"" forKey:@"money"];
        }
        if (self.wtithType == HTWrithTypeMoney) {
            [self.discount setObject: [HTHoldNullObj getValueWithBigDecmalObj:self.textFiled.text] forKey:@"money"];
            [self.discount setObject:@"" forKey:@"discount"];
        }
    }
}

- (IBAction)holdBtClicked:(id)sender {
    
    [LPActionSheet showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"输入折扣",@"输入成本价"] handler:^(LPActionSheet *actionSheet, NSInteger index) {
        if (index == 1) {
            self.wtithType = HTWrithTypeDiscount;
            self.textFiled.placeholder = @"请输入调入折扣";
            self.textFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [self.discount setObject:@"" forKey:@"discount"];
            [self.discount setObject:@"" forKey:@"money"];
            self.textFiled.text = @"";
            [self.holdBt setTitle:@"输入折扣" forState:UIControlStateNormal];
        }
        if (index == 2) {
            self.wtithType = HTWrithTypeMoney;
            self.textFiled.placeholder = @"请输入调入成本价";
            self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
            [self.discount setObject:@"" forKey:@"discount"];
            [self.discount setObject:@"" forKey:@"money"];
            self.textFiled.text = @"";
            [self.holdBt setTitle:@"输入成本价" forState:UIControlStateNormal];
        }
    }];
}

@end
