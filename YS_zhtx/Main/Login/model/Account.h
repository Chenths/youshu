//
//  Account.h
//  shengyijing
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject


//用户名
@property (nonatomic, copy) NSString * userName;

//密码
@property (nonatomic, copy) NSString * passWord;


//店铺number
@property (nonatomic,copy) NSString * shopNumber;
@end
