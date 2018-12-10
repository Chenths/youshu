//
//  HTNoticeViewController.m
//  有术
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTNoticeViewController.h"

@interface HTNoticeViewController ()

@end

@implementation HTNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    NSString *currentVersion =  [NSBundle mainBundle].infoDictionary[versionKey];
//    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:NOTICETAPKEY];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
