//
//  HTBossSelecteShopsController.m
//  有术
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTShopListMultitermContrastCell.h"
#import "HTBossSelecteShopsController.h"
#import "HTCompanyListModel.h"
@interface HTBossSelecteShopsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *selectedArray;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@end

@implementation HTBossSelecteShopsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择店铺";
    [self createTb];
    [self loadCompanyListData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}
- (BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
#pragma mark -life cycel

#pragma mark -UITabelViewDelegate
#pragma mark -UITabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTShopListMultitermContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTShopListMultitermContrastCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTCompanyListModel *model = self.dataArray[indexPath.row];
    if (self.selectedArray.count == self.maxSelected && !model.isSelected) {
       
        [MBProgressHUD showError: [NSString stringWithFormat:@"最多支持%d家店铺的数据对比",self.maxSelected]];
        return ;
    }
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
    [self.selectedArray addObject:model];
    }else{
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
        }
    }
    
    [self.dataTableView reloadData];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

- (IBAction)okBtClicked:(id)sender {
    if (self.selectedCompany && self.maxSelected == 1) {
        if (self.selectedArray.count == 0) {
            [MBProgressHUD showError:@"请选择店铺"];
            return;
        }
        if (self.selectedArray.count == 1) {
            self.selectedCompany([self.selectedArray firstObject]);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return;
    }
    if (self.selectedArray.count < 2) {
        [MBProgressHUD showError:@"请选择至少两家店铺进行对比"];
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (HTCompanyListModel *model in self.selectedArray) {
        NSDictionary *dic = @{
                              @"id":[HTHoldNullObj getValueWithUnCheakValue:model.companyId],
                              @"name":[HTHoldNullObj getValueWithUnCheakValue:model.name]
                              };
        [arr addObject:dic];
    }
    if (self.selectedCompanys.count > 0) {
        if (self.selectedsComs) {
            self.selectedsComs(arr);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"type":@"1",
                          @"companyIds":[arr arrayToJsonString]
                          };
    [MBProgressHUD showMessage:@"请稍等..."];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"save_compare_company_id_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];

}
#pragma mark -private methods
- (void)createTb{
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTShopListMultitermContrastCell" bundle:nil] forCellReuseIdentifier:@"HTShopListMultitermContrastCell"];
    self.dataTableView.tableFooterView = footView;
    self.dataTableView.separatorStyle =  UITableViewCellAccessoryNone;
}
-(void)loadCompanyListData{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId,
                          @"type":@"0"
                          };
    [MBProgressHUD showMessage:@"  "];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCompany,@"load_children_id_4_app.html"] params:dic success:^(id json) {
        
        NSArray *companys = [json getArrayWithKey:@"data"];
        for (NSDictionary *dic  in companys) {
            HTCompanyListModel *model = [[HTCompanyListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if (self.selectedCompanys.count > 0) {
                for (NSDictionary *dict in self.selectedCompanys) {
                    if ([[dict getStringWithKey:@"id"] isEqualToString:[HTHoldNullObj getValueWithUnCheakValue: model.companyId]]) {
                        model.isSelected = YES;
                        [self.selectedArray addObject:model];
                    }
                }
            }
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.dataTableView reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return  _selectedArray;
}
@end
