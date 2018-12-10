//
//  HTCommonViewController.h
//  YOUSHU_zhtx
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
typedef void(^HAVEROOT)(BOOL ishave);
#import <UIKit/UIKit.h>

@interface HTCommonViewController : UIViewController

@property (nonatomic,strong) NSString *backImg;

- (void)loadMenuAuthWithString:(NSString *)key Type:(NSString *)type HaveRoot:(HAVEROOT) root;

@end
