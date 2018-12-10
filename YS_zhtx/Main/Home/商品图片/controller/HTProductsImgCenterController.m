//
//  HTProductsImgCenterController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTMenuModle.h"
#import "HTProductImgListViewController.h"
#import "HTProductsImgCenterController.h"
#import "HTPostProductStyleController.h"
@interface HTProductsImgCenterController ()
@property (nonatomic,strong) HTMenuModle *model;
@end

@implementation HTProductsImgCenterController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品图片";
    [self initViewControllers];
    
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
    for (int i = 0 ; i < self.tabBar.items.count; i++) {
        YPTabItem *item = self.tabBar.items[i];
        item.contentHorizontalAlignment = i == 0 ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft;
        item.contentEdgeInsets =  i == 0 ? UIEdgeInsetsMake(0, 0, 0, 24) : UIEdgeInsetsMake(0, 24, 0, 0);
    }
}

- (void)initViewControllers {
    for (HTMenuModle *mode in [HTShareClass shareClass].menuArray) {
        if ([mode.moduleName isEqualToString:@"style_lib"]) {
            self.model = mode;
            HTPostProductStyleController *controller1 = [[HTPostProductStyleController alloc] init];
            controller1.yp_tabItemTitle = @"未添加商品图片";
            controller1.menuModel = mode;
            controller1.type = @"model.imgs__blank";
            controller1.color = [UIColor redColor];
            HTPostProductStyleController *controller2 = [[HTPostProductStyleController alloc] init];
            controller2.yp_tabItemTitle = @"已添加商品图片";
            controller2.menuModel = mode ;
            controller2.color = [UIColor blueColor];
            controller2.type = @"model.imgs_not_blank";
            self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
        }
    }
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods

#pragma mark - getters and setters

@end
