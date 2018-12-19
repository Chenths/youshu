//
//  HTOrderSearchCustomerTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomerListModel.h"
#import "HTCustomerViewController.h"
#import "HTOrderSearchCustomerTableCell.h"
@interface HTOrderSearchCustomerTableCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFiled;


@end
@implementation HTOrderSearchCustomerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textFiled.delegate = self;
}
-(void)setSearchDic:(NSMutableDictionary *)searchDic{
    _searchDic = searchDic;
    self.textFiled.text = [searchDic getStringWithKey:@"custName"];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    HTCustomerViewController *vc = [[HTCustomerViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.backImg = @"g-back";
    vc.searchCustItme = ^(HTCustomerListModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.alerttttShow) {
            strongSelf.alerttttShow();
        }
        if (model.custId) {
            [strongSelf.searchDic setObject:model.custId forKey:@"model.customerid"];
            [strongSelf.searchDic setObject:model.name forKey:@"custName"];
            strongSelf.textFiled.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
        }
    };
    if (self.alertttttHidd) {
        self.alertttttHidd();
    }
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
    return NO;
}

@end
