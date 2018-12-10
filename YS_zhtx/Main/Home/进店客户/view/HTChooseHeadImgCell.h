//
//  HTChooseHeadImgCell.h
//  有术
//
//  Created by mac on 2017/11/3.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTFaceImgListModel.h"
#import <UIKit/UIKit.h>
#import "HTChangeHeadsModel.h"


@interface HTChooseHeadImgCell : UICollectionViewCell

@property (nonatomic,strong) HTFaceImgListModel *model;

@property (nonatomic,strong) HTChangeHeadsModel *changeModel;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end
