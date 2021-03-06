//
//  HTCustomerProductListController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustomerPrudcutInfo.h"
#import "HTCustomerProductInfoCell.h"
#import "HTCustomerProductListController.h"

@interface HTCustomerProductListController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;





@end

@implementation HTCustomerProductListController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, -nav_height, HMSCREENWIDTH, nav_height)];
    vv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vv];
}
#pragma mark -UITabelViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTCustomerProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTCustomerProductInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    
    [self.tab registerNib:[UINib nibWithNibName:@"HTCustomerProductInfoCell" bundle:nil] forCellReuseIdentifier:@"HTCustomerProductInfoCell"];

    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    titleLabel.text = @"商品列表";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        if (self.beginDate.length > 0 && self.endDate.length > 0) {
            [self loadCatDataWithPage:self.page];
        }else{
        [self loadDataWithPage:self.page];
        }
        
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        if (self.beginDate.length > 0 && self.endDate.length > 0) {
            [self loadCatDataWithPage:self.page];
        }else{
        [self loadDataWithPage:self.page];
        }
    }];
}
-(void)loadCatDataWithPage:(int)page{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(page) forKey:@"pageNo"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:self.companyId forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.beginDate] forKey:@"beginDate"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.endDate] forKey:@"endDate"];
    if ([HTHoldNullObj getValueWithUnCheakValue:self.category].length > 0) {
       [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.category] forKey:@"categories"];
    }
    if ([HTHoldNullObj getValueWithUnCheakValue:self.customType].length > 0) {
        [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.customType] forKey:@"customType"];
    }
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleSaleReport,loadSaleProductReport4App] params:dic success:^(id json) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTCustomerPrudcutInfo *model = [HTCustomerPrudcutInfo yy_modelWithJSON:dic];
            model.name = [NSString stringWithFormat:@"%@(%@%@)", [dic getStringWithKey:@"categorie"],[dic getStringWithKey:@"year"],[dic getStringWithKey:@"season"]];
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [self.tab reloadData];
    } error:^{
        self.page--;
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
-(void)loadDataWithPage:(int) page{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(page) forKey:@"pageNo"];
    [dic setObject:@"10" forKey:@"pageSize"];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setObject:[HTHoldNullObj getValueWithUnCheakValue:self.custId] forKey:@"customerId"];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValuesForKeysWithDictionary:dic];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleCust,loadOrderListByCustomer] params:postDic success:^(id json) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            HTCustomerPrudcutInfo *model = [HTCustomerPrudcutInfo yy_modelWithJSON:dic];
            [self.dataArray addObject:model];
        }
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [self.tab reloadData];
    } error:^{
        self.page--;
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        self.page--;
        [MBProgressHUD hideHUD];
        [self.tab.mj_footer endRefreshing];
        [self.tab.mj_header endRefreshing];
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
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.companyId];
    }
    return _companyId;
}

@end
