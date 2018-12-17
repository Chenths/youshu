//
//  HTNoticpushSeterModel.h
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNoticpushSeterModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSArray *allRoles;

@property (nonatomic,strong) NSMutableArray *selectedRoles;

@property (nonatomic,assign) CGFloat cellHight;

@end
