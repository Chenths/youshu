//
//  HTEditVipManager.m
//  YS_zhtx
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustEditConfigModel.h"
#import "HTEditVipManager.h"

@implementation HTEditVipManager

+(NSArray *)configEditModels{
    
    NSArray *names = @[@"称呼",@"电话",@"性别",@"生日",@"会员等级",@"身高",@"爱好",@"名称"];
    NSArray *keys = @[@"cust.nickname",@"cust.phone",@"cust.sex",@"cust.birthday",@"model.custLevel_json",@"model.height",@"model.hobby",@"model.name"];
    NSArray *configKeys = @[@"nickname_cust",@"phone_cust",@"sex_cust",@"birthday_cust",@"custLevel",@"height",@"hobby",@"name"];
    NSArray *keyBordTypes = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypePhonePad),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault),@(UIKeyboardTypeNumberPad),@(UIKeyboardTypeDefault),@(UIKeyboardTypeDefault)];
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 0; i < names.count; i++) {
        NSString *name = names[i];
        NSString *key = keys[i];
        UIKeyboardType type = [keyBordTypes[i] integerValue];
        HTCustEditConfigModel *model = [[HTCustEditConfigModel alloc] init];
        model.title = name;
        model.keyBoradType = type;
        model.SearchKey = key;
        model.configKey = configKeys[i];
        [datas addObject:model];
    }
    return datas;
}

@end
