//
//  HTChooseHeadImgViewController.h
//  有术
//
//  Created by mac on 2017/11/3.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTFaceVipModel.h"
#import "HTFaceNotVipModel.h"
#import "HTCommonViewController.h"
typedef void(^SELECTEDIMG)(NSArray *selectedArr);
@interface HTChooseHeadImgViewController : HTCommonViewController

@property (nonatomic,strong) HTFaceVipModel *model;

@property (nonatomic,strong) HTFaceNotVipModel *notVipModel;

@property (nonatomic,copy) SELECTEDIMG selectedImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvHeader;

@end
