//
//  HTTotleExplainViewController.m
//  有术
//
//  Created by mac on 2017/1/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTExplainViewController.h"
#import "HTTotleExplainViewController.h"
#import "HTExplainModel.h"
@interface HTTotleExplainViewController ()

@end

@implementation HTTotleExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44 + 2, screenSize.width, screenSize.height - 44 - 2 - nav_height)];
    self.view.backgroundColor = RGB(0.96, 0.96, 0.98, 1);
//    self.tabBar.itemSelectedBgColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tabBar.itemTitleColor = [UIColor colorWithHexString:@"#999999"];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHexString:@"#222222"];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
//    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40,( HMSCREENWIDTH/2 - 80)/2, 0, ( HMSCREENWIDTH/2 - 80)/2) tapSwitchAnimated:YES];
//    self.tabBar.itemSelectedBgScrollFollowContent = YES;
//    [self.tabBar setItemSeparatorColor:[UIColor colorWithHexString:@"#FFFFFF"] width:0 marginTop:9 marginBottom:9];
//    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.tabBar.badgeTitleFont = [UIFont systemFontOfSize:10];
    [self.tabBar setNumberBadgeMarginTop:2
                       centerMarginRight:17
                     titleHorizonalSpace:10
                      titleVerticalSpace:4];
    [self loadData];
}

- (void) loadData{
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/guide/load_guide_image.html"] params:nil success:^(id json) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSDictionary *dataArr = [json getDictionArrayWithKey:@"data"];
        
        NSArray *pcArr = [dataArr getArrayWithKey:@"pc"];
        NSMutableArray *pcData = [NSMutableArray array];
        for (NSDictionary *dic in pcArr) {
            HTExplainModel *model = [[HTExplainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [pcData addObject:model];
        }
        
        NSArray *appArr = [dataArr getArrayWithKey:@"app"];
        NSMutableArray *appData = [NSMutableArray array];
        for (NSDictionary *dic in appArr) {
            HTExplainModel *model = [[HTExplainModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [appData addObject:model];
        }
        
        HTExplainViewController *vc1 = [[HTExplainViewController alloc] init];
        vc1.yp_tabItemTitle = @"APP端功能说明";
        vc1.dataArray = appData;
        
        HTExplainViewController *vc2 = [[HTExplainViewController alloc] init];
        vc2.yp_tabItemTitle = @"PC端功能说明";
        vc2.dataArray = pcData;
        
        strongSelf.viewControllers = [NSMutableArray arrayWithObjects:vc1, vc2, nil];
        [MBProgressHUD hideHUD];
        
    } error:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙"];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
    
}
@end
