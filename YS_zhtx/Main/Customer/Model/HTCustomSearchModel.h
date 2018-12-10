//
//  HTCustomSearchModel.h
//  YS_zhtx
//
//  Created by mac on 2018/8/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCustomSearchModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *holdName;

@property (nonatomic,strong) NSString *beginValue;

@property (nonatomic,strong) NSString *endValue;

@property (nonatomic,strong) NSString *searchKey;

@property (nonatomic,strong) NSString *searchValue;

@property (nonatomic,strong) NSString *beginKey;

@property (nonatomic,strong) NSString *endKey;

@property (nonatomic,strong) NSString *beginHold;

@property (nonatomic,strong) NSString *endHold;


@property (nonatomic,assign) UIKeyboardType keyboardType;

@end
