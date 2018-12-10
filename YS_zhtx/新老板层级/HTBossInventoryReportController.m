//
//  HTBossInventoryReportController.m
//  有术
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTInventorybasicCell.h"
#import "HTShopInventoryInfoCell.h"
#import "HTBossInventoryReportController.h"
#import "HTCompanyRepotryModel.h"
#import "UIBarButtonItem+Extension.h"
#import "HTRightNavBar.h"
#import "HTMsgCenterViewController.h"
#import "HTShopInventoryInfoViewController.h"
#import "HTSearchTextHeadView.h"

@interface HTBossInventoryReportController ()<UITableViewDelegate,UITableViewDataSource,HTSearchTextHeadViewDelegat>
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HTRightNavBar *rightBt ;

@property (nonatomic,strong) NSMutableArray *shopsData;
@end

@implementation HTBossInventoryReportController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self createRightNavBar];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#59B4A5"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffffff"]}];
    [self laodNoRedNum];
    [self loadData];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HTInventorybasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTInventorybasicCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *datea = self.dataArray[indexPath.section];
        cell.model = datea[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        return cell;
    }else{
        HTShopInventoryInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HTShopInventoryInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *datea = self.dataArray[indexPath.section];
        cell.model = datea[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : [self.dataArray[section] count] ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 135;
    }else{
        return 105;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    HTShopInventoryInfoViewController *vc = [[HTShopInventoryInfoViewController alloc] init];
    HTCompanyRepotryModel *model = self.dataArray[indexPath.section][indexPath.row];
    vc.companyId = [HTHoldNullObj getValueWithUnCheakValue:model.companyId];
    vc.title = model.companyName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *v =  [[UIView alloc] init];
        v.backgroundColor = [UIColor clearColor];
        return  v;
    }
    HTSearchTextHeadView *sectionHead = [[HTSearchTextHeadView alloc] initWithSearchFrame:CGRectMake(0, 0, HMSCREENWIDTH, 44)];
    sectionHead.delegate = self;
    return  sectionHead;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.01f : 44;
}
#pragma mark -CustomDelegate
- (void)searchShopWithString:(NSString *)searchStr{
    if (searchStr.length == 0) {
        if (self.dataArray.count > 1) {
            [self.dataArray removeObjectAtIndex:1];
            [self.dataArray addObject:self.shopsData];
            [self.dataTableView reloadData];
        }
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (HTCompanyRepotryModel *model in self.shopsData) {
        if ([model.companyName rangeOfString:searchStr].length != 0) {
            [arr addObject:model];
        }
    }
    if (arr.count == 0) {
        [MBProgressHUD showError:@"未查找到相关店铺" toView:self.view];
        return;
    }else{
        if (self.dataArray.count > 1) {
         [self.dataArray removeObjectAtIndex:1];
            [self.dataArray addObject:arr];
            [self.dataTableView reloadData];
        }
        
    }
}
#pragma mark -EventResponse
- (void)rightBtClicked:(UIButton *)sender{
    [self.navigationController pushViewController:[[HTMsgCenterViewController alloc] init] animated:YES];
//    [self.navigationController pushViewController:[[HTTotleMessgeViewController alloc] init] animated:YES];
}
#pragma mark -private methods
- (void)laodNoRedNum{
    
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    __weak typeof(self) weakSelf = self;
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        __weak typeof(weakSelf) strongSelf  = weakSelf;
        if (json[@"data"][@"count"]) {
            [strongSelf.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}
- (void)createRightNavBar{
    self.rightBt = [[[NSBundle mainBundle] loadNibNamed:@"HTRightNavBar" owner:nil options:nil]  lastObject];
    self.rightBt.imageName = @"消息-白";
    [self.rightBt baseInit];
    
    [self.rightBt sizeToFit];
    [self.rightBt addTarget:self action:@selector(rightBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
}

- (void)loadData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          };
    [MBProgressHUD showMessage:@"" toView:self.view];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/product_stock/load_boss_companys_stock_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArray removeAllObjects];
        [self.shopsData removeAllObjects];
        HTCompanyRepotryModel *sectionModel = [[HTCompanyRepotryModel alloc] init];
        CGFloat totleNum = 0.0f;
        CGFloat totlePrice = 0.0f;
        for (NSDictionary *dic in [json getArrayWithKey:@"data"]) {
            HTCompanyRepotryModel *model = [[HTCompanyRepotryModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            totleNum += [dic getFloatWithKey:@"crtStock"];
            totlePrice += [dic getFloatWithKey:@"price"];
            [self.shopsData addObject:model];
        }
        sectionModel.crtStock = [NSString stringWithFormat:@"%.0lf",totleNum];
        sectionModel.price = [NSString stringWithFormat:@"%.0lf",totlePrice];
        [self.dataArray addObject:@[sectionModel]];
        [self.dataArray addObject:self.shopsData];
        HTCompanyRepotryModel *model = self.shopsData[0];
        self.navigationItem.title = [HTHoldNullObj getValueWithUnCheakValue:model.companyName];
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"请检查你的网络" toView:self.view];
    }];
}
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTInventorybasicCell" bundle:nil] forCellReuseIdentifier:@"HTInventorybasicCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTShopInventoryInfoCell" bundle:nil] forCellReuseIdentifier:@"HTShopInventoryInfoCell"];
   self.dataTableView.contentInset = self.dataTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight + tar_height, 0); 
    self.dataTableView.tableFooterView = footView;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"术logo-白" highImageName:@"术logo-白" target:self action:nil];
    
}
#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)shopsData{
    if (!_shopsData) {
        _shopsData = [NSMutableArray array];
    }
    return _shopsData;
}



@end
