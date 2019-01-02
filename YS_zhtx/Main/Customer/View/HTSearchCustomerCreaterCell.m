//
//  HTSearchCustomerCreaterCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCreatorListViewController.h"
#import "HTSearchCustomerCreaterCell.h"
@interface HTSearchCustomerCreaterCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end
@implementation HTSearchCustomerCreaterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.textField) {
        HTCreatorListViewController *vc = [[HTCreatorListViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        vc.selecedItme = ^(NSDictionary *dic) {
            __weak typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.alertShow) {
                strongSelf.alertShow();
            }
            if(strongSelf.type == 1){
                [strongSelf.searchDic setObject:[dic getStringWithKey:@"id"] forKey:@"model.creator"];
                [strongSelf.searchDic setObject:[dic getStringWithKey:@"name"] forKey:@"creatorName"];
                strongSelf.textField.text = [dic getStringWithKey:@"name"];
            }else{
                [strongSelf.searchDic setObject:[dic getStringWithKey:@"id"] forKey:@"model.companyId_cust"];
                [strongSelf.searchDic setObject:[dic getStringWithKey:@"name"] forKey:@"model.companyName_cust"];
                strongSelf.textField.text = [dic getStringWithKey:@"name"];
            }
        };
        if (self.alertHidd) {
        self.alertHidd();
        }
        vc.type = _type;
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }
    return NO;
}
-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    if (_type == 1) {
        self.textField.text = [searchDic getStringWithKey:@"creatorName"];
        _cellLabel.text = @"创建者";
        _textField.placeholder = @"选择创建者";
    }else{
        self.textField.text = [searchDic getStringWithKey:@"model.companyName_cust"];
        _cellLabel.text = @"共享店铺";
        _textField.placeholder = @"";
    }
}

@end
