//
//  HTGHomeHeadCollectionViewCell.h
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTHomeDataModel.h"

@protocol HTGHomeHeadCollectionViewCellDelegate<NSObject>

-(void)guiderBtClicked;

@end

#import <UIKit/UIKit.h>

@interface HTGHomeHeadCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) id <HTGHomeHeadCollectionViewCellDelegate> delegate;
@property (nonatomic,strong) HTHomeDataModel *model;

@end
