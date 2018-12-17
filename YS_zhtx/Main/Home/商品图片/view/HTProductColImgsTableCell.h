//
//  HTProductColImgsTableCell.h
//  有术
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTPostImageModel.h"
#import <UIKit/UIKit.h>

@protocol HTProductColImgsTableCellDelegate <NSObject>

-(void)selectedTopImgWithModel:(HTPostImageModel *)model;

@end

@interface HTProductColImgsTableCell : UITableViewCell

@property (nonatomic,assign) BOOL isEdit;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) id <HTProductColImgsTableCellDelegate> delegate;

@end
