//
//  HTFiltrateHeaderModel.h
//  YS_zhtx
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSUInteger, HTFiltrateStyle) {
    HTFiltrateStyleCollection       = 0,
    HTFiltrateStyleTableview  = 1 << 0,                  // used when
};
@interface HTFiltrateHeaderModel : NSObject

@property (nonatomic,assign) HTFiltrateStyle filtrateStyle;
@property (nonatomic,strong) NSArray *titles;



@end
