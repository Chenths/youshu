//
//  HTGuiderListSaleController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderSaleListItemCell.h"
#import "HTGuiderListSaleController.h"
#import "HTShopingGuideReportController.h"
#import "HTGuiderListModel.h"
@interface HTGuiderListSaleController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation HTGuiderListSaleController



#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工报表";
    [self createTb];
    [self loadData];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTGuiderSaleListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTGuiderSaleListItemCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 1, 0);
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTShopingGuideReportController *vc = [[HTShopingGuideReportController alloc] init];
    HTGuiderListModel *model = self.dataArray[indexPath.row];
    vc.guiderId = model.guiderId;
    vc.companyId = self.companyId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTGuiderSaleListItemCell" bundle:nil] forCellReuseIdentifier:@"HTGuiderSaleListItemCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
}
-(void)loadData{
    NSDictionary *dic = @{
                          @"companyId":self.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleApiPersonReport,loadAllPersonReport] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        for (int i = 0; i < [json getArrayWithKey:@"data"].count; i++) {
            NSDictionary *dic = [json getArrayWithKey:@"data"][i];
            HTGuiderListModel *model = [HTGuiderListModel yy_modelWithJSON:dic];
            model.index = i;
            [self.dataArray addObject:model];
        }
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
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
        _companyId = [[HTShareClass shareClass].loginModel.companyId stringValue];
    }
    return _companyId;
}
@end
