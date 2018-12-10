//
//  HTScanLogistiscViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTScanTools.h"
#import "HTScanLogistiscViewController.h"

@interface HTScanLogistiscViewController ()<HTScanCodeDelegate>

@property (nonatomic,strong) HTScanTools *scanTool;

@end

@implementation HTScanLogistiscViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码";
    [self scanTool];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scanTool.session startRunning];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scanTool.session stopRunning];
}
/**
 处理扫码数据
 
 @param result 扫码所得条码
 */
-(void) handleScanResultStr:(NSString *) result{
    
    if (self.scanResult) {
        self.scanResult(result);
    }
    [self.scanTool.session stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
}

-(HTScanTools *)scanTool{
    if (!_scanTool ) {
        _scanTool = [[HTScanTools alloc] init];
        _scanTool.frame = CGRectMake(0, 0, HMSCREENWIDTH, HEIGHT - nav_height);
        _scanTool.delegate = self;
        [_scanTool startScanInView:self.view];
        UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫码线"]];
        imgview.center = CGPointMake(HMSCREENWIDTH * 0.5, (HEIGHT - nav_height) / 2);
        [self.view addSubview:imgview];
    }
    return _scanTool;
}

@end
