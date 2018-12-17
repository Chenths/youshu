//
//  HTSearchTextHeadView.m
//  有术
//
//  Created by mac on 2018/5/9.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTSearchTextHeadView.h"
@interface HTSearchTextHeadView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTextFeild;
@property (nonatomic,assign) BOOL isSearch;
@end
@implementation HTSearchTextHeadView
- (instancetype)initWithSearchFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HTSearchTextHeadView" owner:nil options:nil].lastObject;
        self.searchTextFeild.hidden = YES;
        self.searchTextFeild.delegate = self;
        self.titleLabel.hidden = NO;
        [self setFrame:frame];
    }
    return self;
}
- (IBAction)beginSearchBtClicked:(id)sender {
    self.titleLabel.hidden = YES;
    self.searchTextFeild.hidden = NO;
    self.searchTextFeild.text = @"";
    self.searchTextFeild.placeholder = @"请输入店铺名称";
    [self.searchTextFeild becomeFirstResponder];
    self.isSearch = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.delegate) {
        [self.delegate searchShopWithString:[HTHoldNullObj getValueWithUnCheakValue:textField.text]];
        self.searchTextFeild.hidden = YES;
        self.titleLabel.hidden = NO;
        self.isSearch = YES;
        [textField endEditing:YES];
    }
    return  YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.isSearch) {
        return;
    }
    if (self.delegate) {
        [self.delegate searchShopWithString:[HTHoldNullObj getValueWithUnCheakValue:textField.text]];
        self.searchTextFeild.hidden = YES;
        self.titleLabel.hidden = NO;
    }
}

@end
