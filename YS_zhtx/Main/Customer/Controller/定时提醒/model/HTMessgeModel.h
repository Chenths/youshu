//
//  HTMessgeModel.h
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMessgeModel : NSObject
//消息id
@property (nonatomic,strong) NSString * messgeId;
//消息标题
@property (nonatomic,strong) NSString * title;
//消息详情
@property (nonatomic,strong) NSString * content;
//消息时间
@property (nonatomic,strong) NSString * noticeAt;
//消息样式
@property (nonatomic,strong) NSString * noticeType;
//模块id
@property (nonatomic,strong) NSString * moduleId;
//数据id
@property (nonatomic,strong) NSString * modelId;
//提示状态
@property (nonatomic,strong) NSString * isRead;

@property (nonatomic,strong) NSString *noticeParams;

@property (nonatomic,strong) NSDictionary *targets;

@property (nonatomic,assign) BOOL isWill;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,strong) NSString *handleType;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,assign) BOOL showState;

@end
