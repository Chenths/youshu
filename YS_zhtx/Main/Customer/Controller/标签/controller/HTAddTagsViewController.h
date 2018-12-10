//
//  HTAddTagsViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^DidAddText)(void);
typedef void(^DidAddTag)(NSDictionary *tag);
#import "HTCommonViewController.h"

@interface HTAddTagsViewController : HTCommonViewController

@property (nonatomic,strong) NSString *modelId;

@property (nonatomic,strong) NSString *modulId;

@property (nonatomic,copy) DidAddText addText;

@property (nonatomic,copy) DidAddTag addTag;

@property (nonatomic,strong) NSArray *tagsArray;

@end
