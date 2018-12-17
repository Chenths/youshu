//
//  YHTabBar.h
//  ZHTX_YouShu
//
//  Created by FengYiHao on 2018/3/15.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHTabBar;

@protocol YHTabBarDelegate<NSObject>

- (void)actionEventsOfBarCentItemClickWithTabBar:(YHTabBar *)tabBar;

@end

@interface YHTabBar : UITabBar

@property (nonatomic, weak) id<YHTabBarDelegate> delegateYH;

@end
