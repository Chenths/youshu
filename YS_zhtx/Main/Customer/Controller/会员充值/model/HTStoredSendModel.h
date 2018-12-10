//
//  HTStoredSendModel.h
//  有术
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTStoredSendModel : NSObject

@property (nonatomic,strong) NSString *money;

@property (nonatomic,strong) NSString *send;

@property (nonatomic,assign) BOOL islast;

@property (nonatomic,assign) BOOL isSelected;



@end
