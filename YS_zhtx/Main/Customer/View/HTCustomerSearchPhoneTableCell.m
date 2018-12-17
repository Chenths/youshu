//
//  HTCustomerSearchPhoneTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomerSearchPhoneTableCell.h"
@interface HTCustomerSearchPhoneTableCell()

@end
@implementation HTCustomerSearchPhoneTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSearchDic:(NSDictionary *)searchDic{
    _searchDic = searchDic;
    self.textField.text = [searchDic getStringWithKey:@"model.phone_cust"];
}
@end
