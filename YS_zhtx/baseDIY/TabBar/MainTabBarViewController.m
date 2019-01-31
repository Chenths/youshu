//
//  MainTabBarViewController.m
//  AichediandianPro
//
//  Created by FengYiHao on 2017/9/7.
//  Copyright © 2017年 成都任我行汽车服务集团有限公司 版权所有. All rights reserved.
//


#import "MainTabBarViewController.h"
#import "HWTabBar.h"
#import "YHTabBar.h"
#import "HTBaceNavigationController.h"

#import "HTMsgCenterViewController.h"
#import "HTHomePageViewController.h"
#import "HTOrderViewController.h"
#import "HTChargeViewController.h"
#import "HTCustomerViewController.h"
#import "HTMineViewController.h"
#import "HTFastCashierViewController.h"
#import "HTNewPayViewController.h"//要注销
#define homeImg @"g-boss"
#define homeSelectedImg @"g-bossSelected"
#define customerImg @"g-customer"
#define customerSelectedImg @"g-customerSeletected"

#define orderImg @"g-order"
#define orderSelectedImg @"g-orderSelected"
#define meImg @"g-me"
#define meSelectedImg @"g-meSelected"
//#define homeImg @"g-boss"
//#define homeSelectedImg @"g-boss"

UIColor *MainNavBarColor = nil;
UIColor *MainViewColor = nil;

@interface MainTabBarViewController ()<YHTabBarDelegate>

@property (nonatomic, strong) HTHomePageViewController *homePageVC;//首页
@property (nonatomic, strong) HTOrderViewController *orderVC;//订单
@property (nonatomic, strong) HTChargeViewController *chargeVC;//收银
@property (nonatomic, strong) HTFastCashierViewController *fastChargeVC;//收银
@property (nonatomic, strong) HTCustomerViewController *inventoryVC;//库存
@property (nonatomic, strong) HTMineViewController *mineVC;//我的

@property (nonatomic,strong)YHTabBar *hwTabBar;

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initializeUserInterface{
    
    [self setValue:self.hwTabBar forKeyPath:@"tabBar"];
    [self addChildVc:self.homePageVC title:@"首页" image:homeImg selectedImage:homeSelectedImg];
    [self addChildVc:self.inventoryVC title:@"客户" image:customerImg selectedImage:customerSelectedImg];
    [self addChildVc:self.orderVC title:@"订单" image:orderImg selectedImage:orderSelectedImg];
    [self addChildVc:self.mineVC title:@"我的" image:meImg selectedImage:meSelectedImg];
}



- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    //标题
    childVc.title = title;
    
    //设置tabBarItem样式
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"999999"];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#333333"];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    //导航控制器
    HTBaceNavigationController *nav  = [[HTBaceNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString:@"首页"] ) {
        [self.homePageVC loadWarning];
    }
}

#pragma mark - YHTabBarDelegate
- (void)actionEventsOfBarCentItemClickWithTabBar:(YHTabBar *)tabBar{
    
    
    if ([HTShareClass shareClass].isProductActive) {
      [self.selectedViewController  pushViewController:[[HTChargeViewController alloc]init] animated:YES];
    }else{
      [self.selectedViewController  pushViewController:[[HTFastCashierViewController alloc]init] animated:YES];
    }
    
//    HTNewPayViewController *pay = [[HTNewPayViewController alloc] init];
//    [self.selectedViewController pushViewController:pay animated:YES];
}
-(void)msgClicked:(UIButton *)sender{
    HTMsgCenterViewController *vc = [[HTMsgCenterViewController alloc] init];
    [[HTShareClass shareClass].getCurrentNavController pushViewController:vc animated:YES];
}
#pragma mark - getter
- (HTHomePageViewController *)homePageVC{
    if (! _homePageVC) {
        _homePageVC = [[HTHomePageViewController alloc]init];
        _homePageVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
    }
    return _homePageVC;
}

- (HTOrderViewController *)orderVC{
    if (! _orderVC) {
        _orderVC = [[HTOrderViewController alloc]init];
        _orderVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
    }
    return _orderVC;
}

- (HTChargeViewController *)chargeVC{
    if (! _chargeVC) {
        _chargeVC = [[HTChargeViewController alloc]init];
    }
    return _chargeVC;
}

- (HTCustomerViewController *)inventoryVC{
    if (! _inventoryVC) {
        _inventoryVC = [[HTCustomerViewController alloc]init];
        _inventoryVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
    }
    return _inventoryVC;
}
- (HTMineViewController *)mineVC{
    if (! _mineVC) {
        _mineVC = [[HTMineViewController alloc]init];
        _mineVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
    }
    return _mineVC;
}
-(HTRightNavBar *)rightBt{
    if (!_rightBt) {
        _rightBt = [[[NSBundle mainBundle] loadNibNamed:@"HTRightNavBar" owner:nil options:nil]  lastObject];
        [_rightBt baseInit];
        [_rightBt sizeToFit];
        [_rightBt addTarget:self action:@selector(msgClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBt;
}
- (YHTabBar *)hwTabBar{
    if (! _hwTabBar) {
        _hwTabBar = [[YHTabBar alloc]init];
        _hwTabBar.backgroundColor = TabBarBackgroundColor;
        _hwTabBar.delegateYH = self;
    }
    return _hwTabBar;
}
-(HTFastCashierViewController *)fastChargeVC{
    if (!_fastChargeVC) {
        _fastChargeVC = [[HTFastCashierViewController alloc] init];
    }
    return _fastChargeVC;
}


@end
