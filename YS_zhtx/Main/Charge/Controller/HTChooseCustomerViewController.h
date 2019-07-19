//
//  HTChooseCustomerViewController.h
//  YS_zhtx
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTCommonViewController.h"
#import "HTCustomerListModel.h"
#import "HTNewFaceNoVipModel.h"
@protocol HTChooseCustomerDelegate <NSObject>
- (void)sendDic:(NSDictionary *)dic WithModel:(HTCustomerListModel *)model; //声明协议方法
@end
@interface HTChooseCustomerViewController : HTCommonViewController
@property (nonatomic, weak) id<HTChooseCustomerDelegate> delegate;
//来自人脸识别 编辑老会员
@property (nonatomic, assign) BOOL isFromFace;
@property (nonatomic, strong) HTNewFaceNoVipModel *faceNoVipModel;
@end
