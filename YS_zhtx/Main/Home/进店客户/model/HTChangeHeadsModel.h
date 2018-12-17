//
//  HTChangeHeadsModel.h
//  有术
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTChangeHeadsModel : NSObject

@property (nonatomic,strong) NSString *create_time;

@property (nonatomic,strong) NSString *path;

@property (nonatomic,strong) NSString *uid;

@property (nonatomic,assign) BOOL isOldHead;

@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,strong) NSString *HTChangeHeadsModelId;

@end
