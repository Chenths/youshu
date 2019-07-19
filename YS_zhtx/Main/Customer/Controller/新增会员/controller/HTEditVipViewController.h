//
//  HTEditVipViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/9/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTMenuModle.h"
#import "HTCommonViewController.h"
#import "HTNewFaceNoVipModel.h"
@interface HTEditVipViewController : HTCommonViewController


@property (nonatomic,strong) NSString *modelId;

@property (nonatomic,strong) HTMenuModle *moduleModel;

@property (nonatomic,strong) NSString *custId;

@property (nonatomic,strong) NSString *phone;
//添加跟进记录使用id
@property (nonatomic,strong) NSString *customerFollowRecordId;

//人脸识别特有
@property (nonatomic,assign) BOOL isFromFace;
@property (nonatomic, strong) HTNewFaceNoVipModel *faceNoVipModel;
@end
