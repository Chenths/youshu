//
//  HTEditPruductImgCollectionCell.h
//  有术
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTPostImageModel.h"
#import <UIKit/UIKit.h>

@interface HTEditPruductImgCollectionCell : UICollectionViewCell

@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,strong) HTPostImageModel *model;

@end
