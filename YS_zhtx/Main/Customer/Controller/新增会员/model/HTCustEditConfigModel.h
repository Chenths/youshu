//
//  HTCustEditConfigModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/29.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCustEditConfigModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) UIKeyboardType keyBoradType;

@property (nonatomic,assign) BOOL require;

@property (nonatomic,assign) BOOL readOnly;

@property (nonatomic,strong) NSString *SearchKey;
//
@property (nonatomic,strong) NSString *SearchValue;
//配置权限
@property (nonatomic,strong) NSString *configKey;
//选择等级配置数组
@property (nonatomic,strong) NSArray *levels;

@end
