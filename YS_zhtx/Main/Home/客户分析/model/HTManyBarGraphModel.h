//
//  HTManyBarGraphModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTBarItemModel.h"
#import "HTBarTitleItemModel.h"
#import <Foundation/Foundation.h>

@interface HTManyBarGraphModel : NSObject

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) NSArray *title;

-(CGFloat)getItemsMaxValue;


@end
