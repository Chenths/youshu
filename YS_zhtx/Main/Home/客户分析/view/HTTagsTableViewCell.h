//
//  HTTagsTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTNewTagsModel.h"
#import <UIKit/UIKit.h>
@class HTTagsTableViewCell;
@protocol HTTagsTableViewCellDelegate<NSObject>

-(void)addTagClicked;

-(void)faceTypeSeemoreClickedWithCell:(HTTagsTableViewCell *)cell;

-(void)editTagClickedWithDataDic:(NSDictionary *)dataDic;

-(void)editTagCancelTopClickedWithDataDic:(NSDictionary *)dataDic;

-(void)delteTagClickedWithDataDic:(NSDictionary *)dataDic;

@end
@interface HTTagsTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL isSeeMore;
@property (nonatomic,strong) HTNewTagsModel *model;

@property (nonatomic,weak) id <HTTagsTableViewCellDelegate>delegate;

@end
