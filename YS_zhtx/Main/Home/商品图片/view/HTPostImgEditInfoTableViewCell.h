//
//  HTPostImgEditInfoTableViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTPostImageModel.h"
#import <UIKit/UIKit.h>
@class HTPostImgEditInfoTableViewCell;

@protocol HTPostImgEditInfoTableViewCellDelegate  <NSObject>

- (void)deleteItemWithCell:(HTPostImgEditInfoTableViewCell *)cell;

- (void)changeImgTapWithCell:(HTPostImgEditInfoTableViewCell *)cell;

@end
@interface HTPostImgEditInfoTableViewCell : UITableViewCell

@property (nonatomic,strong) HTPostImageModel *model;

@property (nonatomic,assign) ControllerType controllerType;

@property (nonatomic,weak) id <HTPostImgEditInfoTableViewCellDelegate> delegate;
@end
