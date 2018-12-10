//
//  HTSetWarningAlertView.h
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTEarlyWarningModel.h"
#import <UIKit/UIKit.h>

@protocol HTSetWarningAlertViewDelegate <NSObject>

-(void)okClickedWithModel:(HTEarlyWarningModel *)model;

@end
@interface HTSetWarningAlertView : UIView

@property (nonatomic,weak) id <HTSetWarningAlertViewDelegate> delegate;

@property (nonatomic,strong) HTEarlyWarningModel *model;

- (instancetype)initWithAlert;

-(void)show;



@end
