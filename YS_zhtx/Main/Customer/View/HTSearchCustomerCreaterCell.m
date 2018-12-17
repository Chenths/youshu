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
            [strongSelf.searchDic setObject:[dic getStringWithKey:@"id"] forKey:@"model.creator"];
            [strongSelf.searchDic setObject:[dic getStringWithKey:@"name"] forKey:@"creatorName"];
            strongSelf.textField.text = [dic getStringWithKey:@"name"];
        };
        if (self.alertHidd) {
        self.alertHidd();
        }
        
        [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    }
    return NO;
}
-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    self.textField.text = [searchDic getStringWithKey:@"creatorName"];
}

@end
