//
//  HTPostProductStyleController.m
//  有术
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTPostProductStyleController.h"
#import "MJRefresh.h"
#import "HTProductStyleModel.h"
#import "HTNotAddImgProductCell.h"
#import "HTNewEditProductStyleController.h"
@interface HTPostProductStyleController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSDictionary *searchDic;

@end

@implementation HTPostProductStyleController

#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTb];
    [self.dataTableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataTableView.mj_header beginRefreshing];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"model.imgs__blank"]) {
        HTNewEditProductStyleController *vc = [[HTNewEditProductStyleController alloc] init];
        vc.model = self.dataArray[indexPath.row];
        vc.controllertype = ControllerPost;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.type isEqualToString:@"model.imgs_not_blank"]){
        HTNewEditProductStyleController *vc = [[HTNewEditProductStyleController alloc] init];
        vc.model = self.dataArray[indexPath.row];
        vc.controllertype = ControllerDetail;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
#pragma mark -CustomDelegate
- (void)searchProductStyleWithDic:(NSDictionary *)dic1{
    self.searchDic = dic1;
    [self.dataTableView.mj_header beginRefreshing];
}
#pragma mark -EventResponse
-(void)addVipClicked:(UIButton *)sender{
    
}
#pragma mark -private methods
- (void)createTb{
    self.dataTableView.delegate = self;
    self.dataTableView.dataSource = self;
    [self.dataTableView registerNib:[UINib nibWithNibName:@"HTNotAddImgProductCell" bundle:nil] forCellReuseIdentifier:@"HTNotAddImgProductCell"];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    self.dataTableView.tableFooterView = v ;
    self.dataTableView.backgroundColor = [UIColor clearColor];
    self.dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1 ;
        [self loadDataWithPage:self.page withDic:self.searchDic];
    }];
    self.dataTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self loadDataWithPage:self.page withDic:self.searchDic];
    }];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"g-goodsAdd" highImageName:@"g-goodsAdd" target:self action:@selector(addVipClicked:)];
    
}
- (void)loadDataWithPage:(int)page withDic:(NSDictionary *)searchDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if ([self.type isEqualToString:@"model.imgs__blank"]) {
        [dic setObject:@"0" forKey:@"model.type"];
    }else if ([self.type isEqualToString:@"model.imgs_not_blank"]){
        [dic setObject:@"1" forKey:@"model.type"];
    }
    [dic setObject:self.menuModel.moduleId forKey:@"moduleId"];
    [dic setObject:@"10" forKey:@"rows"];
    [dic setObject:@(page) forKey:@"page"];
    [dic setValuesForKeysWithDictionary:searchDic];
    
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleProduct,loadImgStyleLibList] params:dic success:^(id json) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dic in [json[@"data"] getArrayWithKey:@"rows"]) {
            
            HTProductStyleModel *model = [[HTProductStyleModel alloc] init];

            [model setValuesForKeysWithDictionary:dic];
            model.season = [dic getDictionArrayWithKey:@"season"];
            model.category = [dic getDictionArrayWithKey:@"category"];
            model.productStyleDic = dic;
            [self.dataArray addObject:model];
        }
        [self.dataTableView reloadData];
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
        
    } error:^{
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [self.dataTableView.mj_header endRefreshing];
        [self.dataTableView.mj_footer endRefreshing];
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
- (NSDictionary *)searchDic{
    if (!_searchDic) {
        _searchDic = [NSDictionary dictionary];
    }
    return _searchDic;
}
@end
