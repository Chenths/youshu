//
//  HTMessegeViewController.h
//  24小助理
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import "HTCommonViewController.h"

@interface HTMessegeViewController : HTCommonViewController

@property (nonatomic,strong) NSMutableArray *dataArray;
// 消息类型
@property (nonatomic,copy) NSString *type;
//  判断消息状态

@property (nonatomic,copy) NSString *state;

@property (nonatomic,assign) BOOL showState;

- (void)loadDadaWithPage:(int) page1;

@end
