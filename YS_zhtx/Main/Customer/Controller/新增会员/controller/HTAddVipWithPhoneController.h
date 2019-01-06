//
//  HTAddVipWithPhoneController.h
//  YS_zhtx
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTNewFaceNoVipModel.h"
#import "HTCommonViewController.h"

@interface HTAddVipWithPhoneController : HTCommonViewController

@property (nonatomic,strong) NSString *moduleId;

@property (nonatomic,strong) HTNewFaceNoVipModel *faceModel;
@property (nonatomic, assign) NSString *path;
@end
