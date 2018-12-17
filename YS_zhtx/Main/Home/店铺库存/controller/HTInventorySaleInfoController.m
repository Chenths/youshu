//
//  HTInventorySaleInfoController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTSaleGoodOrBadCell.h"
#import "HTInventorySaleInfoController.h"
#import "HTTurnListTpyeInViewCell.h"
#import "HTTurnListTpyeOutViewCell.h"
#import "HTStackSaleProductModel.h"
#import "HTSaleGoodOrBadDetailController.h"
@interface HTInventorySaleInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int page;

@end

@implementation HTInventorySaleInfoController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
#pragma mark -UITabelViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTSaleGoodOrBadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSaleGoodOrBadCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTSaleGoodOrBadDetailController *vc = [[HTSaleGoodOrBadDetailController alloc] init];
    HTStackSaleProductModel *model = self.dataArray[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
-(void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTSaleGoodOrBadCell" bundle:nil] forCellReuseIdentifier:@"HTSaleGoodOrBadCell"];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tab.estimatedRowHeight = 300;
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadDataWithPage:self.page];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self loadDataWithPage:self.page];
    }];
}
-(void)loadDataWithPage:(int)page{
    NSDictionary *dic = @{
                          @"companyId":self.companyId,
                          @"page":@(page),
                          @"rows":@"10"
                          };
    NSString *url = [NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock, self.saletype == HTSaleBad ?  loadNeedReturnProdcutList : loadProductSaleCycelList];
    [HTHttpTools POST:url params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            [self.dataArray addObject:[HTStackSaleProductModel yy_modelWithJSON:dic]];
        }
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [self.tab reloadData];
    } error:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:NETERRORSTRING];
        self.page--;
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
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
