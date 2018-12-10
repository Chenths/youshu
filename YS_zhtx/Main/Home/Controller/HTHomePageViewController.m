//
//  YHHomePageViewController.m
//  YouShu
//
//  Created by FengYiHao on 2018/3/14.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//
#import "HTGHomeItemsCollectionCell.h"
#import "HTGHomeHeadCollectionViewCell.h"
#import "HTHomePageViewController.h"
#import "HTMyShopCustomersCenterController.h"
#import "HTShopInventoryInfoViewController.h"
#import "HTHomeItemsModel.h"
#import "HTShopingGuideReportController.h"
#import "HTFaceComingAlertView.h"
#import "HTCustomerButton.h"
#import "HTGSaleReportViewController.h"
#import "HTCustomersInfoReportController.h"
#import "HTGuiderListSaleController.h"
#import "HTFestivalViewController.h"
#import "HTBirthDayCustomerCenterController.h"
#import "HTProductsImgCenterController.h"
#import "HTChangeProductHomeViewController.h"
#import "HTHomeDataModel.h"
#import "GDataXMLNode.h"
#import "HTMsgCenterViewController.h"
#import "MainTabBarViewController.h"
#import "HTDayChartReportViewController.h"
#import "HTWarningWebViewController.h"
#import "HTWarningModel.h"
@interface HTHomePageViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,HTGHomeHeadCollectionViewCellDelegate,UITabBarControllerDelegate,UITabBarDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *dataCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstains;

@property (strong,nonatomic) NSMutableArray *dataArray;

@property (strong,nonatomic) HTHomeDataModel *dataModel;

@property (nonatomic,strong) NSMutableArray *customerWarning;

@property (nonatomic,strong) NSMutableArray *sellWarning;

@end

