//
//  HTFaceComingAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTFaceComingAlertView : UIView

- (instancetype)initWithAlertFrame:(CGRect)frame;

+(void)showWithDatas:(NSArray *)dataArray;

@end
