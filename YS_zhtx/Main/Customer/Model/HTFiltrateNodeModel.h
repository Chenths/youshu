//
//  HTFiltrateNodeModel.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFiltrateNodeModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) BOOL isSelected;


@property (nonatomic,strong) NSString *searchKey;

@property (nonatomic,strong) NSString *searchValue;

@property (nonatomic,strong) NSString *sortType;

@end