@implementation HTHomePageViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isBoss) {
        self.title = self.companyName;
        [self loadComanyRestand];
    }
    [self createTb];
    [self createData];
    [self loadWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isBoss) {
      [self laodNoRedNum];
    }
    if ([HTShareClass shareClass].isGuide) {
        [self loadEmployeeData];
    }else{
        [self loadBossData];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
}
#pragma mark -UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  section == 0 ? 1 : self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        HTGHomeHeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTGHomeHeadCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.dataModel;
        return cell;
    }else{
        HTGHomeItemsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HTGHomeItemsCollectionCell" forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
        HTHomeItemsModel *model = self.dataArray[indexPath.row];
        if ([model.title isEqualToString:@"销售报表"] ){
            cell.warningArr = self.sellWarning;
        }else if ([model.title isEqualToString:@"客群分析"]) {
            cell.warningArr = self.customerWarning;
        }else{
            cell.warningArr = @[];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(HMSCREENWIDTH, 310);
    }else{
        return CGSizeMake((HMSCREENWIDTH - 0.1) * 0.5 , 90);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        HTHomeItemsModel *model = self.dataArray[indexPath.row];
        if ([model.title isEqualToString:@"进店客户"]) {
            HTMyShopCustomersCenterController *vc = [[HTMyShopCustomersCenterController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"店铺库存"]){
            HTShopInventoryInfoViewController *vc = [[HTShopInventoryInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"销售报表"]){
            HTGSaleReportViewController *vc = [[HTGSaleReportViewController alloc] init];
            vc.companyId = self.companyId;
            vc.warningArr = self.sellWarning;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"客群分析"]){
            HTCustomersInfoReportController *vc = [[HTCustomersInfoReportController alloc] init];
            vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
            vc.warningArr = self.customerWarning;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"员工报表"]){
            HTGuiderListSaleController *vc = [[HTGuiderListSaleController alloc] init];
            vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"节日提醒"]){
            HTFestivalViewController *vc = [[HTFestivalViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"生日祝福"]){
            HTBirthDayCustomerCenterController *vc = [[HTBirthDayCustomerCenterController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"商品图片"]){
            HTProductsImgCenterController*vc = [[HTProductsImgCenterController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"商品退换"]){
            HTChangeProductHomeViewController*vc = [[HTChangeProductHomeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"学习中心"]){
            HTWarningWebViewController *vc = [[HTWarningWebViewController alloc] init];
            vc.finallUrl = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title isEqualToString:@"今日报表"]){
            HTDayChartReportViewController *vc = [[HTDayChartReportViewController alloc] init];
            vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
    }
}
- (NSString *)dataFilePath:(BOOL)forSave {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"test.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"xml" ofType:@"xml"];
    }
    
}
#pragma mark -CustomDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 0) {
        //在这里进行其他的操作。
        [self loadWarning];
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *nav = (id)viewController;
    if ([nav.topViewController isKindOfClass:[self class]]) {
        [self loadWarning];
    }
}
-(void)guiderBtClicked{
    
    if ([HTShareClass shareClass].isGuide) {
        HTShopingGuideReportController *vc = [[HTShopingGuideReportController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HTGuiderListSaleController *vc = [[HTGuiderListSaleController alloc] init];
        vc.companyId = self.companyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
  
}
#pragma mark -EventResponse

#pragma mark -private methods
-(void)loadWarning{
    NSDictionary *dic = @{
                          @"companyId" :self.companyId
                          };
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [self.customerWarning removeAllObjects];
    [self.sellWarning removeAllObjects];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleWarn,dateMenuWarningQuestion] params:dic success:^(id json) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        NSArray *customer = [json[@"data"] getArrayWithKey:@"customer"];
        NSArray *sell = [json[@"data"] getArrayWithKey:@"sell"];
        
        NSDictionary *sellIndexs =@{
                                    @"hygxl":[NSIndexPath indexPathForRow:2 inSection:1],
                                    @"ldl":[NSIndexPath indexPathForRow:3 inSection:1],
                                    @"thl":[NSIndexPath indexPathForRow:3 inSection:1],
                                    @"hhl":[NSIndexPath indexPathForRow:3 inSection:1],
                                    };
        NSDictionary *customerIndexs = @{
                                         @"hyhy":[NSIndexPath indexPathForRow:0 inSection:4]
                                         };
        for (NSDictionary *dic in customer) {
            HTWarningModel *model = [[HTWarningModel alloc] init];
            if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basethl]){
                model.warningStr = [NSString stringWithFormat:@"%@高于标准%@%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.thl,@"%"];
                if ([customerIndexs.allKeys containsObject:@"thl"]) {
                  model.waringIndex = customerIndexs[@"thl"];
                }
            }else if ( [[dic getStringWithKey:@"warningtypecode"] isEqualToString:basehhl] ) {
                model.warningStr = [NSString stringWithFormat:@"%@高于标准%@%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.hhl,@"%"];
                if ([customerIndexs.allKeys containsObject:@"hhl"]) {
                    model.waringIndex = customerIndexs[@"hhl"];
                }
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basehygxl] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.vipgxl,@"%"];
                if ([customerIndexs.allKeys containsObject:@"hygxl"]) {
                    model.waringIndex = customerIndexs[@"hygxl"];
                }
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basehyhy] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.hyhy];
                model.waringIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:baseldl] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.ldl];
                if ([customerIndexs.allKeys containsObject:@"ldl"]) {
                    model.waringIndex = customerIndexs[@"ldl"];
                }
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basezkl] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.zkl];
                if ([customerIndexs.allKeys containsObject:@"zkl"]) {
                    model.waringIndex = customerIndexs[@"zkl"];
                }
            }
            [self.customerWarning addObject:model];
        }
        for (NSDictionary *dic in sell) {
            HTWarningModel *model = [[HTWarningModel alloc] init];
            if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basethl]){
                 model.warningStr = [NSString stringWithFormat:@"%@高于标准%@%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.thl,@"%"];
                if ([sellIndexs.allKeys containsObject:@"thl"]) {
                    model.waringIndex = sellIndexs[@"thl"];
                }
            }else if ( [[dic getStringWithKey:@"warningtypecode"] isEqualToString:basehhl] ) {
                model.warningStr = [NSString stringWithFormat:@"%@高于标准%@%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.hhl,@"%"];
                if ([sellIndexs.allKeys containsObject:@"hhl"]) {
                    model.waringIndex = sellIndexs[@"hhl"];
                }
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basehygxl] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.vipgxl,@"%"];
                if ([sellIndexs.allKeys containsObject:@"hygxl"]) {
                    model.waringIndex = sellIndexs[@"hygxl"];
                }
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basehyhy] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.hyhy];
                model.waringIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:baseldl] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.ldl];
                if ([sellIndexs.allKeys containsObject:@"ldl"]) {
                    model.waringIndex = sellIndexs[@"ldl"];
                }
            }else if ([[dic getStringWithKey:@"warningtypecode"] isEqualToString:basezkl] ){
                model.warningStr = [NSString stringWithFormat:@"%@低于标准%@",[dic getStringWithKey:@"warningtypename"],[HTShareClass shareClass].reportWarnStandard.zkl];
                if ([sellIndexs.allKeys containsObject:@"zkl"]) {
                    model.waringIndex = sellIndexs[@"zkl"];
                }
            }
            [self.sellWarning addObject:model];
        }
        [strongSelf.dataCollectionView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
- (void)loadComanyRestand{
    NSDictionary *dic = @{
                          @"key":@"",
                          @"companyId":self.companyId ? self.companyId : [HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/api/config/load_config_4_app_default.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *dataArr = [json getDictionArrayWithKey:@"data"];
        [[HTShareClass shareClass].reportWarnStandard setValuesForKeysWithDictionary:dataArr];
        [HTShareClass shareClass].isProductStockActive = [dataArr[@"data"][@"isProductStockActive"] boolValue];
        [HTShareClass shareClass].isProductActive = [dataArr[@"data"][@"isProductActive"] boolValue];
        if ([HTShareClass shareClass].isGuide) {
            [self loadEmployeeData];
        }else{
            [self loadBossData];
        }
        [self loadWarning];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}

-(void)loadBossData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadOrderBossReport] params:dic success:^(id json) {
        self.dataModel = [HTHomeDataModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self.dataCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } error:^{
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)loadEmployeeData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadOrderEmployeeReport] params:dic success:^(id json) {
        self.dataModel = [HTHomeDataModel yy_modelWithJSON:[json getDictionArrayWithKey:@"data"]];
        [self.dataCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } error:^{
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)createTb{
    if (self.backImg.length == 0) {
      self.backImg = @"";
    }
    self.dataCollectionView.delegate = self;
    self.dataCollectionView.dataSource = self;
//    self.dataCollectionView.contentInset = self.dataCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight + tar_height, 0);
//    设置layout
    self.bottomConstains.constant = SafeAreaBottomHeight + tar_height;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.001f;
    layout.minimumInteritemSpacing = 0.001f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.dataCollectionView.collectionViewLayout = layout;
    self.dataCollectionView.showsVerticalScrollIndicator = NO;
    self.dataCollectionView.showsHorizontalScrollIndicator = NO;
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTGHomeHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HTGHomeHeadCollectionViewCell"];
    [self.dataCollectionView registerNib:[UINib nibWithNibName:@"HTGHomeItemsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HTGHomeItemsCollectionCell"];
    if (self.isBoss) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    if (!self.isBoss) {
      self.navigationItem.title = [[HTShareClass shareClass].loginModel.company getStringWithKey:@"fullname"];
    }
}
-(void)createData{
    
    NSArray *ii = @[@"g-itemsShopCustomer",@"g-itemsInventory",@"g-dayReport",@"g-itemsSaleReport",@"g-itemsCustomerReport",@"g-itemsGuiderrReport",@"g-itemsGoodsExchange",@"g-itemsFestival",@"g-itemsBirth",@"g-itemsGoddsImg",@"g-itemsLearnCenter"];
    NSArray *tt = @[@"进店客户",@"店铺库存",@"今日报表",@"销售报表",@"客群分析",@"员工报表",@"商品退换",@"节日提醒",@"生日祝福",@"商品图片",@"学习中心"];
    NSMutableArray *imgs = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    if (self.isBoss) {
        [titles  addObjectsFromArray:@[@"今日报表",@"销售报表",@"客群分析",@"员工报表",@"学习中心"]];
        [imgs addObjectsFromArray:@[@"g-dayReport",@"g-itemsSaleReport",@"g-itemsCustomerReport",@"g-itemsGuiderrReport",@"g-itemsLearnCenter"]];
    }else{
    [imgs addObjectsFromArray:ii];
    [titles addObjectsFromArray:tt];
    if (![HTShareClass shareClass].face) {
        [imgs removeObject:@"g-itemsShopCustomer"];
        [titles removeObject:@"进店客户"];
    }
    if (![HTShareClass shareClass].isProductActive) {
        [imgs removeObject:@"g-itemsInventory"];
        [titles removeObject:@"店铺库存"];
        [imgs removeObject:@"g-itemsGoddsImg"];
        [titles removeObject:@"商品图片"];
    }
    if (![HTShareClass shareClass].isProductStockActive) {
        if ([imgs containsObject:@"g-itemsInventory"]) {
          [imgs removeObject:@"g-itemsInventory"];
        }
        if ([titles containsObject:@"店铺库存"]) {
          [titles removeObject:@"店铺库存"];
        }
    }
    }
    for (int i = 0; i < imgs.count; i++) {
        HTHomeItemsModel *model = [[HTHomeItemsModel alloc] init];
        model.imgStr = imgs[i];
        model.title = titles[i];
        [self.dataArray addObject:model];
    }
    [self.dataCollectionView reloadData];
    
    
}
- (void)laodNoRedNum{
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        if (json[@"data"][@"count"]) {
            MainTabBarViewController *tab = (id)[[UIApplication sharedApplication].delegate window].rootViewController;
            [tab.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}
-(NSMutableArray *)customerWarning{
    if (!_customerWarning) {
        _customerWarning = [NSMutableArray array];
    }
    return _customerWarning;
}
-(NSMutableArray *)sellWarning{
    if (!_sellWarning) {
        _sellWarning = [NSMutableArray array];
    }
    return _sellWarning;
}
@end
