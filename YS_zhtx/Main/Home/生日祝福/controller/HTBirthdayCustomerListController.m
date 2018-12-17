//
//  HTBirthdayCustomerListController.m
//  有术
//
//  Created by mac on 2018/1/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBirthdayCustomerCell.h"
#import "HTBirthdayCustomerListController.h"
#import "HTNotBirthdayCell.h"
#import "HTCustomerViewController.h"
#import "HTCustomerReportViewController.h"
@interface HTBirthdayCustomerListController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HTBirthdayCustomerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self loadCustData];
}
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        HTNotBirthdayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNotBirthdayCell" forIndexPath:indexPath  ];
        cell.htbirthType = self.htbirthTodayType;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    HTBirthdayCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTBirthdayCustomerCell" forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    cell.htbirthType = self.htbirthTodayType;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return HEIGHT - nav_height - tar_height;
    }
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0 && self.htbirthTodayType == HTBirthToday) {
        if (self.selectectNear) {
            self.selectectNear();
        }
    }else{
        if (self.dataArray.count > 0) {
            HTCustomerReportViewController *detailVc = [[HTCustomerReportViewController alloc] init];
            detailVc.title = @"客户报表";
            detailVc.backImg = @"g-back";
            detailVc.customerType = HTCustomerReportTypeNomal;
            NSDictionary *dic = self.dataArray[indexPath.row];
            HTCustomerListModel *model = [[HTCustomerListModel alloc] init];
            model.custId = [dic getStringWithKey:@"id"];
            model.name = [dic getStringWithKey:@"name"];
            model.custlevel = [dic getStringWithKey:@"level"];
            model.sex_cust = [dic getStringWithKey:@"sex"];
            model.headimg = [dic getStringWithKey:@"header"];
            detailVc.model = model;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
}

#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTBirthdayCustomerCell" bundle:nil] forCellReuseIdentifier:@"HTBirthdayCustomerCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"HTNotBirthdayCell" bundle:nil] forCellReuseIdentifier:@"HTNotBirthdayCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.myTableView.tableFooterView = v ;
    self.myTableView.backgroundColor = [UIColor clearColor];
}
- (void)loadCustData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
        [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/api/festival_birthdy_remind/load_be_about_to_birthday_customer.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.dataArray removeAllObjects];
        if (self.htbirthTodayType == HTBirthToday) {
           [self.dataArray addObjectsFromArray:[json[@"data"] getArrayWithKey:@"today"]];
        }else{
           [self.dataArray addObjectsFromArray:[json[@"data"] getArrayWithKey:@"beGoingTo"]];
        }

        [self.myTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@""];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
#pragma mark - getters and setters
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
