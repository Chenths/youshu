//
//  HTOnlineCustomerListViewController.m
//  有术
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTAddVipWithPhoneController.h"
#import "HTCustomerReportViewController.h"
#import "HTChargeViewController.h"
#import "HTOnlineCustomerListViewController.h"
#import "HTCustomerFaceInfoCell.h"
//#import "HTFaceVipModel.h"
#import "HTNewFaceVipModel.h"
//#import "HTFaceNotVipModel.h"
#import "HTNewFaceNoVipModel.h"
#import "MJRefresh.h"
#import "HTMenuModle.h"
#import "HTCustomerFaceVipTableViewCell.h"
#import "HTFaceComingAlertView.h"
#import "HTFastCashierViewController.h"
@interface HTOnlineCustomerListViewController ()<UITableViewDelegate,UITableViewDataSource,HTCustomerFaceInfoCellDelegate, HTCustomerFaceVIPCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@end

@implementation HTOnlineCustomerListViewController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self.dataTableView.mj_header beginRefreshing];
    
}
#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.usrType == HTUSRERVIP) {
        //VIP
        HTCustomerFaceVipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerFaceVipTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (self.dataArray.count > 0) {
            cell.vipModel = self.dataArray[indexPath.row];
            
        }
        return cell;
    }else{
        //非VIP
        HTCustomerFaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerFaceInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        HTNewFaceNoVipModel *model = self.dataArray[indexPath.row];
        model.userVipName = [NSString stringWithFormat:@"%@%ld",@"散客",indexPath.row + 1];
        if (_dataArray.count > 0) {
            cell.notVipModel = self.dataArray[indexPath.row];            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.usrType == HTUSRERVIP) {
        HTNewFaceVipModel *model = self.dataArray[indexPath.row];
//        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
//        HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
//        mmm.custId = model.customerId;
//        vc.customerType = HTCustomerReportTypeNomal;
//        vc.model = mmm;
//        [self.navigationController pushViewController:vc animated:YES];
        UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
        for (UIView *vvv in window.subviews) {
            if ([vvv isKindOfClass:[HTFaceComingAlertView class]]) {
                [vvv removeFromSuperview];
            }
        }
        [HTFaceComingAlertView showWithDatas:@[model] hiddenBottomBtn:YES isNew:NO];
    }else{
//        HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
//        HTNewFaceNoVipModel *model = self.dataArray[indexPath.row];
//        for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
//            if ([mmm.moduleName isEqualToString:@"customer"]) {
//                vc.moduleId = [mmm.moduleId stringValue];
//                break;
//            }
//        }
//        vc.faceModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
        HTNewFaceVipModel *model = self.dataArray[indexPath.row];
        UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
        for (UIView *vvv in window.subviews) {
            if ([vvv isKindOfClass:[HTFaceComingAlertView class]]) {
                [vvv removeFromSuperview];
            }
        }
        [HTFaceComingAlertView showWithDatas:@[model] hiddenBottomBtn:YES isNew:YES];
    }
}
#pragma mark -CustomDelegate
-(void)receptionCustmerWithCell:(HTCustomerFaceInfoCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceVipModel *model = self.dataArray[index.row];
    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
    HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
    mmm.custId = model.customerId;
    vc.customerType = HTCustomerReportTypeNomal;
    vc.model = mmm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)repitBuyWithCell:(HTCustomerFaceInfoCell *)cell{
    if ([HTShareClass shareClass].isProductActive) {
        HTChargeViewController *vc = [[HTChargeViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerId = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }else{
        HTFastCashierViewController *vc = [[HTFastCashierViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerid = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}

- (void)writeCutomerInfoWithCell:(HTCustomerFaceInfoCell *)cell{
    HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceNoVipModel *model = self.dataArray[index.row];
    for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
        if ([mmm.moduleName isEqualToString:@"customer"]) {
            vc.moduleId = [mmm.moduleId stringValue];
            break;
        }
    }
    vc.faceModel = model;
    vc.path = model.snapPath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -CustomDelegate
-(void)receptionCustmerVipWithCell:(HTCustomerFaceInfoCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceVipModel *model = self.dataArray[index.row];
    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
    HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
    mmm.custId = model.customerId;
    vc.customerType = HTCustomerReportTypeNomal;
    vc.model = mmm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)repitBuyVipWithCell:(HTCustomerFaceInfoCell *)cell{
    if ([HTShareClass shareClass].isProductActive) {
        HTChargeViewController *vc = [[HTChargeViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerId = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }else{
        HTFastCashierViewController *vc = [[HTFastCashierViewController alloc] init];
        NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
        HTNewFaceVipModel *model = self.dataArray[index.row];
        vc.phone = model.phone;
        vc.customerid = model.customerId;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}

- (void)writeCutomerInfoVipWithCell:(HTCustomerFaceInfoCell *)cell{
    HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTNewFaceNoVipModel *model = self.dataArray[index.row];
    for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
        if ([mmm.moduleName isEqualToString:@"customer"]) {
            vc.moduleId = [mmm.moduleId stringValue];
            break;
        }
    }
    vc.faceModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -EventResponse

#pragma mark -private methods
- (void)loadData{
    /*
    if (self.usrType == HTUSRERVIP) {
//        @property (nonatomic, copy) NSString * customerId;
//        @property (nonatomic, copy) NSString * customerName;
//        @property (nonatomic, copy) NSString * enterTime;
//        @property (nonatomic, copy) NSString * level;
//        //老图
//        @property (nonatomic, copy) NSString * libPath;
//        @property (nonatomic, copy) NSString * phone;
//        @property (nonatomic, copy) NSString * sex;
//        //新图
//        @property (nonatomic, copy) NSString * snapPath;
        NSArray *vip = @[@{@"customerId" : @"1",
                           @"customerName":@"老王",
                           @"enterTime":@"11:20:33",
                           @"level":@"白银会员",
                           @"libPath":@"",
                           @"phone":@"1821321312",
                           @"sex":@"男",
                           @"snapPath":@""}];
        for (NSDictionary *dic1 in vip) {
            HTNewFaceVipModel *model = [[HTNewFaceVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:model];
        }
    }else{
//        @property (nonatomic, copy) NSString *enterTime;
//        @property (nonatomic, copy) NSString *path;
//        @property (nonatomic, copy) NSString *userVipName;
        NSArray *notVip = @[@{@"enterTime" : @"11:20:33",
                              @"path":@"",
                              @"userVipName":@"傻逼白"}];
        for (NSDictionary *dic1 in notVip) {
            HTNewFaceNoVipModel *model = [[HTNewFaceNoVipModel alloc] init];
            [model setValuesForKeysWithDictionary:dic1];
            [self.dataArray addObject:model];
        }
    }
    [self.dataTableView.mj_header endRefreshing];
    [self.dataTableView reloadData];
         
         */
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFace,faceUserList] params:dic success:^(id json) {
        [self.dataArray removeAllObjects];
        if (self.usrType == HTUSRERVIP) {
            NSArray *vip = [json[@"data"] getArrayWithKey:@"vip"];
            for (NSDictionary *dic1 in vip) {
                HTNewFaceVipModel *model = [[HTNewFaceVipModel alloc] init];
                [model setValuesForKeysWithDictionary:dic1];
                [self.dataArray addObject:model];
            }
        }else{
            NSArray *notVip = [json[@"data"] getArrayWithKey:@"individaul"];
            for (NSDictionary *dic1 in notVip) {
                    HTNewFaceNoVipModel *model = [[HTNewFaceNoVipModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [self.dataArray addObject:model];
            }
        }
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView reloadData];
    } error:^{
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING toView:self.view];
    } failure:^(NSError *error) {
        [self.dataTableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"请检查你的网络" toView:self.view];
    }];
     
}
-(void)createTb{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTCustomerFaceInfoCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerFaceInfoCell"];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTCustomerFaceVipTableViewCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerFaceVipTableViewCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    self.dataTableView.tableFooterView = v ;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    //设置预估行高
    _dataTableView.estimatedRowHeight = 80;
    _dataTableView.rowHeight = UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
