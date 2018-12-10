//
//  HTExplainModel.m
//  有术
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTExplainModel.h"

@implementation HTExplainModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"subList"]) {
        
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in value) {
                HTExplainModel *model = [[HTExplainModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [dataArray addObject:model];
            }
            self.subList = dataArray;
        }
    }else{
        [super setValue:value forKey:key];
    }
}



@end
