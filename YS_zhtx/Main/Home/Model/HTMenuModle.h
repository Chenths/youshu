//
//  HTMenuModle.h
//  24小助理
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMenuModle : NSObject

@property (nonatomic,copy) NSString *active;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString * HTMenuId;
@property (nonatomic,copy) NSString *leaf;
@property (nonatomic,copy) NSString * mode;
@property (nonatomic,strong) NSNumber *moduleId;
@property (nonatomic,copy) NSString *moduleName;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,strong) NSNumber *parentId;
@property (nonatomic,strong) NSNumber *sortId;
@property (nonatomic,copy)  NSString *treeNode;
@property (nonatomic,strong) NSArray *treeNodes;
@property (nonatomic,strong) NSString *url;

@property (nonatomic,assign) BOOL isShowWarning;

@property (nonatomic,strong) NSMutableArray *warningArr;

@property (nonatomic,strong) NSMutableArray *warningIndexPaths;



@end
