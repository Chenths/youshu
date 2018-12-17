//
//  HTCustEditConfigModel.m
//  YS_zhtx
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustEditConfigModel.h"

@implementation HTCustEditConfigModel



-(void)loadLevel{
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadCompanyCustLevel] params:@{@"companyId":[HTShareClass shareClass].loginModel.companyId} success:^(id json) {
        self.levels = json[@"data"];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}

-(NSArray *)levels{
    if (!_levels) {
        _levels = [NSArray array];
    }
    return _levels;
}

@end
