//
//  HTGuideSaleDescCollectionCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuideDescModel.h"
#import "HTGuideSaleInfoModel.h"
#import <UIKit/UIKit.h>

@interface HTGuideSaleDescCollectionCell : UICollectionViewCell

@property (nonatomic,strong) HTGuideDescModel *model;

@property (nonatomic,strong) HTGuideSaleInfoModel *dataModel;


@end
