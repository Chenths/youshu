//
//  HTOrderOrProductState.h
//  YS_zhtx
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTOrderOrProductState : NSObject

+(NSString *)getOrderStateFormOrderString:(NSString *)state;

+(NSString *)getProductStateFormOrderString:(NSString *)state;

@end
