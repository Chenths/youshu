//
//  HTLineTools.h
//  24小助理
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
typedef enum : NSUInteger {
    showDefoue,
    showSale,
    showCellSale,
} ShowType;

#import <Foundation/Foundation.h>
#import "PNChart.h"
typedef void(^DisMiss)();
@interface HTLineTools : NSObject

- (PNLineChart *) lineChartWithDictionary:(NSDictionary *) dataArray andFrame:(CGRect ) rect;

@property (nonatomic,assign) ShowType showTipType;

@property (nonatomic,copy) DisMiss disMiss;

@property (nonatomic,strong) UIButton * changeBt;

- (PNLineChart *)lineChartWithArray:(NSArray *)dataArray andFrame:(CGRect)rect  withKey:(NSString *)key;

- (PNLineChart *)lineChartWithArrays:(NSArray *)dataArray andFrame:(CGRect)rect withKey:(NSString *)key;


-(void)reloadlineChartWithDictionary:(NSDictionary *)dataArray andFrame:(CGRect)rect;

- (void) upLoad;

@property (nonatomic,strong) NSArray *titles;

@end
