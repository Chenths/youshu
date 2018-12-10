//
//  HTFaceVipModel.h
//  有术
//
//  Created by mac on 2017/11/8.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFaceVipModel : NSObject

@property (nonatomic,strong) NSString *path;

@property (nonatomic,assign) BOOL sex_cust;

@property (nonatomic,assign) BOOL hasbuy;

@property (nonatomic,strong) NSString *uid;

@property (nonatomic,strong) NSDictionary *cust_level;

@property (nonatomic,strong) NSString *create_time;

@property (nonatomic,strong) NSString *nickname_cust;

@property (nonatomic,assign) BOOL isPush;

@property (nonatomic,strong) NSString *phone_cust;

@property (nonatomic,strong) NSString *birth;

@property (nonatomic,strong) NSMutableArray *imgs;

@end
