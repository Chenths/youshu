//
//  HTCreatorListViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/8/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCreatorListViewController.h"

@interface HTCreatorListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (assign,nonatomic) BOOL isselected;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HTCreatorListViewController

#pragma mark -life cycel

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self loadList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isselected) {
        if (self.selecedItme) {
            self.selecedItme([NSDictionary dictionary]);
        }
    }
    
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellll"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellll"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = [dic getStringWithKey:@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selecedItme) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        self.selecedItme(dic);
        self.isselected = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -CustomDelegate

#pragma EventResponse

#pragma private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
}
-(void)loadList{
    NSDictionary *dic = @{
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [MBProgressHUD showMessage:@""];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@",baseUrl,@"admin/api/person/load_list_4_app.html"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        [self.dataArray addObjectsFromArray:[json[@"data"] getArrayWithKey:@"rows"]];
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

@end
