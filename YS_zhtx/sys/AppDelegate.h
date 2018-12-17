//
//  AppDelegate.h
//  YS_zhtx
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic)BOOL isDBMigrating;

-(void)loadMemu;

@end

