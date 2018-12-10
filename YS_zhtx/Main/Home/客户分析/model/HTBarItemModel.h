//
//  HTBarItemModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBarItemModel : NSObject

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) NSString *name;

-(CGFloat)getMaxVale;

@end
