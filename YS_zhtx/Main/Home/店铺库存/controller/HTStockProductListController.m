//
//  HTStockProductListController.m
//  YS_zhtx
//
//  Created by mac on 2018/10/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "MJRefresh.h"
#import "HTNotAddImgProductCell.h"
#import "HTSaleGoodOrBadDetailController.h"
#import "HTStockProductListController.h"

@interface HTStockProductListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomHeight;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;


@end

@implementation HTStockProductListController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self.tab.mj_header beginRefreshing];
}
#pragma mark -UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNotAddImgProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTNotAddImgProductCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTProductStyleModel *model = self.dataArray[indexPath.row];
    HTSaleGoodOrBadDetailController *vc = [[HTSaleGoodOrBadDetailController alloc] init];
    vc.barcode = [HTHoldNullObj getValueWithUnCheakValue:model.barcode];
    vc.companyId = self.companyId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
- (void)createTb{
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.tab registerNib:[UINib nibWithNibName:@"HTNotAddImgProductCell" bundle:nil] forCellReuseIdentifier:@"HTNotAddImgProductCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.tab.tableFooterView = v ;
    self.tab.backgroundColor = [UIColor clearColor];
    self.tabBottomHeight.constant = SafeAreaBottomHeight;
    self.tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        [self loadDataWithPage:self.page withDic:self.requestDic];
    }];
    self.tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadDataWithPage:self.page withDic:self.requestDic];
    }];
    
}
- (void)loadDataWithPage:(int)page withDic:(NSDictionary *)searchDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setObject:@(page) forKey:@"page"];
    [dic setObject:[HTShareClass shareClass].loginModel.companyId forKey:@"companyId"];
    [dic setValuesForKeysWithDictionary:self.requestDic];
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProductStock,loadCompanyStockList4App] params:dic success:^(id json) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [[json getDictionArrayWithKey:@"data"] getArrayWithKey:@"rows"]) {
            HTProductStyleModel *model = [[HTProductStyleModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            model.season = [dic getDictionArrayWithKey:@"season"];
            model.category = [dic getDictionArrayWithKey:@"category"];
            model.productStyleDic = dic;
            [self.dataArray addObject:model];
        }
        [self.tab reloadData];
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        
    } error:^{
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [self.tab.mj_header endRefreshing];
        [self.tab.mj_footer endRefreshing];
        [MBProgressHUD showError:NETERRORSTRING];
    }];
}
#pragma mark - getters and setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSDictionary *)requestDic{
    if (!_requestDic) {
        _requestDic = [NSDictionary dictionary];
    }
    return _requestDic;
}
-(NSString *)companyId{
    if (!_companyId) {
        _companyId = [HTHoldNullObj getValueWithUnCheakValue:self.companyId];
    }
    return _companyId;
}


@end
