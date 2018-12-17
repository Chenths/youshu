//
//  HTGuiderListModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTGuiderListModel : NSObject

@property (nonatomic,strong) NSString *guiderId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ordercount;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *salevolume;
@property (nonatomic,assign) int index;



@end
