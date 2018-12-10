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
#import "HTFaceVipModel.h"
#import "HTFaceNotVipModel.h"
#import "MJRefresh.h"
#import "HTMenuModle.h"
@interface HTOnlineCustomerListViewController ()<UITableViewDelegate,UITableViewDataSource,HTCustomerFaceInfoCellDelegate>

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
    
        HTCustomerFaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerFaceInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    if (self.usrType == HTUSRERVIP) {
        cell.vipModel = self.dataArray[indexPath.row];
    }else{
        HTFaceNotVipModel *model = self.dataArray[indexPath.row];
        model.userVipName = [NSString stringWithFormat:@"%@%ld",@"散客",indexPath.row + 1];
        cell.notVipModel = self.dataArray[indexPath.row];
    }
        return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.usrType == HTUSRERVIP) {
        HTFaceVipModel *model = self.dataArray[indexPath.row];
        HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
        HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
        mmm.custId = model.uid;
        vc.customerType = HTCustomerReportTypeFacePush;
        vc.model = mmm;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
        HTFaceNotVipModel *model = self.dataArray[indexPath.row];
        for (HTMenuModle *mmm in [HTShareClass shareClass].menuArray) {
            if ([mmm.moduleName isEqualToString:@"customer"]) {
                vc.moduleId = [mmm.moduleId stringValue];
                break;
            }
        }
        vc.faceModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -CustomDelegate
-(void)receptionCustmerWithCell:(HTCustomerFaceInfoCell *)cell{
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTFaceVipModel *model = self.dataArray[index.row];
    HTCustomerReportViewController *vc = [[HTCustomerReportViewController alloc] init];
    HTCustomerListModel *mmm = [[HTCustomerListModel alloc] init];
    mmm.custId = model.uid;
    vc.customerType = HTCustomerReportTypeFacePush;
    vc.model = mmm;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)repitBuyWithCell:(HTCustomerFaceInfoCell *)cell{
    HTChargeViewController *vc = [[HTChargeViewController alloc] init];
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTFaceVipModel *model = self.dataArray[index.row];
    vc.phone = model.phone_cust;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)writeCutomerInfoWithCell:(HTCustomerFaceInfoCell *)cell{
    HTAddVipWithPhoneController *vc = [[HTAddVipWithPhoneController alloc] init];
    NSIndexPath *index = [self.dataTableView indexPathForCell:cell];
    HTFaceNotVipModel *model = self.dataArray[index.row];
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
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleFace,faceUserList] params:dic success:^(id json) {
        [self.dataArray removeAllObjects];
        if (self.usrType == HTUSRERVIP) {
            NSArray *vip = [json[@"data"] getArrayWithKey:@"vip"];
            for (NSArray *arr in vip) {
                if (arr.count > 0) {
                    NSDictionary *dic1 = [arr firstObject];
                    HTFaceVipModel *model = [[HTFaceVipModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    for (NSDictionary  *dic in arr) {
                        [model.imgs addObject:[dic getStringWithKey:@"path"]];
                    }
                    [self.dataArray addObject:model];
                }
            }
        }else{
            NSArray *notVip = [json[@"data"] getArrayWithKey:@"user"];
            for (NSArray *arr in notVip) {
                if (arr.count > 0) {
                    NSDictionary *dic1 = [arr firstObject];
                    HTFaceNotVipModel *model = [[HTFaceNotVipModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    for (NSDictionary  *dic in arr) {
                        [model.imgs addObject:[dic getStringWithKey:@"path"]];
                    }
                    [self.dataArray addObject:model];
                }
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
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    self.dataTableView.tableFooterView = v ;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.dataTableView.estimatedRowHeight = 300;
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
