//
//  HTTagsCloseTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTNewTagsModel.h"
#import <UIKit/UIKit.h>
@class HTTagsCloseTableViewCell;
@protocol HTTagsCloseTableViewCellDelegate <NSObject>

-(void)nomoalTypeClicekedWithCell:(HTTagsCloseTableViewCell *)cell;

-(void)nomorlTypeAddTag;
@end

@interface HTTagsCloseTableViewCell : UITableViewCell

@property (nonatomic,strong) HTNewTagsModel *model;

@property (nonatomic,weak) id <HTTagsCloseTableViewCellDelegate> delegate;

@end
