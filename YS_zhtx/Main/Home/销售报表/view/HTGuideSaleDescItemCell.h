//
//  HTGuideSaleDescItemCell.h
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^RETRUNCONTENTOFFSET)(CGPoint);
#import <UIKit/UIKit.h>
#import "HTGuideSaleInfoModel.h"

@interface HTGuideSaleDescItemCell : UITableViewCell

@property (nonatomic,copy) RETRUNCONTENTOFFSET returnOFFset;

@property (weak, nonatomic) IBOutlet UICollectionView *col;

@property (nonatomic,strong) NSArray *dataAar;

@property (nonatomic,strong) HTGuideSaleInfoModel *model;

@end
