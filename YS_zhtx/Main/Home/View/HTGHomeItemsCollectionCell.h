//
//  HTGHomeItemsCollectionCell.h
//  YS_zhtx
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTHomeItemsModel.h"
#import <UIKit/UIKit.h>
#import "HTWarningModel.h"

@interface HTGHomeItemsCollectionCell : UICollectionViewCell

@property (nonatomic,strong) HTHomeItemsModel *model;

@property (nonatomic,strong) NSArray *warningArr;

@property (nonatomic,strong) NSString *companyId;

@end
