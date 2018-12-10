//
//  HTExplainViewController.h
//  有术
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
typedef NS_ENUM(NSUInteger, EXPLAINTYPE ) {
    PC,
    APP,
};
#import "HTCommonViewController.h"

@interface HTExplainViewController : HTCommonViewController

@property (nonatomic,assign) EXPLAINTYPE explainType;

@property (strong,nonatomic) NSMutableArray *dataArray;

@end
